# 🚗 Road Riot

A fast-paced, lane-based action racing game built with Flutter and Flame engine. Navigate through traffic, dodge obstacles, collect coins, and shoot your way to victory!

## 🎮 Game Features

### 🏎️ Core Gameplay
- **Lane-based Movement**: Navigate through 6 lanes of intense highway action
- **Combat System**: Shoot enemies and obstacles with tap-to-fire mechanics
- **Enemy Encounters**: Face three types of enemies with different behaviors:
  - **Standard Enemies**: Basic opponents with 25 HP
  - **Armored Enemies**: Heavily protected with 75 HP  
  - **Aggressive Enemies**: Fast and dangerous with 50 HP

### 🎯 Game Mechanics
- **Obstacle Avoidance**: Dodge rocks, trees, and pits that appear on the road
- **Coin Collection**: Gather coins for points and in-game currency
- **Health System**: Manage your vehicle's health (starts at 100 HP)
- **Progressive Difficulty**: Game speed increases as you progress
- **Scoring System**: 
  - 100 points per enemy defeated
  - 50 points per coin collected
  - 10 coins currency value

### 🛒 Shop System
- Purchase upgrades and customizations for your vehicle
- Manage your coin currency earned through gameplay

## 🎮 Controls

- **Movement**: Drag left/right to change lanes
- **Shooting**: Tap anywhere on the screen to fire bullets
- **Menu Navigation**: Touch controls for all UI elements

## 🚀 Installation & Setup

### Prerequisites
- Flutter SDK (^3.7.0)
- Dart SDK
- IDE with Flutter support (VS Code, Android Studio, etc.)

### Installation Steps

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd road_riot
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the game**
   ```bash
   flutter run
   ```

### Platform Support
- ✅ Android
- ✅ iOS  
- ✅ Web
- ✅ Windows
- ✅ macOS
- ✅ Linux

## 🏗️ Technical Architecture

### Built With
- **Flutter**: Cross-platform UI framework
- **Flame**: 2D game engine for Flutter
- **BLoC Pattern**: State management using flutter_bloc
- **Provider**: Dependency injection

### Key Dependencies
```yaml
flame: ^1.12.0          # Game engine
flutter_bloc: ^8.1.3    # State management
provider: ^6.1.1        # Dependency injection
equatable: ^2.0.5       # Value equality
```

### Project Structure
```
lib/
├── blocs/              # State management (BLoC pattern)
├── game/               # Game engine components
│   ├── components/     # Game objects (Player, Enemies, etc.)
│   ├── screens/        # Game screens
│   └── ui/             # Game UI elements
├── models/             # Data models
├── repositories/       # Data layer
├── services/           # Business logic
└── utils/              # Constants and utilities
```

## 🎨 Game Components

### Player Car
- Health management system
- Lane-based movement with smooth transitions
- Bullet shooting capabilities

### Enemies
- Multiple enemy types with different characteristics
- AI-driven movement patterns
- Health and damage systems

### Environment
- Scrolling road with lane markers
- Dynamic obstacle generation
- Coin placement system

### UI Systems
- Main menu with game navigation
- In-game HUD showing health, score, and coins
- Shop interface for upgrades

## 🔧 Development

### Game Constants
Key gameplay parameters can be adjusted in `lib/utils/constants.dart`:

- **Lane Count**: 6 lanes
- **Spawn Rates**: Enemies (1.5s), Obstacles (2s)
- **Damage Values**: Enemy collision (20), Obstacle collision (30)
- **Movement Speed**: Player lane switching, bullet speed (300), enemy speed (150)

### State Management
The game uses BLoC pattern for state management:
- `GameBloc`: Manages overall game state, spawning, and updates
- `PlayerBloc`: Handles player actions and state
- `ShopBloc`: Manages shop functionality and purchases

### Adding New Features
1. Create new components in `lib/game/components/`
2. Add corresponding models in `lib/models/`
3. Update relevant BLoCs for state management
4. Register new routes in `main.dart` if needed

## 🎵 Audio (Planned)
The game includes an audio management system ready for implementation:
- Sound effects for shooting, explosions, and collisions
- Background music for menu and gameplay
- Volume controls for music and SFX

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🎯 Future Enhancements

- [ ] Power-ups and special abilities
- [ ] Multiple vehicle types
- [ ] Leaderboard system
- [ ] Achievement system
- [ ] Sound effects and music implementation
- [ ] Particle effects for explosions
- [ ] Weather and environmental effects
- [ ] Boss battles
- [ ] Multiplayer support

---

**Made with ❤️ using Flutter & Flame**
