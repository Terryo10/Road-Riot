// File: lib/game/components/obstacle.dart
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../models/game_models.dart';
import '../../utils/constants.dart';

class ObstacleComponent extends RectangleComponent with HasGameRef {
  final Obstacle obstacleData;

  ObstacleComponent({required this.obstacleData})
      : super(size: Vector2(50, 50));

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Position the obstacle in the correct lane
    final laneWidth = gameRef.size.x / GameConstants.laneCount;
    position = Vector2(
      obstacleData.lane * laneWidth + (laneWidth / 2) - size.x / 2,
      obstacleData.y,
    );

    // Set base color and add visual details
    paint = Paint()..color = _getColorForType(obstacleData.type);
    _addObstacleDetails();
  }

  void _addObstacleDetails() {
    switch (obstacleData.type) {
      case ObstacleType.rock:
        // Make rock circular and add texture
        add(
          CircleComponent(
            radius: size.x / 2,
            paint: Paint()..color = Colors.grey[600]!,
          ),
        );
        add(
          CircleComponent(
            radius: size.x / 3,
            position: Vector2(size.x * 0.1, size.y * 0.1),
            paint: Paint()..color = Colors.grey[500]!,
          ),
        );
        break;
        
      case ObstacleType.tree:
        // Tree trunk
        add(
          RectangleComponent(
            position: Vector2(size.x * 0.4, size.y * 0.6),
            size: Vector2(size.x * 0.2, size.y * 0.4),
            paint: Paint()..color = Colors.brown[800]!,
          ),
        );
        // Tree foliage
        add(
          CircleComponent(
            radius: size.x * 0.35,
            position: Vector2(size.x * 0.5, size.y * 0.35),
            paint: Paint()..color = Colors.green[700]!,
          ),
        );
        // Additional foliage for fuller look
        add(
          CircleComponent(
            radius: size.x * 0.25,
            position: Vector2(size.x * 0.3, size.y * 0.25),
            paint: Paint()..color = Colors.green[600]!,
          ),
        );
        break;
        
      case ObstacleType.pit:
        // Main pit (black)
        paint = Paint()..color = Colors.black;
        // Add danger markings
        add(
          RectangleComponent(
            position: Vector2(size.x * 0.1, size.y * 0.1),
            size: Vector2(size.x * 0.8, size.y * 0.1),
            paint: Paint()..color = Colors.yellow,
          ),
        );
        add(
          RectangleComponent(
            position: Vector2(size.x * 0.1, size.y * 0.8),
            size: Vector2(size.x * 0.8, size.y * 0.1),
            paint: Paint()..color = Colors.yellow,
          ),
        );
        break;
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

  Color _getColorForType(ObstacleType type) {
    switch (type) {
      case ObstacleType.rock:
        return Colors.grey[700]!;
      case ObstacleType.tree:
        return Colors.green[800]!;
      case ObstacleType.pit:
        return Colors.black;
    }
  }
}