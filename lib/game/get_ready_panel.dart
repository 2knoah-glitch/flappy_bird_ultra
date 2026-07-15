import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'flapping_bird_game.dart';

/// "Get Ready" title + tap hint shown before the game starts.
class GetReadyPanel extends PositionComponent with HasGameRef<FlappingBirdGame> {
  late Sprite _titleSprite;
  late Sprite _hintSprite;

  @override
  Future<void> onLoad() async {
    _titleSprite = await gameRef.loadSprite('get_ready.png');
    _hintSprite  = await gameRef.loadSprite('tap_hint.png');
    size = gameRef.size;
  }

  @override
  void render(Canvas canvas) {
    if (!visible) return;

    // Title
    final titleW = size.x * 0.7;
    final titleH = titleW * (_titleSprite.srcSize.y / _titleSprite.srcSize.x);
    _titleSprite.render(
      canvas,
      position: Vector2((size.x - titleW) / 2, size.y * 0.25),
      size: Vector2(titleW, titleH),
    );

    // Tap hint
    final hintW = size.x * 0.45;
    final hintH = hintW * (_hintSprite.srcSize.y / _hintSprite.srcSize.x);
    _hintSprite.render(
      canvas,
      position: Vector2((size.x - hintW) / 2, size.y * 0.55),
      size: Vector2(hintW, hintH),
    );
  }
}
