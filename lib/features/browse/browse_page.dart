import 'package:flutter/cupertino.dart';

import '../../core/data/catalog.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_dims.dart';
import '../../core/models/media.dart';
import '../../widgets/cards.dart';
import '../../widgets/page_chrome.dart';
import '../../widgets/rows.dart';
import '../library/collection_page.dart';
import 'radio_page.dart';

/// Browse artboard: three accent link rows, a release rail and the genre grid.
class BrowsePage extends StatelessWidget {
  const BrowsePage({super.key});

  @override
  Widget build(BuildContext context) {
    final bool canPop = Navigator.of(context).canPop();
    return ColoredBox(
      color: AppColors.canvas,
      child: SafeArea(
        bottom: false,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverToBoxAdapter(
              child: LargeTitleHeader(
                title: 'Browse',
                backTitle: canPop ? 'Back' : null,
                showDivider: false,
              ),
            ),
            SliverList(
              delegate: SliverChildListDelegate(<Widget>[
                LinkRow(
                  title: 'Charts',
                  color: AppColors.accent,
                  onTap: () => CollectionPage.push(context, Catalog.dancing),
                ),
                const Hairline(),
                LinkRow(
                  title: 'New Releases',
                  color: AppColors.accent,
                  onTap: () =>
                      CollectionPage.push(context, Catalog.newReleases.first),
                ),
                const Hairline(),
                const LinkRow(title: 'Postcasts', color: AppColors.accent),
                const Hairline(),
              ]),
            ),
            SliverToBoxAdapter(
              child: SectionHeader(
                title: 'Chill Out Tonight',
                onSeeAll: () => CollectionPage.push(context, Catalog.playlist),
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
            const SliverToBoxAdapter(
              child: SectionHeader(title: 'Genres & Moods'),
            ),
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(
                AppDims.gutter,
                16,
                AppDims.gutter,
                24,
              ),
              sliver: SliverGrid(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 16,
                  crossAxisSpacing: 16,
                  childAspectRatio: 166 / 120,
                ),
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int i) => CategoryTile(
                    category: Catalog.categories[i],
                    onTap: () => Navigator.of(context).push(
                      CupertinoPageRoute<void>(
                        builder: (_) =>
                            RadioPage(title: Catalog.categories[i].title),
                      ),
                    ),
                  ),
                  childCount: Catalog.categories.length,
                ),
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
}
