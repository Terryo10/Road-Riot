// File: lib/game/road_riot_game.dart
import 'dart:async';
import 'package:flame/game.dart';
import 'package:flame/events.dart';
import 'package:flame/components.dart';
import '../blocs/game_bloc/game_bloc.dart';
import '../blocs/player_bloc/player_bloc.dart';
import '../models/game_models.dart';
import '../utils/constants.dart';
import 'components/player_car.dart';
import 'components/road.dart';
import 'components/enemy_car.dart';
import 'components/obstacle.dart';
import 'components/bullet.dart';
import 'components/coin_pickup.dart';
import 'dart:async' as async;
import 'dart:math';

class RoadRiotGame extends FlameGame with PanDetector, TapDetector, HasGameRef {
  final GameBloc gameBloc;
  final PlayerBloc playerBloc;

  late PlayerCar playerCar;
  late Road road;

  late async.Timer enemySpawnTimer;
  late async.Timer obstacleSpawnTimer;
  late async.Timer gameUpdateTimer;

  final List<EnemyCar> enemyCars = [];
  final List<ObstacleComponent> obstacles = [];
  final List<BulletComponent> bullets = [];
  final List<CoinPickupComponent> coins = [];

  late StreamSubscription gameStateSubscription;
  late StreamSubscription playerStateSubscription;

  final Random random = Random();
  bool _isInitialized = false;

  RoadRiotGame({required this.gameBloc, required this.playerBloc});

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Ensure camera is properly set up
    camera.viewfinder.visibleGameSize = size;
    
    // Initialize game components
    road = Road();
    await add(road);

    playerCar = PlayerCar(playerBloc: playerBloc);
    await add(playerCar);

    // Set up timers after components are loaded
    _setupTimers();

    // Listen to game state changes
    _listenToGameState();
    _listenToPlayerState();
    
    _isInitialized = true;
  }

  void _setupTimers() {
    // Game update timer - runs the core game loop
    gameUpdateTimer = async.Timer.periodic(
      const Duration(milliseconds: 16), // ~60 FPS
      (_) {
        if (_isInitialized) {
          gameBloc.add(const UpdateGameEvent(0.016));
        }
      },
    );

    // Enemy spawn timer
    enemySpawnTimer = async.Timer.periodic(
      Duration(milliseconds: GameConstants.enemySpawnRate),
      (_) {
        if (_isInitialized) {
          gameBloc.add(SpawnEnemyEvent());
        }
      },
    );

    // Obstacle spawn timer
    obstacleSpawnTimer = async.Timer.periodic(
      Duration(milliseconds: GameConstants.obstacleSpawnRate),
      (_) {
        if (_isInitialized) {
          gameBloc.add(SpawnObstacleEvent());
        }
      },
    );
  }

  void _listenToGameState() {
    gameStateSubscription = gameBloc.stream.listen((state) {
      if (state is GameRunning) {
        _updateGameObjects(state);
      } else if (state is GameOver) {
        _stopTimers();
      }
    });
  }

  void _listenToPlayerState() {
    playerStateSubscription = playerBloc.stream.listen((state) {
      if (state is PlayerActive) {
        playerCar.updateLane(state.lane);
      }
    });
  }

  void _updateGameObjects(GameRunning state) {
    // Update enemies
    _syncEnemies(state.enemies);
    // Update obstacles  
    _syncObstacles(state.obstacles);
    // Update bullets
    _syncBullets(state.bullets);
    // Update coins
    _syncCoins(state.coinPickups);
  }

  void _syncEnemies(List<Enemy> enemies) {
    // Remove enemies that are no longer in state
    enemyCars.removeWhere((enemyCar) {
      final exists = enemies.any((enemy) => _isSameEnemy(enemy, enemyCar.enemyData));
      if (!exists) {
        enemyCar.removeFromParent();
        return true;
      }
      return false;
    });

    // Add new enemies
    for (final enemy in enemies) {
      final exists = enemyCars.any((enemyCar) => _isSameEnemy(enemy, enemyCar.enemyData));
      if (!exists) {
        final enemyCar = EnemyCar(enemyData: enemy);
        enemyCars.add(enemyCar);
        add(enemyCar);
      }
    }
  }

  void _syncObstacles(List<Obstacle> obstacleList) {
    // Remove obstacles that are no longer in state
    obstacles.removeWhere((obstacleComp) {
      final exists = obstacleList.any((obstacle) => _isSameObstacle(obstacle, obstacleComp.obstacleData));
      if (!exists) {
        obstacleComp.removeFromParent();
        return true;
      }
      return false;
    });

    // Add new obstacles
    for (final obstacle in obstacleList) {
      final exists = obstacles.any((obstacleComp) => _isSameObstacle(obstacle, obstacleComp.obstacleData));
      if (!exists) {
        final obstacleComp = ObstacleComponent(obstacleData: obstacle);
        obstacles.add(obstacleComp);
        add(obstacleComp);
      }
    }
  }

  void _syncBullets(List<Bullet> bulletList) {
    // Remove bullets that are no longer in state
    bullets.removeWhere((bulletComp) {
      final exists = bulletList.any((bullet) => _isSameBullet(bullet, bulletComp.bulletData));
      if (!exists) {
        bulletComp.removeFromParent();
        return true;
      }
      return false;
    });

    // Add new bullets
    for (final bullet in bulletList) {
      final exists = bullets.any((bulletComp) => _isSameBullet(bullet, bulletComp.bulletData));
      if (!exists) {
        final bulletComp = BulletComponent(bulletData: bullet);
        bullets.add(bulletComp);
        add(bulletComp);
      }
    }
  }

  void _syncCoins(List<CoinPickup> coinList) {
    // Remove coins that are no longer in state
    coins.removeWhere((coinComp) {
      final exists = coinList.any((coin) => _isSameCoin(coin, coinComp.coinData));
      if (!exists) {
        coinComp.removeFromParent();
        return true;
      }
      return false;
    });

    // Add new coins
    for (final coin in coinList) {
      final exists = coins.any((coinComp) => _isSameCoin(coin, coinComp.coinData));
      if (!exists) {
        final coinComp = CoinPickupComponent(coinData: coin);
        coins.add(coinComp);
        add(coinComp);
      }
    }
  }

  // Helper methods to compare game objects
  bool _isSameEnemy(Enemy a, Enemy b) {
    return a.lane == b.lane && (a.y - b.y).abs() < 20;
  }

  bool _isSameObstacle(Obstacle a, Obstacle b) {
    return a.lane == b.lane && (a.y - b.y).abs() < 20;
  }

  bool _isSameBullet(Bullet a, Bullet b) {
    return (a.x - b.x).abs() < 10 && (a.y - b.y).abs() < 20;
  }

  bool _isSameCoin(CoinPickup a, CoinPickup b) {
    return (a.x - b.x).abs() < 15 && (a.y - b.y).abs() < 20;
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    // Calculate target lane based on drag position
    final laneWidth = size.x / GameConstants.laneCount;
    final targetLane = (info.eventPosition.global.x / laneWidth).floor().toDouble();

    // Move player to target lane
    playerBloc.add(
      MovePlayerEvent(targetLane.clamp(0, GameConstants.laneCount - 1)),
    );
  }

  @override
  void onTap() {
    // Get current player position for bullet spawn
    final playerState = playerBloc.state;
    if (playerState is PlayerActive) {
      final laneWidth = size.x / GameConstants.laneCount;
      final bulletX = playerState.lane * laneWidth + (laneWidth / 2);
      final bulletY = size.y - 150; // Player car position
      
      // Add bullet to game service
      gameBloc.add(AddBulletEvent(bulletX, bulletY));
    }
  }

  void _stopTimers() {
    gameUpdateTimer.cancel();
    enemySpawnTimer.cancel();
    obstacleSpawnTimer.cancel();
  }

  @override
  void onRemove() {
    _stopTimers();
    gameStateSubscription.cancel();
    playerStateSubscription.cancel();
    super.onRemove();
  }
}