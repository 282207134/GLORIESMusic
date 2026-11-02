import 'package:flutter/widgets.dart';

import '../core/design/app_colors.dart';

/// Rounded artwork. Falls back to an accent gradient when the design file had
/// no embedded bitmap for a given slot, so no tile is ever a blank hole.
class ArtImage extends StatelessWidget {
  const ArtImage({
    super.key,
    required this.asset,
    this.size,
    this.radius = 6,
    this.fit = BoxFit.cover,
  });

  final String asset;
  final double? size;
  final double radius;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(radius),
      child: SizedBox(
        width: size,
        height: size,
        child: Image.asset(
          asset,
          fit: fit,
          errorBuilder: (_, _, _) => const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: <Color>[AppColors.surfaceHigh, AppColors.accentSoft],
              ),
            ),
            child: SizedBox.expand(),
          ),
        ),
      ),
    );
  }
}
