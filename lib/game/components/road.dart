import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class Road extends Component {
  final List<RectangleComponent> laneMarkers = [];
  double scrollOffset = 0;

  @override
  Future<void> onLoad() async {
    // Create road background
    add(RectangleComponent(
      size: game.size,
      paint: Paint()..color = Colors.grey[800]!,
    ));

    // Create lane markers
    final laneWidth = game.size.x / GameConstants.laneCount;
    
    for (int i = 1; i < GameConstants.laneCount; i++) {
      for (double y = 0; y < game.size.y + GameConstants.laneMarkerSpacing; 
           y += GameConstants.laneMarkerSpacing) {
        final marker = RectangleComponent(
          position: Vector2(i * laneWidth - 2, y),
          size: Vector2(4, GameConstants.laneMarkerHeight),
          paint: Paint()..color = Colors.white,
        );
        laneMarkers.add(marker);
        add(marker);
      }
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    
    // Scroll road
    scrollOffset += dt * GameConstants.roadScrollSpeed;
    
    // Update lane marker positions
    for (final marker in laneMarkers) {
      marker.position.y += dt * GameConstants.roadScrollSpeed;
      
      // Reset position when marker goes off screen
      if (marker.position.y > game.size.y + 50) {
        marker.position.y = -50;
      }
    }
  }
}
