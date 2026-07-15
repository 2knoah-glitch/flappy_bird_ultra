import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'flapping_bird_game.dart';

/// A single pair of top + bottom pipes with a gap.
class PipePair extends PositionComponent with HasGameRef<FlappingBirdGame> {
  late Sprite _bodySprite;
  late Sprite _capSprite;
  final double gapY; // center of the gap
  bool _scored = false;

  PipePair({required this.gapY});

  @override
  Future<void> onLoad() async {
    _bodySprite = await gameRef.loadSprite('pipe_green.png');
    _capSprite  = await gameRef.loadSprite('pipe_green_cap.png');
    size = Vector2(GameConfig.pipeWidth, gameRef.size.y);
  }

  @override
  void update(double dt) {
    if (gameRef.state != GameState.playing) return;
    x -= GameConfig.pipeSpeed * dt;

    // Score when bird passes the center of the pipe.
    if (!_scored && x + width < gameRef.bird.x) {
      _scored = true;
      gameRef.onPipePassed();
    }

    // Remove once off-screen.
    if (x + width < -50) {
      removeFromParent();
    }
  }

  @override
  void render(Canvas canvas) {
    final groundTop = gameRef.size.y - GameConfig.groundHeight;
    final gapHalf = GameConfig.pipeGap / 2;

    // --- Top pipe ---
    final topPipeHeight = gapY - gapHalf;
    // Body
    _bodySprite.render(
      canvas,
      position: Vector2(0, 0),
      size: Vector2(width, topPipeHeight - 26),
    );
    // Cap
    _capSprite.render(
      canvas,
      position: Vector2(-3, topPipeHeight - 26),
      size: Vector2(width + 6, 26),
    );

    // --- Bottom pipe ---
    final bottomPipeTop = gapY + gapHalf;
    final bottomPipeHeight = groundTop - bottomPipeTop;
    // Cap
    _capSprite.render(
      canvas,
      position: Vector2(-3, bottomPipeTop),
      size: Vector2(width + 6, 26),
    );
    // Body
    _bodySprite.render(
      canvas,
      position: Vector2(0, bottomPipeTop + 26),
      size: Vector2(width, bottomPipeHeight - 26),
    );
  }

  /// Simple AABB collision check against the bird.
  bool collidesWith(Bird bird) {
    final gapHalf = GameConfig.pipeGap / 2;
    final birdX = bird.x;
    final birdY = bird.y;
    final birdR = bird.width / 2 * 0.8; // slight forgiveness

    // X overlap?
    if (birdX + birdR < x || birdX - birdR > x + width) return false;

    // Top pipe overlap?
    if (birdY - birdR < gapY - gapHalf) return true;
    // Bottom pipe overlap?
    if (birdY + birdR > gapY + gapHalf) return true;

    return false;
  }
}
