import 'package:flutter/cupertino.dart';

import '../../core/data/catalog.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_dims.dart';
import '../../core/design/app_typography.dart';
import '../../core/models/media.dart';
import '../../core/state/app_scope.dart';
import '../../widgets/art_image.dart';
import '../../widgets/cards.dart';
import '../../widgets/page_chrome.dart';
import '../../widgets/rows.dart';
import '../library/collection_page.dart';

/// Radio artboard: now-playing rail, one large banner, then the station list.
class RadioPage extends StatelessWidget {
  const RadioPage({super.key, this.title = 'Radio'});

  final String title;

  @override
  Widget build(BuildContext context) {
    final List<Track> songs = Catalog.chart;
    return ColoredBox(
      color: AppColors.canvas,
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: LargeTitleHeader(
                title: title,
                backTitle: 'Back',
                showDivider: false,
              ),
            ),
            const SliverToBoxAdapter(
              child: SectionHeader(title: 'Now Playing'),
            ),
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
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppDims.gutter),
                child: SizedBox(
                  height: 200,
                  child: Stack(
                    fit: StackFit.expand,
                    children: <Widget>[
                      ArtImage(
                        asset: Catalog.categories.first.art,
                        radius: AppDims.radiusTile,
                      ),
                      const DecoratedBox(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: <Color>[
                              Color(0x00000000),
                              Color(0xCC000000),
                            ],
                          ),
                          borderRadius: BorderRadius.all(
                            Radius.circular(AppDims.radiusTile),
                          ),
                        ),
                      ),
                      Positioned(
                        left: 18,
                        bottom: 16,
                        child: Text('Dancing', style: AppTypography.title1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 24)),
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'List Song',
                onSeeAll: () => CollectionPage.push(context, Catalog.radio),
              ),
            ),
            SliverList.separated(
              itemCount: songs.length,
              separatorBuilder: (_, _) => const Hairline(),
              itemBuilder: (BuildContext context, int i) => TrackRow(
                title: songs[i].title,
                subtitle: songs[i].artist,
                leading: ArtSlot(
                  art: AppArt.artist(i),
                  size: 48,
                  circular: true,
                ),
                trailing: const Icon(
                  CupertinoIcons.ellipsis,
                  size: 18,
                  color: AppColors.accent,
                ),
                onTap: () => AppScope.of(context).play(songs, startAt: i),
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 16)),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                LinkRow(
                  title: 'Electronic/ Dance',
                  onTap: () => CollectionPage.push(context, Catalog.dancing),
                ),
                const Hairline(),
                const LinkRow(title: 'Top Charts'),
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
