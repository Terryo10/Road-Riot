part of 'game_bloc.dart';

sealed class GameState extends Equatable {
  const GameState();
  
  @override
  List<Object> get props => [];
}

final class GameInitial extends GameState {}

final class GameRunning extends GameState {
  final int score;
  final int coins;
  final double gameSpeed;
  final double playerHealth;
  final List<Enemy> enemies;
  final List<Obstacle> obstacles;
  final List<CoinPickup> coinPickups;
  final List<Bullet> bullets;

  const GameRunning({
    required this.score,
    required this.coins,
    required this.gameSpeed,
    required this.playerHealth,
    required this.enemies,
    required this.obstacles,
    required this.coinPickups,
    required this.bullets,
  });

  @override
  List<Object> get props => [
    score, coins, gameSpeed, playerHealth, enemies, obstacles, coinPickups, bullets
  ];
}

final class GamePaused extends GameState {}

final class GameOver extends GameState {
  final int finalScore;
  final int totalCoins;
  
  const GameOver({required this.finalScore, required this.totalCoins});
  
  @override
  List<Object> get props => [finalScore, totalCoins];
}