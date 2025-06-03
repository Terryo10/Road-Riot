
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
  
  List<Enemy> _enemies = [];
  List<Obstacle> _obstacles = [];
  List<CoinPickup> _coinPickups = [];
  List<Bullet> _bullets = [];

  GameService({required this.repository});

  void startGame() {
    _isGameRunning = true;
    _score = 0;
    _coins = 0;
    _gameSpeed = 1.0;
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

  Map<String, dynamic> updateGame(double deltaTime) {
    if (!_isGameRunning) return _getCurrentGameData();

    // Update score and speed
    _score += (_gameSpeed * 10).round();
    _gameSpeed += deltaTime * 0.1;

    // Update game objects
    _updateEnemies(deltaTime);
    _updateObstacles(deltaTime);
    _updateBullets(deltaTime);
    _updateCoinPickups(deltaTime);

    return _getCurrentGameData();
  }

  void spawnEnemy() {
    if (_enemies.length < 3) {
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
    if (_obstacles.length < 2) {
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

  bool checkCollisions(double playerLane, double playerY) {
    // Implementation for collision detection
    // Returns true if player should take damage
    return false;
  }

  void _updateEnemies(double deltaTime) {
    for (int i = _enemies.length - 1; i >= 0; i--) {
      final enemy = _enemies[i];
      final newY = enemy.y + (_gameSpeed * 150 * deltaTime);
      
      if (newY > 800) {
        _enemies.removeAt(i);
      } else {
        _enemies[i] = enemy.copyWith(y: newY);
      }
    }
  }

  void _updateObstacles(double deltaTime) {
    for (int i = _obstacles.length - 1; i >= 0; i--) {
      final obstacle = _obstacles[i];
      final newY = obstacle.y + (_gameSpeed * 150 * deltaTime);
      
      if (newY > 800) {
        _obstacles.removeAt(i);
      } else {
        _obstacles[i] = obstacle.copyWith(y: newY);
      }
    }
  }

  void _updateBullets(double deltaTime) {
    for (int i = _bullets.length - 1; i >= 0; i--) {
      final bullet = _bullets[i];
      final newY = bullet.y - (300 * deltaTime);
      
      if (newY < -10) {
        _bullets.removeAt(i);
      } else {
        _bullets[i] = bullet.copyWith(y: newY);
      }
    }
  }

  void _updateCoinPickups(double deltaTime) {
    for (int i = _coinPickups.length - 1; i >= 0; i--) {
      final coin = _coinPickups[i];
      final newY = coin.y + (_gameSpeed * 150 * deltaTime);
      
      if (newY > 800) {
        _coinPickups.removeAt(i);
      } else {
        _coinPickups[i] = coin.copyWith(y: newY);
      }
    }
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
      'enemies': List<Enemy>.from(_enemies),
      'obstacles': List<Obstacle>.from(_obstacles),
      'coinPickups': List<CoinPickup>.from(_coinPickups),
      'bullets': List<Bullet>.from(_bullets),
    };
  }
}