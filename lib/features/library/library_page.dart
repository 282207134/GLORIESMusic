import 'package:flutter/cupertino.dart';

import '../../core/data/catalog.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_dims.dart';
import '../../core/design/app_typography.dart';
import '../../core/models/media.dart';
import '../../widgets/cards.dart';
import '../../widgets/page_chrome.dart';
import '../../widgets/rows.dart';
import 'collection_page.dart';

/// Your Library artboard: four accent shortcuts over a "Recently Added" rail.
class LibraryPage extends StatelessWidget {
  const LibraryPage({super.key});

  static const List<(String, CollectionKind)> _shortcuts =
      <(String, CollectionKind)>[
        ('Your Daily Mix', CollectionKind.dailyMix),
        ('Playlist', CollectionKind.playlist),
        ('Songs', CollectionKind.album),
        ('Artist', CollectionKind.radio),
      ];

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.canvas,
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: LargeTitleHeader(
                title: 'My Library',
                backTitle: 'Back',
                actions: <Widget>[
                  CupertinoButton(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    onPressed: () {},
                    child: Text(
                      'Edit',
                      style: AppTypography.body.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppDims.gutter,
                24,
                AppDims.gutter,
                8,
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 164 / 64,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int i) => _Shortcut(
                    label: _shortcuts[i].$1,
                    onTap: () => CollectionPage.push(
                      context,
                      _collectionFor(_shortcuts[i].$2),
                    ),
                  ),
                  childCount: _shortcuts.length,
                ),
              ),
            ),
            const SliverToBoxAdapter(
              child: SectionHeader(title: 'Recently Added'),
            ),
            SliverToBoxAdapter(
              child: MediaRail(
                children: <Widget>[
                  for (final Collection c in Catalog.recentlyPlayed)
                    MediaCard(
                      title: c.title,
                      subtitle: c.subtitle,
                      art: c.art,
                      onTap: () => CollectionPage.push(context, c),
                    ),
                  for (final Collection c in Catalog.newReleases)
                    MediaCard(
                      title: c.title,
                      subtitle: c.subtitle,
                      art: c.art,
                      onTap: () => CollectionPage.push(context, c),
                    ),
                ],
              ),
            ),
            const SliverToBoxAdapter(
              child: SizedBox(height: AppDims.rowHeight),
            ),
          ],
        ),
      ),
    );
  }

  static Collection _collectionFor(CollectionKind kind) => switch (kind) {
    CollectionKind.dailyMix => Catalog.dailyMix,
    CollectionKind.playlist => Catalog.playlist,
    CollectionKind.album => Catalog.newReleases.first,
    CollectionKind.radio => Catalog.radio,
  };
}

class _Shortcut extends StatelessWidget {
  const _Shortcut({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      minimumSize: const Size(0, 0),
      pressedOpacity: 0.75,
      onPressed: onTap,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.accent,
          borderRadius: BorderRadius.circular(AppDims.radiusTile),
        ),
        child: SizedBox(
          height: 64,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    label,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.headline,
                  ),
                ),
                const Icon(CupertinoIcons.chevron_right, size: 14),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
