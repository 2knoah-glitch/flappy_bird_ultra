import 'package:flame_audio/flame_audio.dart';

/// Centralized audio manager for SFX. Uses flame_audio (which wraps audioplayers).
class Audio {
  static const _swoosh = 'swoosh.mp3';
  static const _wing = 'wing.mp3';
  static const _point = 'point.mp3';
  static const _hit = 'hit.mp3';
  static const _die = 'die.mp3';

  /// Preload all sound effects into memory.
  static Future<void> init() async {
    await FlameAudio.audioCache.loadAll([
      _swoosh, _wing, _point, _hit, _die,
    ]);
  }

  static void swoosh() => FlameAudio.play(_swoosh, volume: 0.6);
  static void wing()  => FlameAudio.play(_wing,  volume: 0.6);
  static void point() => FlameAudio.play(_point, volume: 0.7);
  static void hit()   => FlameAudio.play(_hit,   volume: 0.8);
  static void die()   => FlameAudio.play(_die,   volume: 0.8);
}
