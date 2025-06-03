import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../models/game_models.dart';
import '../../utils/constants.dart';

class EnemyCar extends RectangleComponent {
  final Enemy enemyData;

  EnemyCar({required this.enemyData})
    : super(size: Vector2(GameConstants.carWidth, GameConstants.carHeight));

  @override
  Future<void> onLoad() async {
    paint = Paint()..color = _getColorForType(enemyData.type);
    final parentSize =
        (parent is HasGameRef
            ? (parent as HasGameRef).gameRef.size
            : Vector2(0, 0));
    final laneWidth = parentSize.x / GameConstants.laneCount;
    position = Vector2(
      enemyData.lane * laneWidth + (laneWidth / 2) - size.x / 2,
      enemyData.y,
    );

    // Add a simple car shape
    add(RectangleComponent(size: size, paint: paint));

    // Add windows
    add(
      RectangleComponent(
        position: Vector2(size.x * 0.1, size.y * 0.2),
        size: Vector2(size.x * 0.8, size.y * 0.3),
        paint: Paint()..color = Colors.black,
      ),
    );
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

  Color _getColorForType(EnemyType type) {
    switch (type) {
      case EnemyType.standard:
        return Colors.blue;
      case EnemyType.armored:
        return Colors.grey;
      case EnemyType.aggressive:
        return Colors.purple;
    }
  }
}
