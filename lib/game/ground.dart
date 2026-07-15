import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'flapping_bird_game.dart';

/// Scrolling green ground at the bottom of the screen.
class Ground extends PositionComponent with HasGameRef<FlappingBirdGame> {
  late Sprite _sprite;
  double _offset = 0;

  @override
  Future<void> onLoad() async {
    _sprite = await gameRef.loadSprite('ground.png');
    size = Vector2(gameRef.size.x, GameConfig.groundHeight);
    y = gameRef.size.y - GameConfig.groundHeight;
  }

  @override
  void update(double dt) {
    if (gameRef.state == GameState.playing) {
      _offset = (_offset - GameConfig.pipeSpeed * dt) % _sprite.srcSize.x;
    }
  }

  @override
  void render(Canvas canvas) {
    final srcW = _sprite.srcSize.x;
    final tiles = (width / srcW).ceil() + 1;
    for (int i = -1; i < tiles; i++) {
      _sprite.render(
        canvas,
        position: Vector2(i * srcW + _offset, 0),
        size: Vector2(srcW, height),
      );
    }
  }
}
