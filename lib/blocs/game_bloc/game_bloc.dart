// File: lib/blocs/game_bloc/game_bloc.dart
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../services/game_service.dart';
import '../../models/game_models.dart';

part 'game_event.dart';
part 'game_state.dart';

class GameBloc extends Bloc<GameEvent, GameState> {
  final GameService gameService;
  
  GameBloc({required this.gameService}) : super(GameInitial()) {
    on<StartGameEvent>(_onStartGame);
    on<PauseGameEvent>(_onPauseGame);
    on<ResumeGameEvent>(_onResumeGame);
    on<GameOverEvent>(_onGameOver);
    on<UpdateGameEvent>(_onUpdateGame);
    on<SpawnEnemyEvent>(_onSpawnEnemy);
    on<SpawnObstacleEvent>(_onSpawnObstacle);
    on<AddBulletEvent>(_onAddBullet);
  }

  void _onStartGame(StartGameEvent event, Emitter<GameState> emit) {
    gameService.startGame();
    emit(const GameRunning(
      score: 0,
      coins: 0,
      gameSpeed: 1.0,
      enemies: [],
      obstacles: [],
      coinPickups: [],
      bullets: [],
    ));
  }

  void _onPauseGame(PauseGameEvent event, Emitter<GameState> emit) {
    gameService.pauseGame();
    emit(GamePaused());
  }

  void _onResumeGame(ResumeGameEvent event, Emitter<GameState> emit) {
    gameService.resumeGame();
    // Emit current game state by updating
    final updatedData = gameService.updateGame(0.0);
    emit(GameRunning(
      score: updatedData['score'],
      coins: updatedData['coins'],
      gameSpeed: updatedData['gameSpeed'],
      enemies: updatedData['enemies'],
      obstacles: updatedData['obstacles'],
      coinPickups: updatedData['coinPickups'],
      bullets: updatedData['bullets'],
    ));
  }

  void _onGameOver(GameOverEvent event, Emitter<GameState> emit) {
    final currentState = state;
    if (currentState is GameRunning) {
      gameService.endGame();
      emit(GameOver(
        finalScore: currentState.score,
        totalCoins: currentState.coins,
      ));
    }
  }

  void _onUpdateGame(UpdateGameEvent event, Emitter<GameState> emit) {
    final currentState = state;
    if (currentState is GameRunning) {
      final updatedData = gameService.updateGame(event.deltaTime);
      emit(GameRunning(
        score: updatedData['score'],
        coins: updatedData['coins'],
        gameSpeed: updatedData['gameSpeed'],
        enemies: updatedData['enemies'],
        obstacles: updatedData['obstacles'],
        coinPickups: updatedData['coinPickups'],
        bullets: updatedData['bullets'],
      ));
    }
  }

  void _onSpawnEnemy(SpawnEnemyEvent event, Emitter<GameState> emit) {
    gameService.spawnEnemy();
  }

  void _onSpawnObstacle(SpawnObstacleEvent event, Emitter<GameState> emit) {
    gameService.spawnObstacle();
  }

  void _onAddBullet(AddBulletEvent event, Emitter<GameState> emit) {
    gameService.addBullet(event.x, event.y);
  }
}