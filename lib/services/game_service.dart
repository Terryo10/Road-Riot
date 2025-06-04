// File: lib/services/game_service.dart
import 'dart:math';
import '../repositories/game_repository.dart';
import '../models/game_models.dart';

class GameService {
  final GameRepository repository;
  final Random random = Random();
  
  bool _isGameRunning = false;
  int _score = 0;
  int _coins = 0;
  double _gameSpeed = 1.0;
  double _timeSinceLastScore = 0.0;
  
  // Player position for collision detection
  double _playerLane = 2.0;
  double _playerHealth = 100.0;
  
  final List<Enemy> _enemies = [];
  final List<Obstacle> _obstacles = [];
  final List<CoinPickup> _coinPickups = [];
  final List<Bullet> _bullets = [];

  GameService({required this.repository});

  void startGame() {
    _isGameRunning = true;
    _score = 0;
    _coins = 0;
    _gameSpeed = 1.0;
    _timeSinceLastScore = 0.0;
    _playerLane = 2.0;
    _playerHealth = 100.0;
    _enemies.clear();
    _obstacles.clear();
    _coinPickups.clear();
    _bullets.clear();
  }

  void pauseGame() {
    _isGameRunning = false;
  }

  void resumeGame() {
    _isGameRunning = true;
  }

  void endGame() {
    _isGameRunning = false;
    repository.addCoins(_coins);
    repository.saveProgress();
  }

  void updatePlayerPosition(double lane) {
    _playerLane = lane;
  }

  Map<String, dynamic> updateGame(double deltaTime) {
    if (!_isGameRunning) return _getCurrentGameData();

    _timeSinceLastScore += deltaTime;

    // Update score more slowly - only every 0.1 seconds
    if (_timeSinceLastScore >= 0.1) {
      _score += (_gameSpeed * 2).round(); // Reduced score increment
      _timeSinceLastScore = 0.0;
    }

    // Increase speed more gradually
    _gameSpeed += deltaTime * 0.02; // Reduced speed increment

    // Update all game objects
    _updateEnemies(deltaTime);
    _updateObstacles(deltaTime);
    _updateBullets(deltaTime);
    _updateCoinPickups(deltaTime);
    _checkCollisions();

    return _getCurrentGameData();
  }

  void spawnEnemy() {
    if (_enemies.length < 4) {
      final enemyType = EnemyType.values[random.nextInt(EnemyType.values.length)];
      _enemies.add(Enemy(
        lane: random.nextInt(6).toDouble(),
        y: -100,
        type: enemyType,
        health: _getHealthForEnemyType(enemyType),
      ));
    }
  }

  void spawnObstacle() {
    if (_obstacles.length < 3) {
      _obstacles.add(Obstacle(
        lane: random.nextInt(6).toDouble(),
        y: -100,
        type: ObstacleType.values[random.nextInt(ObstacleType.values.length)],
      ));
    }
  }

  void addBullet(double x, double y) {
    _bullets.add(Bullet(x: x, y: y));
  }

  void _updateEnemies(double deltaTime) {
    for (int i = _enemies.length - 1; i >= 0; i--) {
      final enemy = _enemies[i];
      final newY = enemy.y + (_gameSpeed * 120 * deltaTime);
      
      if (newY > 900) {
        _enemies.removeAt(i);
      } else {
        _enemies[i] = enemy.copyWith(y: newY);
      }
    }
  }

  void _updateObstacles(double deltaTime) {
    for (int i = _obstacles.length - 1; i >= 0; i--) {
      final obstacle = _obstacles[i];
      final newY = obstacle.y + (_gameSpeed * 120 * deltaTime);
      
      if (newY > 900) {
        _obstacles.removeAt(i);
      } else {
        _obstacles[i] = obstacle.copyWith(y: newY);
      }
    }
  }

  void _updateBullets(double deltaTime) {
    for (int i = _bullets.length - 1; i >= 0; i--) {
      final bullet = _bullets[i];
      final newY = bullet.y - (400 * deltaTime);
      
      if (newY < -20) {
        _bullets.removeAt(i);
      } else {
        _bullets[i] = bullet.copyWith(y: newY);
      }
    }
  }

  void _updateCoinPickups(double deltaTime) {
    for (int i = _coinPickups.length - 1; i >= 0; i--) {
      final coin = _coinPickups[i];
      final newY = coin.y + (_gameSpeed * 120 * deltaTime);
      
      if (newY > 900) {
        _coinPickups.removeAt(i);
      } else {
        _coinPickups[i] = coin.copyWith(y: newY);
      }
    }
  }

  void _checkCollisions() {
    _checkBulletEnemyCollisions();
    _checkPlayerEnemyCollisions();
    _checkPlayerObstacleCollisions();
    _checkPlayerCoinCollisions();
  }

  void _checkBulletEnemyCollisions() {
    for (int i = _bullets.length - 1; i >= 0; i--) {
      final bullet = _bullets[i];
      
      for (int j = _enemies.length - 1; j >= 0; j--) {
        final enemy = _enemies[j];
        
        // Collision detection between bullet and enemy
        final laneWidth = 400 / 6; // Approximate screen width / lanes
        final enemyX = enemy.lane * laneWidth + (laneWidth / 2);
        
        if ((bullet.x - enemyX).abs() < 30 && (bullet.y - enemy.y).abs() < 40) {
          // Hit detected
          final newHealth = enemy.health - 25;
          
          if (newHealth <= 0) {
            // Enemy destroyed - spawn coin and add score
            _score += 100;
            _spawnCoin(enemyX, enemy.y);
            _enemies.removeAt(j);
          } else {
            _enemies[j] = enemy.copyWith(health: newHealth);
          }
          
          _bullets.removeAt(i);
          break;
        }
      }
    }
  }

  void _checkPlayerEnemyCollisions() {
    final laneWidth = 400 / 6;
    final playerX = _playerLane * laneWidth + (laneWidth / 2);
    final playerY = 750; // Player car position (near bottom of screen)
    
    for (int i = _enemies.length - 1; i >= 0; i--) {
      final enemy = _enemies[i];
      final enemyX = enemy.lane * laneWidth + (laneWidth / 2);
      
      // Check if enemy is in same lane and close enough
      if ((playerX - enemyX).abs() < 40 && (playerY - enemy.y).abs() < 60) {
        // Collision detected
        _playerHealth -= 20; // Damage player
        _enemies.removeAt(i); // Remove enemy
        
        // Check if player is dead
        if (_playerHealth <= 0) {
          endGame();
          break;
        }
      }
    }
  }

  void _checkPlayerObstacleCollisions() {
    final laneWidth = 400 / 6;
    final playerX = _playerLane * laneWidth + (laneWidth / 2);
    final playerY = 750;
    
    for (int i = _obstacles.length - 1; i >= 0; i--) {
      final obstacle = _obstacles[i];
      final obstacleX = obstacle.lane * laneWidth + (laneWidth / 2);
      
      // Check if obstacle is in same lane and close enough
      if ((playerX - obstacleX).abs() < 40 && (playerY - obstacle.y).abs() < 60) {
        // Collision detected
        _playerHealth -= 30; // More damage from obstacles
        _obstacles.removeAt(i); // Remove obstacle
        
        // Check if player is dead
        if (_playerHealth <= 0) {
          endGame();
          break;
        }
      }
    }
  }

  void _checkPlayerCoinCollisions() {
    final laneWidth = 400 / 6;
    final playerX = _playerLane * laneWidth + (laneWidth / 2);
    final playerY = 750;
    
    for (int i = _coinPickups.length - 1; i >= 0; i--) {
      final coin = _coinPickups[i];
      
      // Check if coin is close enough to player
      if ((playerX - coin.x).abs() < 50 && (playerY - coin.y).abs() < 50) {
        // Coin collected
        _coins += 10;
        _score += 50;
        _coinPickups.removeAt(i);
      }
    }
  }

  void _spawnCoin(double x, double y) {
    _coinPickups.add(CoinPickup(x: x, y: y));
  }

  double _getHealthForEnemyType(EnemyType type) {
    switch (type) {
      case EnemyType.standard:
        return 25;
      case EnemyType.armored:
        return 75;
      case EnemyType.aggressive:
        return 50;
    }
  }

  Map<String, dynamic> _getCurrentGameData() {
    return {
      'score': _score,
      'coins': _coins,
      'gameSpeed': _gameSpeed,
      'playerHealth': _playerHealth,
      'enemies': List<Enemy>.from(_enemies),
      'obstacles': List<Obstacle>.from(_obstacles),
      'coinPickups': List<CoinPickup>.from(_coinPickups),
      'bullets': List<Bullet>.from(_bullets),
    };
  }
}