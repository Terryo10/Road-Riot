import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../utils/constants.dart';

class Road extends Component {
  final List<RectangleComponent> laneMarkers = [];
  double scrollOffset = 0;

  @override
  Future<void> onLoad() async {
    final parentSize =
        (parent is HasGameRef
            ? (parent as HasGameRef).gameRef.size
            : Vector2(0, 0));
    add(
      RectangleComponent(
        size: parentSize,
        paint: Paint()..color = Colors.grey[800]!,
      ),
    );
    final laneWidth = parentSize.x / GameConstants.laneCount;
    for (int i = 1; i < GameConstants.laneCount; i++) {
      for (
        double y = 0;
        y < parentSize.y + GameConstants.laneMarkerSpacing;
        y += GameConstants.laneMarkerSpacing
      ) {
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
    final parentSize =
        (parent is HasGameRef
            ? (parent as HasGameRef).gameRef.size
            : Vector2(0, 0));
    scrollOffset += dt * GameConstants.roadScrollSpeed;
    for (final marker in laneMarkers) {
      marker.position.y += dt * GameConstants.roadScrollSpeed;
      if (marker.position.y > parentSize.y + 50) {
        marker.position.y = -50;
      }
    }
  }
}
