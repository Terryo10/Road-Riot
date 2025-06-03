
// File: lib/game/game_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flame/game.dart';
import '../blocs/game_bloc/game_bloc.dart';
import '../blocs/player_bloc/player_bloc.dart';
import 'road_riot_game.dart';
import 'ui/game_overlay.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late RoadRiotGame game;

  @override
  void initState() {
    super.initState();
    game = RoadRiotGame(
      gameBloc: context.read<GameBloc>(),
      playerBloc: context.read<PlayerBloc>(),
    );
    
    // Start the game
    context.read<GameBloc>().add(StartGameEvent());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GameWidget<RoadRiotGame>.controlled(
            gameFactory: () => game,
          ),
          const GameOverlay(),
        ],
      ),
    );
  }

  @override
  void dispose() {
    game.onRemove();
    super.dispose();
  }
}