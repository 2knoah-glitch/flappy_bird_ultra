import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'flapping_bird_game.dart';

/// Decides which medal to award based on score.
enum MedalTier { none, bronze, silver, gold, platinum }

class MedalHelper {
  static MedalTier tierFor(int score) {
    if (score >= 40) return MedalTier.platinum;
    if (score >= 30) return MedalTier.gold;
    if (score >= 20) return MedalTier.silver;
    if (score >= 10) return MedalTier.bronze;
    return MedalTier.none;
  }

  static String assetName(MedalTier tier) {
    switch (tier) {
      case MedalTier.platinum: return 'medal_platinum.png';
      case MedalTier.gold:     return 'medal_gold.png';
      case MedalTier.silver:   return 'medal_silver.png';
      case MedalTier.bronze:   return 'medal_bronze.png';
      case MedalTier.none:     return '';
    }
  }
}
