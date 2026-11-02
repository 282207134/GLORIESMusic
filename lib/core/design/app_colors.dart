import 'package:flutter/widgets.dart';

/// Palette lifted from the GLORIES Music iOS 14 file (Pixso).
///
/// Source styles: `Colors | Accent / Pink`, `Colors | Graybase / Gray 1-4`,
/// and the `Backgrounds / Keyboards – Dark` fill used by every screen.
abstract final class AppColors {
  static const Color canvas = Color(0xFF2C2C2E);
  static const Color canvasDeep = Color(0xFF1C1C1E);
  static const Color surface = Color(0xFF3A3A3C);
  static const Color surfaceHigh = Color(0xFF48484A);

  static const Color accent = Color(0xFFFF2D55);
  static const Color accentSoft = Color(0x33FF2D55);
  static const Color blue = Color(0xFF007AFF);
  static const Color green = Color(0xFF34C759);

  static const Color textPrimary = Color(0xFFFFFFFF);
  static const Color textSecondary = Color(0xFF8E8E93);
  static const Color textTertiary = Color(0xFF48484A);
  static const Color separator = Color(0x1AFFFFFF);

  /// Backdrop behind the full-screen player sheets (Now Playing #3/#4).
  static const List<Color> playerGradient = <Color>[
    Color(0xFF2A1F3D),
    Color(0xFF1D2A4A),
    Color(0xFF3A1F3F),
  ];
}
