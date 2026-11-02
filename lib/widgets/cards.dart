import 'package:flutter/cupertino.dart';

import '../core/design/app_colors.dart';
import '../core/design/app_dims.dart';
import '../core/design/app_typography.dart';
import '../core/models/media.dart';
import 'art_image.dart';

/// Square artwork with title + subtitle underneath — the card used by the
/// Home, Browse and Your Library rails.
class MediaCard extends StatelessWidget {
  const MediaCard({
    super.key,
    required this.title,
    required this.subtitle,
    required this.art,
    this.width = 160,
    this.overline,
    this.onTap,
  });

  final String title;
  final String subtitle;
  final String art;
  final double width;
  final String? overline;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      pressedOpacity: 0.7,
      onPressed: onTap,
      child: SizedBox(
        width: width,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            if (overline != null) ...<Widget>[
              Text(
                overline!.toUpperCase(),
                style: AppTypography.caption.copyWith(
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(height: 4),
            ],
            Flexible(
              child: Center(
                child: AspectRatio(
                  aspectRatio: 1,
                  child: ArtImage(asset: art, radius: AppDims.radiusCard),
                ),
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.headline,
            ),
            const SizedBox(height: 2),
            Text(
              subtitle,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: AppTypography.subheadline,
            ),
          ],
        ),
      ),
    );
  }
}

/// Wide image tile with the label burned into the bottom-left corner, used by
/// the Browse and Search genre grids.
class CategoryTile extends StatelessWidget {
  const CategoryTile({super.key, required this.category, this.onTap});

  final Category category;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      pressedOpacity: 0.7,
      onPressed: onTap,
      child: AspectRatio(
        aspectRatio: 166 / 120,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppDims.radiusTile),
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Image.asset(category.art, fit: BoxFit.cover),
              const DecoratedBox(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.bottomRight,
                    colors: <Color>[Color(0x00000000), Color(0x99000000)],
                  ),
                ),
              ),
              Positioned(
                left: 14,
                bottom: 12,
                child: Text(
                  category.title,
                  style: AppTypography.title2.copyWith(
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Edge-to-edge scrolling rail that keeps the platform gutter on both ends.
class MediaRail extends StatelessWidget {
  const MediaRail({super.key, required this.children, this.height = 250});

  final List<Widget> children;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppDims.gutter,
          vertical: 16,
        ),
        itemCount: children.length,
        separatorBuilder: (_, _) => const SizedBox(width: 16),
        itemBuilder: (_, int i) => children[i],
      ),
    );
  }
}
