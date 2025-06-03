// File: lib/game/components/enemy_car.dart
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../models/game_models.dart';
import '../../utils/constants.dart';

class EnemyCar extends RectangleComponent with HasGameRef {
  final Enemy enemyData;

  EnemyCar({required this.enemyData})
      : super(size: Vector2(GameConstants.carWidth, GameConstants.carHeight));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Set car color based on enemy type
    paint = Paint()..color = _getColorForType(enemyData.type);
    
    // Position the car in the correct lane
    final laneWidth = gameRef.size.x / GameConstants.laneCount;
    position = Vector2(
      enemyData.lane * laneWidth + (laneWidth / 2) - size.x / 2,
      enemyData.y,
    );

    // Add visual details
    _addCarDetails();
  }

  void _addCarDetails() {
    // Add windows
    add(
      RectangleComponent(
        position: Vector2(size.x * 0.1, size.y * 0.6),
        size: Vector2(size.x * 0.8, size.y * 0.3),
        paint: Paint()..color = Colors.black87,
      ),
    );

    // Add rear bumper
    add(
      RectangleComponent(
        position: Vector2(size.x * 0.2, size.y * 0.85),
        size: Vector2(size.x * 0.6, size.y * 0.15),
        paint: Paint()..color = _getColorForType(enemyData.type).withOpacity(0.7),
      ),
    );

    // Add wheels
    add(
      CircleComponent(
        radius: 6,
        position: Vector2(8, size.y * 0.1),
        paint: Paint()..color = Colors.black,
      ),
    );
    add(
      CircleComponent(
        radius: 6,
        position: Vector2(size.x - 14, size.y * 0.1),
        paint: Paint()..color = Colors.black,
      ),
    );

    // Add special indicators for enemy types
    if (enemyData.type == EnemyType.armored) {
      // Add armor plating
      add(
        RectangleComponent(
          position: Vector2(size.x * 0.05, size.y * 0.4),
          size: Vector2(size.x * 0.9, size.y * 0.2),
          paint: Paint()..color = Colors.grey[600]!,
        ),
      );
    } else if (enemyData.type == EnemyType.aggressive) {
      // Add weapon indicator
      add(
        RectangleComponent(
          position: Vector2(size.x * 0.4, 0),
          size: Vector2(size.x * 0.2, size.y * 0.2),
          paint: Paint()..color = Colors.red[700]!,
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Move down the screen
    position.y += dt * GameConstants.enemySpeed;
    
    // Remove when off screen
    if (position.y > gameRef.size.y + 100) {
      removeFromParent();
    }
  }

  Color _getColorForType(EnemyType type) {
    switch (type) {
      case EnemyType.standard:
        return Colors.blue[600]!;
      case EnemyType.armored:
        return Colors.grey[700]!;
      case EnemyType.aggressive:
        return Colors.purple[600]!;
    }
  }
}