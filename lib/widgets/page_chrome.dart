import 'package:flutter/cupertino.dart';

import '../core/design/app_colors.dart';
import '../core/design/app_dims.dart';
import '../core/design/app_typography.dart';
import 'rows.dart';

/// Accent `< Back` label used at the top of every pushed screen.
class BackLabel extends StatelessWidget {
  const BackLabel({super.key, this.title = 'Back', this.onTap});

  final String title;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: const EdgeInsets.symmetric(vertical: 8),
      minimumSize: const Size(0, 0),
      onPressed: onTap ?? () => Navigator.of(context).maybePop(),
      child: Row(
        // Max, so the label hugs the left edge of the slot it is given rather
        // than sitting in the middle of it.
        mainAxisSize: MainAxisSize.max,
        children: <Widget>[
          const Icon(
            CupertinoIcons.chevron_left,
            size: 18,
            color: AppColors.accent,
          ),
          const SizedBox(width: 4),
          Text(
            title,
            style: AppTypography.body.copyWith(color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}

/// iOS large-title header: optional trailing actions, eyebrow, then the 34pt
/// title, closed with a hairline.
class LargeTitleHeader extends StatelessWidget {
  const LargeTitleHeader({
    super.key,
    required this.title,
    this.eyebrow,
    this.backTitle,
    this.actions,
    this.showDivider = true,
  });

  final String title;
  final String? eyebrow;
  final String? backTitle;
  final List<Widget>? actions;
  final bool showDivider;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        if (backTitle != null)
          Padding(
            padding: const EdgeInsets.only(right: AppDims.gutter),
            child: Row(
              children: <Widget>[
                BackLabel(title: backTitle!),
                const Spacer(),
                ...?actions,
              ],
            ),
          )
        else if (actions != null)
          Padding(
            padding: const EdgeInsets.only(right: AppDims.gutter),
            child: Row(children: <Widget>[const Spacer(), ...actions!]),
          ),
        if (eyebrow != null) ...<Widget>[
          const SizedBox(height: 18),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDims.gutter),
            child: Text(eyebrow!.toUpperCase(), style: AppTypography.overline),
          ),
        ],
        const SizedBox(height: 2),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDims.gutter),
          child: Text(title, style: AppTypography.largeTitle),
        ),
        const SizedBox(height: 14),
        if (showDivider) const Hairline(),
      ],
    );
  }
}

/// Centered-title nav bar with a leading back label — Setting #2.
class NavBar extends StatelessWidget {
  const NavBar({super.key, required this.title, this.backTitle = 'Back'});

  final String title;
  final String backTitle;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          Positioned(
            left: AppDims.gutter,
            child: BackLabel(title: backTitle),
          ),
          Text(title, style: AppTypography.headline),
        ],
      ),
    );
  }
}

/// Bottom-anchored action area that respects the home-indicator inset.
class BottomBar extends StatelessWidget {
  const BottomBar({super.key, required this.child, this.insetsHome = true});

  final Widget child;
  final bool insetsHome;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        AppDims.gutter,
        12,
        AppDims.gutter,
        insetsHome ? MediaQuery.of(context).padding.bottom + 12 : 12,
      ),
      child: child,
    );
  }
}

/// The small pill at the top of every modal sheet in the design.
class Grabber extends StatelessWidget {
  const Grabber({super.key});

  @override
  Widget build(BuildContext context) => Center(
    child: Container(
      width: 36,
      height: 5,
      margin: const EdgeInsets.symmetric(vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surfaceHigh,
        borderRadius: BorderRadius.circular(AppDims.radiusPill),
      ),
    ),
  );
}
