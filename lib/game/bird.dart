import 'dart:math';
import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'flapping_bird_game.dart';
import '../utils/audio.dart';

/// The yellow bird. Handles gravity, flapping, wing animation, and rotation.
class Bird extends SpriteAnimationComponent with HasGameRef<FlappingBirdGame> {
  double velocity = 0;
  double _animTime = 0;

  Bird() : super(size: Vector2.all(GameConfig.birdSize), anchor: Anchor.center);

  @override
  Future<void> onLoad() async {
    final frames = [
      await gameRef.loadSprite('bird_yellow_flap1.png'),
      await gameRef.loadSprite('bird_yellow.png'),
      await gameRef.loadSprite('bird_yellow_flap2.png'),
      await gameRef.loadSprite('bird_yellow.png'),
    ];
    animation = SpriteAnimation.spriteList(frames, stepTime: 0.1, loop: true);
    x = gameRef.size.x * 0.30;
    y = gameRef.size.y * 0.45;
  }

  void reset() {
    velocity = 0;
    x = gameRef.size.x * 0.30;
    y = gameRef.size.y * 0.45;
    angle = 0;
  }

  void flap() {
    velocity = GameConfig.flapVelocity;
    Audio.wing();
  }

  @override
  void update(double dt) {
    super.update(dt);

    if (gameRef.state == GameState.playing) {
      velocity += GameConfig.gravity * dt;
      y += velocity * dt;

      final targetAngle = velocity < 0 ? -0.5 : (velocity * 0.002).clamp(-0.5, 1.4);
      angle = lerpDouble(angle, targetAngle, 0.2) ?? angle;
    } else if (gameRef.state == GameState.ready) {
      _animTime += dt;
      y = gameRef.size.y * 0.45 + 8 * sin(_animTime * 4);
    }
  }
}
