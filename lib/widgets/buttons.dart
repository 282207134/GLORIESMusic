import 'package:flutter/cupertino.dart';

import '../core/design/app_colors.dart';
import '../core/design/app_dims.dart';
import '../core/design/app_typography.dart';

/// Full-width accent CTA — `Log In`, `Discovery Now`, `Scan`, `Log Out`.
class PrimaryButton extends StatelessWidget {
  const PrimaryButton({super.key, required this.label, this.onTap});

  final String label;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(0, 0),
      pressedOpacity: 0.75,
      onPressed: onTap,
      child: Container(
        height: 56,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(AppDims.radiusTile),
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          // The label sits on the accent fill, so it can not inherit the
          // theme's action colour.
          style: AppTypography.button.copyWith(color: AppColors.textPrimary),
        ),
      ),
    );
  }
}

/// Solid accent circle holding a glyph — the `…`, check and cloud buttons that
/// sit at the top-right of the detail screens.
class AccentIconButton extends StatelessWidget {
  const AccentIconButton({
    super.key,
    required this.icon,
    this.onTap,
    this.size = 44,
    this.color = AppColors.accent,
    this.foreground = AppColors.textPrimary,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final double size;
  final Color color;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(0, 0),
      pressedOpacity: 0.7,
      onPressed: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        child: SizedBox(
          width: size,
          height: size,
          child: Icon(icon, size: size * 0.42, color: foreground),
        ),
      ),
    );
  }
}

/// Grey `Play` / `Shuffle` action on the collection headers.
class FilledPillButton extends StatelessWidget {
  const FilledPillButton({
    super.key,
    required this.label,
    required this.icon,
    this.onTap,
  });

  final String label;
  final IconData icon;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(0, 0),
      pressedOpacity: 0.7,
      onPressed: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppDims.radiusTile),
        ),
        child: SizedBox(
          height: 56,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(icon, size: 18, color: AppColors.textPrimary),
              const SizedBox(width: 10),
              Flexible(
                child: Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.title3,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Genre selector: filled when picked, hairline outline when not.
class GenreChip extends StatelessWidget {
  const GenreChip({
    super.key,
    required this.label,
    required this.selected,
    this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(0, 0),
      pressedOpacity: 0.7,
      onPressed: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: selected ? AppColors.accent : CupertinoColors.transparent,
          border: Border.all(color: AppColors.accent),
          borderRadius: BorderRadius.circular(AppDims.radiusPill),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
          child: Text(label, style: AppTypography.title3),
        ),
      ),
    );
  }
}

/// Horizontally scrolling filter pills — Search #3's `Top Results / Artists / …`
class FilterPillBar extends StatelessWidget {
  const FilterPillBar({
    super.key,
    required this.labels,
    required this.selectedIndex,
    required this.onSelected,
  });

  final List<String> labels;
  final int selectedIndex;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: AppDims.gutter),
        itemCount: labels.length,
        separatorBuilder: (_, _) => const SizedBox(width: 22),
        itemBuilder: (BuildContext context, int i) {
          final bool active = i == selectedIndex;
          return CupertinoButton(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            minimumSize: const Size(0, 0),
            onPressed: () => onSelected(i),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: active ? AppColors.accent : CupertinoColors.transparent,
                borderRadius: BorderRadius.circular(AppDims.radiusPill),
              ),
              child: Center(
                child: Text(
                  labels[i],
                  style: AppTypography.title3.copyWith(
                    fontWeight: active ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
