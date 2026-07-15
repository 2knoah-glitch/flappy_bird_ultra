import 'dart:math';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'flapping_bird_game.dart';
import 'pipe.dart';

/// Spawns PipePair entities on a fixed interval, handles collision checks.
class PipeManager extends Component with HasGameRef<FlappingBirdGame> {
  double _spawnTimer = 0;
  final Random _rng = Random();

  void reset() {
    _spawnTimer = 0;
    children.whereType<PipePair>().toList().forEach((c) => c.removeFromParent());
  }

  @override
  void update(double dt) {
    if (gameRef.state != GameState.playing) return;

    _spawnTimer += dt;
    if (_spawnTimer >= GameConfig.pipeSpawnInterval) {
      _spawnTimer = 0;
      _spawnPipe();
    }

    // Check collisions.
    for (final pipe in children.whereType<PipePair>()) {
      if (pipe.collidesWith(gameRef.bird)) {
        gameRef.onCollision();
        break;
      }
    }
  }

  void _spawnPipe() {
    final groundTop = gameRef.size.y - GameConfig.groundHeight;
    final minGapY = GameConfig.pipeGap / 2 + 60;
    final maxGapY = groundTop - GameConfig.pipeGap / 2 - 60;
    final gapY = minGapY + _rng.nextDouble() * (maxGapY - minGapY);

    final pipe = PipePair(gapY: gapY);
    pipe.x = gameRef.size.x + 50;
    add(pipe);
  }
}
