import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../blocs/player_bloc/player_bloc.dart';
import '../../utils/constants.dart';

class PlayerCar extends RectangleComponent {
  final PlayerBloc playerBloc;
  double currentLane = 2.0;
  late StreamSubscription _playerSubscription;
  
  PlayerCar({required this.playerBloc}) : super(
    size: Vector2(GameConstants.carWidth, GameConstants.carHeight),
    paint: Paint()..color = Colors.red,
  );

  @override
  Future<void> onLoad() async {
    // Position car at bottom center
    position = Vector2(
      currentLane * (game.size.x / GameConstants.laneCount) + 
      (game.size.x / GameConstants.laneCount / 2) - size.x / 2,
      game.size.y - 150,
    );
    
    // Listen to player state changes
    _playerSubscription = playerBloc.stream.listen((state) {
      if (state is PlayerActive && state.lane != currentLane) {
        _moveTo(state.lane);
      }
    });
  }

  void _moveTo(double targetLane) {
    currentLane = targetLane;
    final targetX = currentLane * (game.size.x / GameConstants.laneCount) + 
                   (game.size.x / GameConstants.laneCount / 2) - size.x / 2;
    
    // Animate movement
    add(
      MoveToEffect(
        Vector2(targetX, position.y),
        EffectController(duration: 0.3),
      ),
    );
  }

  @override
  void update(double dt) {
    super.update(dt);
    // Additional car logic can go here
  }

  @override
  void onRemove() {
    _playerSubscription.cancel();
    super.onRemove();
  }
}