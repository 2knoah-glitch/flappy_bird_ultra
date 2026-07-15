import 'package:shared_preferences/shared_preferences.dart';

/// Wraps SharedPreferences for high-score storage.
class Storage {
  static const _highScoreKey = 'fbu_high_score';

  static late SharedPreferences _prefs;

  static Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  static int get highScore => _prefs.getInt(_highScoreKey) ?? 0;

  static Future<void> setHighScore(int value) async {
    await _prefs.setInt(_highScoreKey, value);
  }
}
