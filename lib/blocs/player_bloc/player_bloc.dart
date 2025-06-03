
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'player_event.dart';
part 'player_state.dart';

class PlayerBloc extends Bloc<PlayerEvent, PlayerState> {
  PlayerBloc() : super(const PlayerActive(
    lane: 2.0,
    health: 100.0,
    maxHealth: 100.0,
    isMoving: false,
  )) {
    on<MovePlayerEvent>(_onMovePlayer);
    on<ShootEvent>(_onShoot);
    on<TakeDamageEvent>(_onTakeDamage);
    on<HealEvent>(_onHeal);
  }

  void _onMovePlayer(MovePlayerEvent event, Emitter<PlayerState> emit) {
    final currentState = state;
    if (currentState is PlayerActive) {
      final clampedLane = event.targetLane.clamp(0.0, 5.0);
      emit(currentState.copyWith(lane: clampedLane, isMoving: true));
      
      // Reset moving state after animation
      Future.delayed(const Duration(milliseconds: 300), () {
        if (!isClosed && state is PlayerActive) {
          final activeState = state as PlayerActive;
          emit(activeState.copyWith(isMoving: false));
        }
      });
    }
  }

  void _onShoot(ShootEvent event, Emitter<PlayerState> emit) {
    // Shooting logic handled by game bloc
    // This event is used to trigger shooting in the game
  }

  void _onTakeDamage(TakeDamageEvent event, Emitter<PlayerState> emit) {
    final currentState = state;
    if (currentState is PlayerActive) {
      final newHealth = (currentState.health - event.damage).clamp(0.0, currentState.maxHealth);
      emit(currentState.copyWith(health: newHealth));
    }
  }

  void _onHeal(HealEvent event, Emitter<PlayerState> emit) {
    final currentState = state;
    if (currentState is PlayerActive) {
      final newHealth = (currentState.health + event.healAmount).clamp(0.0, currentState.maxHealth);
      emit(currentState.copyWith(health: newHealth));
    }
  }
}