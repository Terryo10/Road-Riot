// File: lib/game/components/bullet.dart
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../models/game_models.dart';
import '../../utils/constants.dart';

class BulletComponent extends RectangleComponent with HasGameRef {
  final Bullet bulletData;
  
  BulletComponent({required this.bulletData}) : super(
    size: Vector2(GameConstants.bulletWidth, GameConstants.bulletHeight),
    paint: Paint()..color = Colors.yellow,
  );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    position = Vector2(bulletData.x - size.x / 2, bulletData.y);
    
    // Add glow effect for better visibility
    add(RectangleComponent(
      size: Vector2(size.x + 2, size.y + 2),
      position: Vector2(-1, -1),
      paint: Paint()..color = Colors.yellow[300]!,
    ));

    // Add bright center
    add(RectangleComponent(
      size: Vector2(size.x * 0.6, size.y * 0.8),
      position: Vector2(size.x * 0.2, size.y * 0.1),
      paint: Paint()..color = Colors.white,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Move up the screen
    position.y -= dt * GameConstants.bulletSpeed;
    
    // Remove when off screen
    if (position.y < -20) {
      removeFromParent();
    }
  }
}