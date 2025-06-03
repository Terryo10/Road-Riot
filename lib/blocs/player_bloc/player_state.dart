part of 'player_bloc.dart';

sealed class PlayerState extends Equatable {
  const PlayerState();
  
  @override
  List<Object> get props => [];
}

final class PlayerInitial extends PlayerState {}

final class PlayerActive extends PlayerState {
  final double lane;
  final double health;
  final double maxHealth;
  final bool isMoving;

  const PlayerActive({
    required this.lane,
    required this.health,
    required this.maxHealth,
    required this.isMoving,
  });

  PlayerActive copyWith({
    double? lane,
    double? health,
    double? maxHealth,
    bool? isMoving,
  }) {
    return PlayerActive(
      lane: lane ?? this.lane,
      health: health ?? this.health,
      maxHealth: maxHealth ?? this.maxHealth,
      isMoving: isMoving ?? this.isMoving,
    );
  }

  @override
  List<Object> get props => [lane, health, maxHealth, isMoving];
}