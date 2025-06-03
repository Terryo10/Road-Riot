
// File: lib/game/components/bullet.dart
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../models/game_models.dart';
import '../../utils/constants.dart';

class BulletComponent extends RectangleComponent {
  final Bullet bulletData;
  
  BulletComponent({required this.bulletData}) : super(
    size: Vector2(GameConstants.bulletWidth, GameConstants.bulletHeight),
    paint: Paint()..color = Colors.yellow,
  );

  @override
  Future<void> onLoad() async {
    position = Vector2(bulletData.x - size.x / 2, bulletData.y);
    
    // Add glow effect
    add(RectangleComponent(
      size: size,
      paint: Paint()..color = Colors.yellow[300]!,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Move up the screen
    position.y -= dt * GameConstants.bulletSpeed;
    
    // Remove when off screen
    if (position.y < -10) {
      removeFromParent();
    }
  }
}
