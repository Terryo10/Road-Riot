// File: lib/blocs/game_bloc/game_event.dart
part of 'game_bloc.dart';

sealed class GameEvent extends Equatable {
  const GameEvent();

  @override
  List<Object> get props => [];
}

class StartGameEvent extends GameEvent {}
class PauseGameEvent extends GameEvent {}
class ResumeGameEvent extends GameEvent {}
class GameOverEvent extends GameEvent {}

class UpdateGameEvent extends GameEvent {
  final double deltaTime;
  const UpdateGameEvent(this.deltaTime);
  @override
  List<Object> get props => [deltaTime];
}

class SpawnEnemyEvent extends GameEvent {}
class SpawnObstacleEvent extends GameEvent {}

class AddBulletEvent extends GameEvent {
  final double x;
  final double y;
  const AddBulletEvent(this.x, this.y);
  @override
  List<Object> get props => [x, y];
}