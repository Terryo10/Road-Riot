part of 'player_bloc.dart';

sealed class PlayerEvent extends Equatable {
  const PlayerEvent();

  @override
  List<Object> get props => [];
}

class MovePlayerEvent extends PlayerEvent {
  final double targetLane;
  const MovePlayerEvent(this.targetLane);
  @override
  List<Object> get props => [targetLane];
}

class ShootEvent extends PlayerEvent {}

class TakeDamageEvent extends PlayerEvent {
  final double damage;
  const TakeDamageEvent(this.damage);
  @override
  List<Object> get props => [damage];
}

class HealEvent extends PlayerEvent {
  final double healAmount;
  const HealEvent(this.healAmount);
  @override
  List<Object> get props => [healAmount];
}