import 'package:flutter/cupertino.dart';

import '../core/design/app_colors.dart';
import '../core/design/app_dims.dart';
import '../core/design/app_typography.dart';
import 'mini_player.dart';

/// Chrome shared by the four root tabs: page background, the mini player and
/// the tab bar. Detail screens pushed on top of a tab do not get this.
class AppShell extends StatelessWidget {
  const AppShell({
    super.key,
    required this.tabs,
    required this.currentIndex,
    required this.onTabChanged,
  });

  final List<Widget> tabs;
  final int currentIndex;
  final ValueChanged<int> onTabChanged;

  static const List<_Tab> _items = <_Tab>[
    _Tab('Home', CupertinoIcons.home),
    _Tab('Browse', CupertinoIcons.square_grid_2x2),
    _Tab('Search', CupertinoIcons.search),
    _Tab('User', CupertinoIcons.music_note),
  ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.canvas,
      child: Column(
        children: <Widget>[
          Expanded(
            child: IndexedStack(index: currentIndex, children: tabs),
          ),
          const MiniPlayer(),
          _TabBar(
            items: _items,
            currentIndex: currentIndex,
            onTap: onTabChanged,
          ),
          const SizedBox(height: AppDims.homeIndicatorHeight),
        ],
      ),
    );
  }
}

class _Tab {
  const _Tab(this.label, this.icon);

  final String label;
  final IconData icon;
}

class _TabBar extends StatelessWidget {
  const _TabBar({
    required this.items,
    required this.currentIndex,
    required this.onTap,
  });

  final List<_Tab> items;
  final int currentIndex;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.canvasDeep,
        border: Border(top: BorderSide(color: AppColors.separator, width: 0.5)),
      ),
      child: SizedBox(
        height: AppDims.tabBarHeight,
        child: Row(
          children: <Widget>[
            for (int i = 0; i < items.length; i++)
              Expanded(
                child: CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  onPressed: () => onTap(i),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Icon(
                        items[i].icon,
                        size: 22,
                        color: i == currentIndex
                            ? AppColors.accent
                            : AppColors.textSecondary,
                      ),
                      const SizedBox(height: 3),
                      Text(
                        items[i].label,
                        style: AppTypography.caption.copyWith(
                          fontSize: 10,
                          color: i == currentIndex
                              ? AppColors.accent
                              : AppColors.textSecondary,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
