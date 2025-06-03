// File: lib/main.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:provider/provider.dart';
import 'game/game_screen.dart';
import 'blocs/game_bloc/game_bloc.dart';
import 'blocs/player_bloc/player_bloc.dart';
import 'blocs/shop_bloc/shop_bloc.dart';
import 'game/screens/main_menu.dart';
import 'game/screens/shop_screen.dart';
import 'repositories/game_repository.dart';
import 'services/game_service.dart';

void main() {
  runApp(const RoadRiotApp());
}

class RoadRiotApp extends StatelessWidget {
  const RoadRiotApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<GameRepository>(
          create: (context) => GameRepository(),
        ),
        Provider<GameService>(
          create: (context) => GameService(
            repository: context.read<GameRepository>(),
          ),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider<GameBloc>(
            create: (context) => GameBloc(
              gameService: context.read<GameService>(),
            ),
          ),
          BlocProvider<PlayerBloc>(
            create: (context) => PlayerBloc(),
          ),
          BlocProvider<ShopBloc>(
            create: (context) => ShopBloc(
              gameRepository: context.read<GameRepository>(),
            ),
          ),
        ],
        child: MaterialApp(
          title: 'Road Riot',
          theme: ThemeData(
            primarySwatch: Colors.red,
            fontFamily: 'Roboto',
          ),
          home: const MainMenu(),
          debugShowCheckedModeBanner: false,
          routes: {
            '/game': (context) => const GameScreen(),
            '/shop': (context) => const ShopScreen(),
          },
        ),
      ),
    );
  }
}
