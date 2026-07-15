import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'flapping_bird_game.dart';
import 'medal.dart';

/// The Game Over panel with score, high score, medal, and a Restart button.
class GameOverPanel extends PositionComponent
    with HasGameRef<FlappingBirdGame>, TapCallbacks {
  late Sprite _panelSprite;
  late Sprite? _medalSprite;
  MedalTier _medalTier = MedalTier.none;
  int _score = 0;
  int _highScore = 0;
  bool _initialized = false;

  // Restart button rect (in local coords).
  late final Rect _restartButtonRect;

  @override
  Future<void> onLoad() async {
    _panelSprite = await gameRef.loadSprite('game_over_panel.png');
    size = gameRef.size;
  }

  void show({required int score, required int highScore}) {
    _score = score;
    _highScore = highScore;
    _medalTier = MedalHelper.tierFor(score);
    _medalSprite = _medalTier == MedalTier.none
        ? null
        : await gameRef.loadSprite(MedalHelper.assetName(_medalTier));
    _initialized = true;
    visible = true;
  }

  @override
  void render(Canvas canvas) {
    if (!visible || !_initialized) return;

    // Dim background overlay.
    final paint = Paint()..color = const Color(0x88000000);
    canvas.drawRect(Offset.zero & size.toSize(), paint);

    // Panel.
    final panelW = size.x * 0.85;
    final panelH = panelW * (_panelSprite.srcSize.y / _panelSprite.srcSize.x);
    final panelX = (size.x - panelW) / 2;
    final panelY = size.y * 0.22;
    _panelSprite.render(
      canvas,
      position: Vector2(panelX, panelY),
      size: Vector2(panelW, panelH),
    );

    // Medal.
    if (_medalSprite != null) {
      final medalSize = panelW * 0.28;
      _medalSprite!.render(
        canvas,
        position: Vector2(panelX + panelW * 0.10, panelY + panelH * 0.32),
        size: Vector2.all(medalSize),
      );
    }

    // Score text (current + best).
    final scorePaint = TextPaint(
      style: const TextStyle(
        fontSize: 28,
        color: Colors.white,
        fontWeight: FontWeight.w800,
        shadows: [Shadow(offset: Offset(2, 2), color: Colors.black)],
      ),
    );
    scorePaint.render(
      canvas,
      '$_score',
      Vector2(panelX + panelW * 0.82, panelY + panelH * 0.30),
      anchor: Anchor.topRight,
    );
    scorePaint.render(
      canvas,
      '$_highScore',
      Vector2(panelX + panelW * 0.82, panelY + panelH * 0.58),
      anchor: Anchor.topRight,
    );

    // Restart button (yellow rounded rect with "RETRY" text).
    final btnW = panelW * 0.45;
    final btnH = 60.0;
    final btnX = (size.x - btnW) / 2;
    final btnY = panelY + panelH + 30;
    _restartButtonRect = Rect.fromLTWH(btnX, btnY, btnW, btnH);

    final btnPaint = Paint()..color = const Color(0xFFFAD643);
    final rrect = RRect.fromRectAndRadius(_restartButtonRect, const Radius.circular(12));
    canvas.drawRRect(rrect, btnPaint);

    final btnTextPaint = TextPaint(
      style: const TextStyle(
        fontSize: 28,
        color: Color(0xFF543847),
        fontWeight: FontWeight.w800,
      ),
    );
    btnTextPaint.render(
      canvas,
      'RETRY',
      Vector2(_restartButtonRect.center.dx, _restartButtonRect.center.dy),
      anchor: Anchor.center,
    );

    // Footer credit.
    final creditPaint = TextPaint(
      style: const TextStyle(
        fontSize: 14,
        color: Color(0xCCFFFFFF),
      ),
    );
    creditPaint.render(
      canvas,
      'Made with ABYSSCORE - LLC',
      Vector2(size.x / 2, size.y - 24),
      anchor: Anchor.center,
    );
  }

  @override
  bool onTapDown(TapDownEvent event) {
    if (!visible) return false;
    final pos = event.localPosition;
    if (_restartButtonRect.contains(Offset(pos.x, pos.y))) {
      gameRef.restart();
      return true;
    }
    return false;
  }
}
