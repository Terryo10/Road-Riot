
// File: lib/game/road_riot_game.dart
import 'dart:async';
import 'package:flame/game.dart';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
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

class RoadRiotGame extends FlameGame with PanDetector, TapDetector {
  final GameBloc gameBloc;
  final PlayerBloc playerBloc;
  
  late PlayerCar playerCar;
  late Road road;
  
  late Timer enemySpawnTimer;
  late Timer obstacleSpawnTimer;
  
  final List<EnemyCar> enemyCars = [];
  final List<ObstacleComponent> obstacles = [];
  final List<BulletComponent> bullets = [];
  final List<CoinPickupComponent> coins = [];
  
  late StreamSubscription gameStateSubscription;
  
  RoadRiotGame({
    required this.gameBloc,
    required this.playerBloc,
  });

  @override
  Future<void> onLoad() async {
    // Initialize game components
    road = Road();
    await add(road);
    
    playerCar = PlayerCar(playerBloc: playerBloc);
    await add(playerCar);
    
    // Set up camera
    camera.viewfinder.visibleGameSize = size;
    
    // Set up spawn timers
    _setupSpawnTimers();
    
    // Listen to game state changes
    _listenToGameState();
  }

  void _setupSpawnTimers() {
    enemySpawnTimer = Timer.periodic(
      Duration(milliseconds: GameConstants.enemySpawnRate),
      (_) => gameBloc.add(SpawnEnemyEvent()),
    );
    
    obstacleSpawnTimer = Timer.periodic(
      Duration(milliseconds: GameConstants.obstacleSpawnRate),
      (_) => gameBloc.add(SpawnObstacleEvent()),
    );
  }

  void _listenToGameState() {
    gameStateSubscription = gameBloc.stream.listen((state) {
      if (state is GameRunning) {
        _updateGameObjects(state);
      } else if (state is GameOver) {
        _stopSpawnTimers();
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
      final exists = enemies.any((enemy) => 
        enemy.lane == enemyCar.enemyData.lane && 
        (enemy.y - enemyCar.enemyData.y).abs() < 10);
      if (!exists) {
        enemyCar.removeFromParent();
        return true;
      }
      return false;
    });
    
    // Add new enemies
    for (final enemy in enemies) {
      final exists = enemyCars.any((enemyCar) => 
        enemy.lane == enemyCar.enemyData.lane && 
        (enemy.y - enemyCar.enemyData.y).abs() < 10);
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
      final exists = obstacleList.any((obstacle) => 
        obstacle.lane == obstacleComp.obstacleData.lane && 
        (obstacle.y - obstacleComp.obstacleData.y).abs() < 10);
      if (!exists) {
        obstacleComp.removeFromParent();
        return true;
      }
      return false;
    });
    
    // Add new obstacles
    for (final obstacle in obstacleList) {
      final exists = obstacles.any((obstacleComp) => 
        obstacle.lane == obstacleComp.obstacleData.lane && 
        (obstacle.y - obstacleComp.obstacleData.y).abs() < 10);
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
      final exists = bulletList.any((bullet) => 
        (bullet.x - bulletComp.bulletData.x).abs() < 5 && 
        (bullet.y - bulletComp.bulletData.y).abs() < 10);
      if (!exists) {
        bulletComp.removeFromParent();
        return true;
      }
      return false;
    });
    
    // Add new bullets
    for (final bullet in bulletList) {
      final exists = bullets.any((bulletComp) => 
        (bullet.x - bulletComp.bulletData.x).abs() < 5 && 
        (bullet.y - bulletComp.bulletData.y).abs() < 10);
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
      final exists = coinList.any((coin) => 
        (coin.x - coinComp.coinData.x).abs() < 10 && 
        (coin.y - coinComp.coinData.y).abs() < 10);
      if (!exists) {
        coinComp.removeFromParent();
        return true;
      }
      return false;
    });
    
    // Add new coins
    for (final coin in coinList) {
      final exists = coins.any((coinComp) => 
        (coin.x - coinComp.coinData.x).abs() < 10 && 
        (coin.y - coinComp.coinData.y).abs() < 10);
      if (!exists) {
        final coinComp = CoinPickupComponent(coinData: coin);
        coins.add(coinComp);
        add(coinComp);
      }
    }
  }

  @override
  void onPanUpdate(DragUpdateInfo info) {
    // Calculate target lane based on drag position
    final laneWidth = size.x / GameConstants.laneCount;
    final targetLane = (info.eventPosition.global.x / laneWidth).floor().toDouble();
    
    // Move player to target lane
    playerBloc.add(MovePlayerEvent(targetLane.clamp(0, GameConstants.laneCount - 1)));
  }

  @override
  void onTap() {
    // Shoot when tapping
    playerBloc.add(ShootEvent());
    
    // Add bullet to game service
    final playerState = playerBloc.state;
    if (playerState is PlayerActive) {
      final bulletX = playerState.lane * (size.x / GameConstants.laneCount) + 
                     (size.x / GameConstants.laneCount / 2);
      // Note: In a real implementation, you'd want to communicate this to the game service
      // For now, we'll handle this through the BLoC pattern
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Update game state
    gameBloc.add(UpdateGameEvent(dt));
  }

  void _stopSpawnTimers() {
    enemySpawnTimer.cancel();
    obstacleSpawnTimer.cancel();
  }

  @override
  void onRemove() {
    _stopSpawnTimers();
    gameStateSubscription.cancel();
    super.onRemove();
  }
}