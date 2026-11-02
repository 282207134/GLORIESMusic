import 'package:flutter/cupertino.dart';

import 'app_colors.dart';
import 'app_typography.dart';

/// One dark Cupertino theme for the whole app, so screens never set colours on
/// their own chrome (nav bar, sheet barrier, scroll glow).
abstract final class AppTheme {
  static final CupertinoThemeData cupertino = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: AppColors.accent,
    primaryContrastingColor: AppColors.textPrimary,
    scaffoldBackgroundColor: AppColors.canvas,
    barBackgroundColor: AppColors.canvas,
    textTheme: const CupertinoTextThemeData(
      primaryColor: AppColors.textPrimary,
      actionTextStyle: AppTypography.button,
    ),
  );
}
