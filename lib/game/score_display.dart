import 'dart:ui';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import 'flapping_bird_game.dart';

/// Big white score text with a black outline, displayed top-center.
class ScoreDisplay extends TextComponent with HasGameRef<FlappingBirdGame> {
  @override
  Future<void> onLoad() async {
    textRenderer = TextPaint(
      style: const TextStyle(
        fontSize: 64,
        color: Colors.white,
        fontWeight: FontWeight.w800,
        fontFamily: 'Roboto',
        shadows: [
          Shadow(offset: Offset(-3, 0), color: Colors.black),
          Shadow(offset: Offset(3, 0), color: Colors.black),
          Shadow(offset: Offset(0, -3), color: Colors.black),
          Shadow(offset: Offset(0, 3), color: Colors.black),
          Shadow(offset: Offset(-2, -2), color: Colors.black),
          Shadow(offset: Offset(2, -2), color: Colors.black),
          Shadow(offset: Offset(-2, 2), color: Colors.black),
          Shadow(offset: Offset(2, 2), color: Colors.black),
        ],
      ),
    );
    anchor = Anchor.topCenter;
  }

  @override
  void update(double dt) {
    text = gameRef.score.toString();
    x = gameRef.size.x / 2;
    y = 40;
  }
}
