// File: lib/screens/main_menu.dart
import 'package:flutter/material.dart';
import '../game_screen.dart';
import 'shop_screen.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.orange, Colors.red],
          ),
        ),
        child: SafeArea(
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Game Title
                const Text(
                  'ROAD RIOT',
                  style: TextStyle(
                    fontSize: 48,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                    shadows: [
                      Shadow(
                        offset: Offset(3, 3),
                        blurRadius: 6,
                        color: Colors.black54,
                      ),
                    ],
                    letterSpacing: 4,
                  ),
                ),
                const SizedBox(height: 20),

                // Subtitle
                const Text(
                  'Survive the Highway!',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.white70,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 60),

                // Start Game Button
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const GameScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: Colors.red,
                      elevation: 8,
                      shadowColor: Colors.black54,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.play_arrow, size: 28),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'START GAME',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Shop Button
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const ShopScreen(),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.shopping_cart, size: 24),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text('SHOP', overflow: TextOverflow.ellipsis),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // Settings Button
                SizedBox(
                  width: MediaQuery.of(context).size.width * 0.6,
                  height: 55,
                  child: ElevatedButton(
                    onPressed: () {
                      _showSettingsDialog(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.transparent,
                      foregroundColor: Colors.white,
                      side: const BorderSide(color: Colors.white, width: 2),
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: const [
                        Icon(Icons.settings, size: 24),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'SETTINGS',
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Version info
                const Text(
                  'Version 1.0.0',
                  style: TextStyle(color: Colors.white60, fontSize: 12),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showSettingsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Settings'),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ListTile(
                  leading: const Icon(Icons.volume_up),
                  title: const Text('Sound Effects'),
                  trailing: Switch(
                    value: true, // TODO: Connect to audio manager
                    onChanged: (value) {
                      // TODO: Implement sound toggle
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.music_note),
                  title: const Text('Background Music'),
                  trailing: Switch(
                    value: true, // TODO: Connect to audio manager
                    onChanged: (value) {
                      // TODO: Implement music toggle
                    },
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.vibration),
                  title: const Text('Vibration'),
                  trailing: Switch(
                    value: true, // TODO: Connect to haptic feedback
                    onChanged: (value) {
                      // TODO: Implement vibration toggle
                    },
                  ),
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ],
          ),
    );
  }
}
