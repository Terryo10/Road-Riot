// File: lib/models/game_models.dart
import 'package:equatable/equatable.dart';

enum EnemyType { standard, armored, aggressive }
enum ObstacleType { rock, tree, pit }

class Enemy extends Equatable {
  final double lane;
  final double y;
  final EnemyType type;
  final double health;

  const Enemy({
    required this.lane,
    required this.y,
    required this.type,
    required this.health,
  });

  Enemy copyWith({
    double? lane,
    double? y,
    EnemyType? type,
    double? health,
  }) {
    return Enemy(
      lane: lane ?? this.lane,
      y: y ?? this.y,
      type: type ?? this.type,
      health: health ?? this.health,
    );
  }

  @override
  List<Object?> get props => [lane, y, type, health];
}

class Obstacle extends Equatable {
  final double lane;
  final double y;
  final ObstacleType type;

  const Obstacle({
    required this.lane,
    required this.y,
    required this.type,
  });

  Obstacle copyWith({
    double? lane,
    double? y,
    ObstacleType? type,
  }) {
    return Obstacle(
      lane: lane ?? this.lane,
      y: y ?? this.y,
      type: type ?? this.type,
    );
  }

  @override
  List<Object?> get props => [lane, y, type];
}

class Bullet extends Equatable {
  final double x;
  final double y;

  const Bullet({
    required this.x,
    required this.y,
  });

  Bullet copyWith({
    double? x,
    double? y,
  }) {
    return Bullet(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  @override
  List<Object?> get props => [x, y];
}

class CoinPickup extends Equatable {
  final double x;
  final double y;

  const CoinPickup({
    required this.x,
    required this.y,
  });

  CoinPickup copyWith({
    double? x,
    double? y,
  }) {
    return CoinPickup(
      x: x ?? this.x,
      y: y ?? this.y,
    );
  }

  @override
  List<Object?> get props => [x, y];
}
