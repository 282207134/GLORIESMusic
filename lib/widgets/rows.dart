import 'package:flutter/cupertino.dart';

import '../core/design/app_colors.dart';
import '../core/design/app_dims.dart';
import '../core/design/app_typography.dart';
import 'art_image.dart';

/// Section eyebrow + optional accent `See All`, closed by a hairline.
///
/// Most rails use the uppercase overline; the Profile artboard writes its two
/// headers in full-size mixed case, which is what [prominent] selects.
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    super.key,
    required this.title,
    this.onSeeAll,
    this.seeAllLabel = 'See All',
    this.prominent = false,
  });

  final String title;
  final VoidCallback? onSeeAll;
  final String seeAllLabel;
  final bool prominent;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDims.gutter),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Text(
                  prominent ? title : title.toUpperCase(),
                  style: prominent
                      ? AppTypography.title3.copyWith(
                          color: AppColors.textPrimary,
                        )
                      : AppTypography.overline.copyWith(
                          color: AppColors.textPrimary,
                        ),
                ),
              ),
              if (onSeeAll != null)
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  onPressed: onSeeAll,
                  child: Text(
                    seeAllLabel,
                    style: AppTypography.footnote.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        const Hairline(),
      ],
    );
  }
}

/// 56pt label + iOS switch row, shared by Setting #1 and Setting #2.
class SwitchRow extends StatelessWidget {
  const SwitchRow({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
  });

  final String title;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 56,
    child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDims.gutter),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(title, style: AppTypography.body)),
          CupertinoSwitch(value: value, onChanged: onChanged),
        ],
      ),
    ),
  );
}

/// Full-width 1px rule used between every list row in the design.
class Hairline extends StatelessWidget {
  const Hairline({super.key, this.indent = AppDims.gutter});

  final double indent;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: indent),
      child: const ColoredBox(
        color: AppColors.separator,
        child: SizedBox(
          height: AppDims.separatorHeight,
          width: double.infinity,
        ),
      ),
    );
  }
}

/// A tappable text row with a trailing chevron, e.g. `Charts >`.
class LinkRow extends StatelessWidget {
  const LinkRow({
    super.key,
    required this.title,
    this.onTap,
    this.color = AppColors.textPrimary,
    this.trailing,
  });

  final String title;
  final VoidCallback? onTap;
  final Color color;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: AppDims.gutter),
      minimumSize: const Size.square(AppDims.rowHeight),
      pressedOpacity: 0.6,
      onPressed: onTap,
      child: Row(
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              style: AppTypography.body.copyWith(color: color),
            ),
          ),
          trailing ??
              const Icon(
                CupertinoIcons.chevron_right,
                size: 14,
                color: AppColors.textSecondary,
              ),
        ],
      ),
    );
  }
}

/// Title + artist stack with artwork and a trailing slot.
class TrackRow extends StatelessWidget {
  const TrackRow({
    super.key,
    required this.title,
    required this.subtitle,
    this.art,
    this.leading,
    this.trailing,
    this.onTap,
    this.number,
  });

  final String title;
  final String subtitle;
  final String? art;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final int? number;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(horizontal: AppDims.gutter),
      minimumSize: const Size.square(64),
      pressedOpacity: 0.6,
      onPressed: onTap,
      child: Row(
        children: <Widget>[
          if (number != null)
            SizedBox(
              width: 28,
              child: Text(
                '$number',
                style: AppTypography.subheadline.copyWith(fontSize: 15),
              ),
            ),
          ?leading,
          if (art != null) ArtSlot(art: art!),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.title3.copyWith(
                      fontWeight: FontWeight.w400,
                      fontSize: 20,
                    ),
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
          ),
          trailing ??
              const Icon(
                CupertinoIcons.chevron_right,
                size: 14,
                color: AppColors.textPrimary,
              ),
        ],
      ),
    );
  }
}

/// 44pt artwork used at the left of a list row.
class ArtSlot extends StatelessWidget {
  const ArtSlot({
    super.key,
    required this.art,
    this.size = 44,
    this.circular = false,
  });

  final String art;
  final double size;
  final bool circular;

  @override
  Widget build(BuildContext context) =>
      ArtImage(asset: art, size: size, radius: circular ? size / 2 : 4);
}
