import 'dart:async';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../blocs/player_bloc/player_bloc.dart';
import '../../utils/constants.dart';
import 'package:flame/effects.dart';

class PlayerCar extends RectangleComponent {
  final PlayerBloc playerBloc;
  double currentLane = 2.0;
  late StreamSubscription _playerSubscription;

  PlayerCar({required this.playerBloc})
    : super(
        size: Vector2(GameConstants.carWidth, GameConstants.carHeight),
        paint: Paint()..color = Colors.red,
      );

  @override
  Future<void> onLoad() async {
    final parentSize =
        (parent is HasGameRef
            ? (parent as HasGameRef).gameRef.size
            : Vector2(0, 0));
    position = Vector2(
      currentLane * (parentSize.x / GameConstants.laneCount) +
          (parentSize.x / GameConstants.laneCount / 2) -
          size.x / 2,
      parentSize.y - 150,
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
    final parentSize =
        (parent is HasGameRef
            ? (parent as HasGameRef).gameRef.size
            : Vector2(0, 0));
    final targetX =
        currentLane * (parentSize.x / GameConstants.laneCount) +
        (parentSize.x / GameConstants.laneCount / 2) -
        size.x / 2;

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
