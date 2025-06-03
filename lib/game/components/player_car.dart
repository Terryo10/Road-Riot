// File: lib/game/components/player_car.dart
import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../blocs/player_bloc/player_bloc.dart';
import '../../utils/constants.dart';
import 'package:flame/effects.dart';

class PlayerCar extends RectangleComponent with HasGameRef {
  final PlayerBloc playerBloc;
  double currentLane = 2.0;

  PlayerCar({required this.playerBloc})
      : super(
          size: Vector2(GameConstants.carWidth, GameConstants.carHeight),
          paint: Paint()..color = Colors.red,
        );

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Position the car at the bottom center initially
    position = Vector2(
      _getLaneXPosition(currentLane),
      gameRef.size.y - 150,
    );

    // Add visual details to make the car more visible
    _addCarDetails();
  }

  void _addCarDetails() {
    // Main car body (already set in constructor)
    
    // Add windows
    add(
      RectangleComponent(
        position: Vector2(size.x * 0.1, size.y * 0.2),
        size: Vector2(size.x * 0.8, size.y * 0.3),
        paint: Paint()..color = Colors.black87,
      ),
    );

    // Add front bumper
    add(
      RectangleComponent(
        position: Vector2(size.x * 0.2, 0),
        size: Vector2(size.x * 0.6, size.y * 0.15),
        paint: Paint()..color = Colors.red[300]!,
      ),
    );

    // Add wheels
    add(
      CircleComponent(
        radius: 8,
        position: Vector2(5, size.y * 0.8),
        paint: Paint()..color = Colors.black,
      ),
    );
    add(
      CircleComponent(
        radius: 8,
        position: Vector2(size.x - 13, size.y * 0.8),
        paint: Paint()..color = Colors.black,
      ),
    );
  }

  double _getLaneXPosition(double lane) {
    final laneWidth = gameRef.size.x / GameConstants.laneCount;
    return lane * laneWidth + (laneWidth / 2) - size.x / 2;
  }

  void updateLane(double targetLane) {
    if (targetLane != currentLane) {
      currentLane = targetLane;
      final targetX = _getLaneXPosition(targetLane);

      // Animate movement to new lane
      add(
        MoveToEffect(
          Vector2(targetX, position.y),
          EffectController(duration: 0.2),
        ),
      );
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Keep car at bottom of screen
    position.y = gameRef.size.y - 150;
  }
}