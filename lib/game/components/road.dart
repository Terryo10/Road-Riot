// File: lib/game/components/road.dart
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class Road extends Component with HasGameRef {
  final List<RectangleComponent> laneMarkers = [];
  double scrollOffset = 0;

  @override
  Future<void> onLoad() async {
    await super.onLoad();
    
    // Add road background
    add(
      RectangleComponent(
        size: gameRef.size,
        paint: Paint()..color = Colors.grey[800]!,
      ),
    );

    // Create lane markers
    _createLaneMarkers();
  }

  void _createLaneMarkers() {
    final laneWidth = gameRef.size.x / GameConstants.laneCount;
    
    // Create lane dividers (5 dividers for 6 lanes)
    for (int lane = 1; lane < GameConstants.laneCount; lane++) {
      final x = lane * laneWidth;
      
      // Create multiple markers for each lane at different Y positions
      for (double y = -GameConstants.laneMarkerSpacing; 
           y < gameRef.size.y + GameConstants.laneMarkerSpacing * 2; 
           y += GameConstants.laneMarkerSpacing) {
        final marker = RectangleComponent(
          position: Vector2(x - 2, y),
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
    
    // Scroll the road by moving lane markers
    scrollOffset += dt * GameConstants.roadScrollSpeed;
    
    for (final marker in laneMarkers) {
      marker.position.y += dt * GameConstants.roadScrollSpeed;
      
      // Reset marker position when it goes off screen
      if (marker.position.y > gameRef.size.y + 50) {
        marker.position.y = -GameConstants.laneMarkerHeight - 50;
      }
    }
  }
}