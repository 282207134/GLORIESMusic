import 'package:flutter/cupertino.dart';

import '../../core/data/catalog.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_dims.dart';
import '../../core/models/media.dart';
import '../../core/state/app_scope.dart';
import '../../widgets/app_sheet.dart';
import '../../widgets/cards.dart';
import '../../widgets/page_chrome.dart';
import '../../widgets/rows.dart';
import '../browse/albums_sheet.dart';
import '../library/collection_page.dart';

/// Home artboard: large title, three rails and a pair of genre links.
class HomePage extends StatelessWidget {
  const HomePage({super.key});

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
                title: 'Home',
                eyebrow: '12 Sat, June',
                showDivider: false,
              ),
            ),
            const SliverToBoxAdapter(child: SectionHeader(title: 'For You')),
            SliverToBoxAdapter(
              child: MediaRail(
                children: <Widget>[
                  for (final Collection c in Catalog.recentlyPlayed)
                    MediaCard(
                      title: c.title,
                      subtitle: c.subtitle,
                      art: c.art,
                      overline: 'Playlist Hot',
                      onTap: () => CollectionPage.push(context, c),
                    ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Recently Played',
                onSeeAll: () => AppSheet.show(context, const AlbumsSheet()),
              ),
            ),
            SliverToBoxAdapter(
              child: MediaRail(
                height: 270,
                children: <Widget>[
                  for (final Collection c in Catalog.recentlyPlayed.reversed)
                    MediaCard(
                      title: c.title,
                      subtitle: c.subtitle,
                      art: c.art,
                      width: 180,
                      onTap: () => CollectionPage.push(context, c),
                    ),
                ],
              ),
            ),
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'New Music',
                onSeeAll: () => _openAlbums(context),
              ),
            ),
            SliverList.separated(
              itemCount: Catalog.fresh.length,
              separatorBuilder: (_, _) => const Hairline(),
              itemBuilder: (BuildContext context, int i) {
                final Track t = Catalog.fresh[i];
                return TrackRow(
                  title: t.title,
                  subtitle: t.artist,
                  onTap: () =>
                      AppScope.of(context).play(Catalog.fresh, startAt: i),
                );
              },
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'New Music',
                onSeeAll: () => _openAlbums(context),
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
            const SliverToBoxAdapter(child: SizedBox(height: 8)),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                LinkRow(
                  title: 'Electronic/ Dance',
                  color: AppColors.accent,
                  onTap: () => CollectionPage.push(context, Catalog.dancing),
                ),
                const Hairline(),
                const LinkRow(title: 'Top Charts'),
                const Hairline(),
                const BottomBar(
                  insetsHome: false,
                  child: SizedBox(height: AppDims.rowHeight),
                ),
              ]),
            ),
          ],
        ),
      ),
    );
  }

  void _openAlbums(BuildContext context) =>
      AppSheet.show(context, const AlbumsSheet());
}
