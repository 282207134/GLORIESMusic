/// Layout constants shared by every screen, taken from the 375pt-wide artboards.
abstract final class AppDims {
  /// Artboards place content at x=1756 inside a frame starting at x=1740.
  static const double gutter = 16;
  static const double rowHeight = 44;
  static const double separatorHeight = 1;

  static const double radiusCard = 6;
  static const double radiusTile = 14;
  static const double radiusSheet = 24;
  static const double radiusPill = 999;

  static const double miniPlayerHeight = 64;
  static const double tabBarHeight = 49;
  static const double homeIndicatorHeight = 34;

  /// Height of the drag handle drawn at the top of every modal sheet.
  static const double grabberHeight = 26;
}
