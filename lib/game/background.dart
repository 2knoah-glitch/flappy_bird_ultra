import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'flapping_bird_game.dart';

/// Scrolling blue-sky background. Scrolls slower than pipes for a parallax feel.
class Background extends Component with HasGameRef<FlappingBirdGame> {
  late Sprite _sprite;
  final double _scrollSpeed = 40;
  double _offset = 0;

  @override
  Future<void> onLoad() async {
    _sprite = await gameRef.loadSprite('background_day.png');
  }

  @override
  void update(double dt) {
    _offset = (_offset - _scrollSpeed * dt) % _sprite.srcSize.x;
  }

  @override
  void render(Canvas canvas) {
    final double w = gameRef.size.x;
    final double h = gameRef.size.y;
    final srcW = _sprite.srcSize.x;
    final tiles = (w / srcW).ceil() + 1;
    for (int i = -1; i < tiles; i++) {
      _sprite.render(
        canvas,
        position: Vector2(i * srcW + _offset, 0),
        size: Vector2(srcW, h),
      );
    }
  }
}
