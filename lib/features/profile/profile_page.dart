import 'package:flutter/cupertino.dart';

import '../../core/data/catalog.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_dims.dart';
import '../../core/design/app_typography.dart';
import '../../core/models/media.dart';
import '../../widgets/app_sheet.dart';
import '../../widgets/buttons.dart';
import '../../widgets/cards.dart';
import '../../widgets/page_chrome.dart';
import '../../widgets/rows.dart';
import '../browse/albums_sheet.dart';
import '../library/collection_page.dart';
import '../library/library_page.dart';
import 'settings_page.dart';

/// Profile artboard: identity block, stat row, then the two rails.
class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.canvas,
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppDims.gutter,
                  vertical: 8,
                ),
                child: const BackLabel(title: 'Home'),
              ),
            ),
            SliverToBoxAdapter(
              child: Column(
                children: <Widget>[
                  const SizedBox(height: 24),
                  Text(Catalog.userName, style: AppTypography.title1),
                  const SizedBox(height: 4),
                  Text(Catalog.userCity, style: AppTypography.subheadline),
                  const SizedBox(height: 22),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppDims.gutter,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        CupertinoButton(
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          onPressed: () {},
                          child: DecoratedBox(
                            decoration: BoxDecoration(
                              color: AppColors.accent,
                              borderRadius: BorderRadius.circular(
                                AppDims.radiusPill,
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 26,
                                vertical: 14,
                              ),
                              child: Text(
                                'FIND FRIENDS',
                                style: AppTypography.footnote.copyWith(
                                  color: AppColors.textPrimary,
                                  fontWeight: FontWeight.w700,
                                  letterSpacing: 0.4,
                                ),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 18),
                        const AccentIconButton(icon: CupertinoIcons.ellipsis),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),
                ],
              ),
            ),
            const SliverToBoxAdapter(child: Hairline()),
            const SliverToBoxAdapter(child: _StatsRow()),
            const SliverToBoxAdapter(child: Hairline()),
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Playlist',
                prominent: true,
                onSeeAll: () => CollectionPage.push(context, Catalog.playlist),
              ),
            ),
            SliverToBoxAdapter(
              child: MediaRail(
                height: 190,
                children: <Widget>[
                  for (final Category c in Catalog.categories)
                    SizedBox(width: 160, child: CategoryTile(category: c)),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Recently Played',
                prominent: true,
                onSeeAll: () => AppSheet.show(context, const AlbumsSheet()),
              ),
            ),
            SliverToBoxAdapter(
              child: MediaRail(
                children: <Widget>[
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
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                const Hairline(),
                LinkRow(
                  title: 'Electronic/ Dance',
                  onTap: () => CollectionPage.push(context, Catalog.dancing),
                ),
                const Hairline(),
                const LinkRow(title: 'Top Charts'),
                const Hairline(),
                LinkRow(
                  title: 'My Library',
                  onTap: () => Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (_) => const LibraryPage(),
                    ),
                  ),
                ),
                const Hairline(),
                LinkRow(
                  title: 'Setting',
                  onTap: () => Navigator.of(context).push(
                    CupertinoPageRoute<void>(
                      builder: (_) => const SettingsPage(),
                    ),
                  ),
                ),
                const Hairline(),
                const SizedBox(height: AppDims.rowHeight),
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow();

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(
      horizontal: AppDims.gutter,
      vertical: 18,
    ),
    child: Row(
      children: <Widget>[
        for (final (String top, String bottom) in Catalog.userStats)
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(top, style: AppTypography.title3),
                Text(bottom, style: AppTypography.subheadline),
              ],
            ),
          ),
      ],
    ),
  );
}
