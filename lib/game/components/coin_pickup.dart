// File: lib/game/components/coin_pickup.dart
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../models/game_models.dart';
import '../../utils/constants.dart';
import 'dart:math';

class CoinPickupComponent extends CircleComponent with HasGameRef {
  final CoinPickup coinData;
  double rotationSpeed = 3.0;
  double bobSpeed = 4.0;
  double bobAmount = 5.0;
  double time = 0.0;

  CoinPickupComponent({required this.coinData})
    : super(radius: 18, paint: Paint()..color = Colors.amber);

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    position = Vector2(coinData.x - radius, coinData.y);

    // Add multiple layers for coin effect
    
    // Outer glow
    add(
      CircleComponent(
        radius: radius + 3,
        paint: Paint()..color = Colors.amber[200]!.withOpacity(0.6),
      ),
    );

    // Main coin body (already set in constructor)
    
    // Inner gold circle
    add(
      CircleComponent(
        radius: radius * 0.8,
        paint: Paint()..color = Colors.yellow[600]!,
      ),
    );

    // Center highlight
    add(
      CircleComponent(
        radius: radius * 0.5,
        paint: Paint()..color = Colors.yellow[200]!,
      ),
    );

    // Dollar sign or star in center
    add(
      CircleComponent(
        radius: radius * 0.2,
        paint: Paint()..color = Colors.amber[800]!,
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);

    time += dt;

    // Move down the screen
    position.y += dt * GameConstants.enemySpeed;

    // Add floating/bobbing animation
    final bobOffset = sin(time * bobSpeed) * bobAmount;
    position.x = coinData.x - radius + bobOffset;

    // Rotate for visual effect
    angle += rotationSpeed * dt;

    // Remove when off screen
    if (position.y > gameRef.size.y + 50) {
      removeFromParent();
    }
  }
}