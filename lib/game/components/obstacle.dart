import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../models/game_models.dart';
import '../../utils/constants.dart';

class ObstacleComponent extends RectangleComponent {
  final Obstacle obstacleData;

  ObstacleComponent({required this.obstacleData})
    : super(size: Vector2(50, 50), paint: Paint()..color = Colors.brown);

  @override
  Future<void> onLoad() async {
    final parentSize =
        (parent is HasGameRef
            ? (parent as HasGameRef).gameRef.size
            : Vector2(0, 0));
    final laneWidth = parentSize.x / GameConstants.laneCount;
    position = Vector2(
      obstacleData.lane * laneWidth + (laneWidth / 2) - size.x / 2,
      obstacleData.y,
    );

    // Customize appearance based on type
    paint = Paint()..color = _getColorForType(obstacleData.type);

    // Add visual details based on obstacle type
    switch (obstacleData.type) {
      case ObstacleType.rock:
        // Add circular shape for rock
        add(
          CircleComponent(
            radius: size.x / 2,
            paint: Paint()..color = Colors.grey[600]!,
          ),
        );
        break;
      case ObstacleType.tree:
        // Add tree-like appearance
        add(
          RectangleComponent(
            position: Vector2(size.x * 0.4, size.y * 0.6),
            size: Vector2(size.x * 0.2, size.y * 0.4),
            paint: Paint()..color = Colors.brown[800]!,
          ),
        );
        add(
          CircleComponent(
            radius: size.x * 0.3,
            position: Vector2(size.x * 0.5, size.y * 0.3),
            paint: Paint()..color = Colors.green[700]!,
          ),
        );
        break;
      case ObstacleType.pit:
        // Add pit appearance
        add(
          RectangleComponent(size: size, paint: Paint()..color = Colors.black),
        );
        break;
    }
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Move down the screen
    position.y += dt * GameConstants.enemySpeed;

    final parentSize =
        (parent is HasGameRef
            ? (parent as HasGameRef).gameRef.size
            : Vector2(0, 0));
    // Remove when off screen
    if (position.y > parentSize.y + 100) {
      removeFromParent();
    }
  }

  Color _getColorForType(ObstacleType type) {
    switch (type) {
      case ObstacleType.rock:
        return Colors.grey;
      case ObstacleType.tree:
        return Colors.green;
      case ObstacleType.pit:
        return Colors.black;
    }
  }
}
