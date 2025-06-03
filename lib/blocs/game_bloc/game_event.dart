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