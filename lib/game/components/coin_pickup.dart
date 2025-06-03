import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../models/game_models.dart';
import '../../utils/constants.dart';

class CoinPickupComponent extends CircleComponent {
  final CoinPickup coinData;
  double rotationSpeed = 2.0;
  
  CoinPickupComponent({required this.coinData}) : super(
    radius: 15,
    paint: Paint()..color = Colors.amber,
  );

  @override
  Future<void> onLoad() async {
    position = Vector2(coinData.x - radius, coinData.y);
    
    // Add inner circle for coin effect
    add(CircleComponent(
      radius: radius * 0.7,
      paint: Paint()..color = Colors.yellow[600]!,
    ));
    
    // Add center dot
    add(CircleComponent(
      radius: radius * 0.3,
      paint: Paint()..color = Colors.amber[800]!,
    ));
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Move down the screen
    position.y += dt * GameConstants.enemySpeed;
    
    // Rotate for visual effect
    angle += rotationSpeed * dt;
    
    // Add floating animation
    position.x += (0.5 * dt * (angle.sin()));
    
    // Remove when off screen
    if (position.y > game.size.y + 50) {
      removeFromParent();
    }
  }
}