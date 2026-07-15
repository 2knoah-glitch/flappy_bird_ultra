import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'dart:ui';

// flapping_bird_game.dart

class FlappingBirdGame {
  // TODO: Implement game loop and Flame/Widget integration
}

/// Scrolling blue-sky background. Scrolls slower than pipes for a parallax feel.
class Background extends Component with HasGameRef<FlappingBirdGame> {
  late Sprite _sprite;
  final double _scrollSpeed = 40; // slow parallax

  @override
  Future<void> onLoad() async {
    _sprite = await gameRef.loadSprite('background_day.png');
  }

  @override
  void render(Canvas canvas) {
    final double w = gameRef.size.x;
    final double h = gameRef.size.y;
    // Tile the background image horizontally.
    final srcW = _sprite.srcSize.x;
    int tiles = (w / srcW).ceil() + 1;
    for (int i = 0; i < tiles; i++) {
      _sprite.render(
        canvas,
        position: Vector2(i * srcW, 0),
        size: Vector2(srcW, h),
      );
    }
  }
}
