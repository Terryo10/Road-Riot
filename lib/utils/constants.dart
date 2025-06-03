// File: lib/utils/constants.dart
class GameConstants {
  static const double laneCount = 6.0;
  static const double playerStartHealth = 100.0;
  static const double gameSpeedIncrement = 0.1;
  static const int maxEnemiesOnScreen = 3;
  static const int maxObstaclesOnScreen = 2;
  
  // Damage values
  static const double enemyCollisionDamage = 20.0;
  static const double obstacleCollisionDamage = 30.0;
  
  // Scoring
  static const int enemyKillScore = 100;
  static const int coinCollectScore = 50;
  static const int coinValue = 10;
  
  // Spawn rates (milliseconds)
  static const int enemySpawnRate = 1500;
  static const int obstacleSpawnRate = 2000;
  
  // Player movement
  static const double laneWidth = 60.0;
  static const double carWidth = 50.0;
  static const double carHeight = 80.0;
  
  // Bullet settings
  static const double bulletSpeed = 300.0;
  static const double bulletWidth = 4.0;
  static const double bulletHeight = 10.0;
  
  // Enemy settings
  static const double enemySpeed = 150.0;
  static const double standardEnemyHealth = 25.0;
  static const double armoredEnemyHealth = 75.0;
  static const double aggressiveEnemyHealth = 50.0;
  
  // Road settings
  static const double roadScrollSpeed = 200.0;
  static const double laneMarkerSpacing = 100.0;
  static const double laneMarkerHeight = 50.0;
}

// File: lib/utils/audio_manager.dart
// TODO: Implement audio management with flutter_sound or audioplayers
class AudioManager {
  static final AudioManager _instance = AudioManager._internal();
  factory AudioManager() => _instance;
  AudioManager._internal();

  bool _soundEnabled = true;
  bool _musicEnabled = true;
  double _soundVolume = 1.0;
  double _musicVolume = 0.7;

  // Sound effects
  void playShootSound() {
    if (!_soundEnabled) return;
    // TODO: Implement shoot sound
    // AudioPlayer().play('assets/sounds/shoot.wav', volume: _soundVolume);
  }

  void playExplosionSound() {
    if (!_soundEnabled) return;
    // TODO: Implement explosion sound
    // AudioPlayer().play('assets/sounds/explosion.wav', volume: _soundVolume);
  }

  void playCoinSound() {
    if (!_soundEnabled) return;
    // TODO: Implement coin collection sound
    // AudioPlayer().play('assets/sounds/coin.wav', volume: _soundVolume);
  }

  void playDamageSound() {
    if (!_soundEnabled) return;
    // TODO: Implement damage sound
    // AudioPlayer().play('assets/sounds/damage.wav', volume: _soundVolume);
  }

  void playEngineSound() {
    if (!_soundEnabled) return;
    // TODO: Implement engine sound loop
    // AudioPlayer().play('assets/sounds/engine.wav', volume: _soundVolume, loop: true);
  }

  // Background music
  void playBackgroundMusic() {
    if (!_musicEnabled) return;
    // TODO: Implement background music
    // AudioPlayer().play('assets/music/game_music.mp3', volume: _musicVolume, loop: true);
  }

  void stopBackgroundMusic() {
    // TODO: Stop background music
    // AudioPlayer().stop();
  }

  void playMenuMusic() {
    if (!_musicEnabled) return;
    // TODO: Implement menu music
    // AudioPlayer().play('assets/music/menu_music.mp3', volume: _musicVolume, loop: true);
  }

  // Settings
  void setMusicVolume(double volume) {
    _musicVolume = volume.clamp(0.0, 1.0);
    // TODO: Update current music volume
  }

  void setSFXVolume(double volume) {
    _soundVolume = volume.clamp(0.0, 1.0);
  }

  void enableSound(bool enabled) {
    _soundEnabled = enabled;
  }

  void enableMusic(bool enabled) {
    _musicEnabled = enabled;
    if (!enabled) {
      stopBackgroundMusic();
    }
  }

  bool get isSoundEnabled => _soundEnabled;
  bool get isMusicEnabled => _musicEnabled;
  double get soundVolume => _soundVolume;
  double get musicVolume => _musicVolume;
}