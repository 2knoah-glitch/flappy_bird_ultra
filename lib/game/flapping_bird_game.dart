import 'package:flame/game.dart';
import 'package:flame/input.dart';
import 'package:flutter/material.dart';

import '../utils/audio.dart';
import '../utils/storage.dart';
import 'background.dart';
import 'bird.dart';
import 'ground.dart';
import 'pipe_manager.dart';
import 'score_display.dart';
import 'get_ready_panel.dart';
import 'game_over_panel.dart';

/// State machine for the whole game.
enum GameState { ready, playing, gameOver }

/// Constants used across components.
class GameConfig {
  static const double gravity = 1100;        // px/s^2
  static const double flapVelocity = -360;   // px/s (negative = up)
  static const double pipeSpeed = 160;       // px/s
  static const double pipeGap = 160;         // px
  static const double pipeWidth = 70;        // px
  static const double pipeSpawnInterval = 1.5; // seconds
  static const double groundHeight = 110;    // px
  static const double birdSize = 48;         // px
}

class FlappingBirdGame extends FlameGame with TapDetector {
  late Background background;
  late Ground ground;
  late Bird bird;
  late PipeManager pipeManager;
  late ScoreDisplay scoreDisplay;
  late GetReadyPanel getReadyPanel;
  late GameOverPanel gameOverPanel;

  GameState state = GameState.ready;
  int score = 0;
  int highScore = 0;

  @override
  Future<void> onLoad() async {
    await Audio.init();
    highScore = Storage.highScore;

    background = Background();
    add(background);

    ground = Ground();
    add(ground);

    bird = Bird();
    add(bird);

    pipeManager = PipeManager();
    add(pipeManager);

    scoreDisplay = ScoreDisplay();
    add(scoreDisplay);

    getReadyPanel = GetReadyPanel();
    add(getReadyPanel);

    gameOverPanel = GameOverPanel();
    add(gameOverPanel);
    gameOverPanel.visible = false;
  }

  /// Single tap behavior depends on current game state.
  @override
  void onTap() {
    switch (state) {
      case GameState.ready:
        _startGame();
        break;
      case GameState.playing:
        bird.flap();
        break;
      case GameState.gameOver:
        // Ignore taps; restart happens through the panel button.
        break;
    }
  }

  void _startGame() {
    state = GameState.playing;
    score = 0;
    bird.reset();
    pipeManager.reset();
    getReadyPanel.visible = false;
    gameOverPanel.visible = false;
    bird.flap();
    Audio.swoosh();
  }

  void onPipePassed() {
    score++;
    Audio.point();
  }

  void onCollision() {
    if (state != GameState.playing) return;
    state = GameState.gameOver;
    Audio.hit();
    Future.delayed(const Duration(milliseconds: 120), () => Audio.die());

    if (score > highScore) {
      highScore = score;
      Storage.setHighScore(highScore);
    }
    gameOverPanel.show(score: score, highScore: highScore);
  }

  /// Restart from the game over panel.
  void restart() {
    state = GameState.ready;
    score = 0;
    bird.reset();
    pipeManager.reset();
    getReadyPanel.visible = true;
    gameOverPanel.visible = false;
    Audio.swoosh();
  }

  @override
  void update(double dt) {
    super.update(dt);

    // Only run gameplay logic while playing.
    if (state == GameState.playing) {
      // Top-of-screen collision.
      if (bird.y < 0) {
        bird.y = 0;
        bird.velocity = 0;
        onCollision();
      }

      // Ground collision.
      final groundTop = size.y - GameConfig.groundHeight;
      if (bird.y + bird.height >= groundTop) {
        bird.y = groundTop - bird.height;
        bird.velocity = 0;
        onCollision();
      }
    }
  }
}
