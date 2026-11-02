import 'package:flutter/cupertino.dart';

import '../../core/data/catalog.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_dims.dart';
import '../../core/design/app_typography.dart';
import '../../core/models/media.dart';
import '../../core/state/app_scope.dart';
import '../../core/state/app_store.dart';
import '../../widgets/art_image.dart';
import '../../widgets/buttons.dart';
import '../../widgets/mini_player.dart';
import '../../widgets/page_chrome.dart';
import '../../widgets/rows.dart';

/// One detail screen for every track list in the design — Daily Mix, Playlist,
/// Radio and the album reached from Search all share this layout.
class CollectionPage extends StatelessWidget {
  const CollectionPage({super.key, required this.collection});

  final Collection collection;

  static Future<void> push(BuildContext context, Collection c) =>
      Navigator.of(context).push(
        CupertinoPageRoute<void>(builder: (_) => CollectionPage(collection: c)),
      );

  @override
  Widget build(BuildContext context) {
    final AppStore store = AppScope.of(context);
    final List<Track> tracks = collection.tracks.isEmpty
        ? Catalog.mix
        : collection.tracks;
    final bool numbered = collection.kind == CollectionKind.dailyMix;
    final bool downloadable = collection.kind == CollectionKind.playlist;

    return ColoredBox(
      color: AppColors.canvas,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDims.gutter,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: BackLabel(title: collection.backLabel),
                          ),
                          AccentIconButton(
                            icon: collection.downloadableIcon,
                            onTap: () {},
                          ),
                          const SizedBox(width: 12),
                          const AccentIconButton(icon: CupertinoIcons.ellipsis),
                        ],
                      ),
                    ),
                  ),
                  SliverFillRemaining(
                    hasScrollBody: false,
                    child: Column(
                      children: <Widget>[
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(AppDims.gutter),
                            child: ArtImage(
                              asset: collection.art,
                              radius: AppDims.radiusCard,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppDims.gutter,
                          ),
                          child: Column(
                            children: <Widget>[
                              Text(
                                collection.title,
                                style: AppTypography.title2,
                              ),
                              const SizedBox(height: 6),
                              Text(
                                collection.subtitle,
                                textAlign: TextAlign.center,
                                style: AppTypography.title3.copyWith(
                                  fontWeight: FontWeight.w400,
                                  color: AppColors.accent,
                                ),
                              ),
                              const SizedBox(height: 22),
                              Row(
                                children: <Widget>[
                                  Expanded(
                                    child: FilledPillButton(
                                      label: 'Play',
                                      icon: CupertinoIcons.play_arrow_solid,
                                      onTap: () =>
                                          store.play(tracks, startAt: 0),
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: FilledPillButton(
                                      label: 'Shuffle',
                                      icon: CupertinoIcons.shuffle,
                                      onTap: store.toggleShuffle,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 22),
                            ],
                          ),
                        ),
                        const Hairline(),
                        if (numbered) ...<Widget>[
                          // The Daily Mix artboard repeats the mix name under a
                          // pink `…` before the numbered list.
                          Padding(
                            padding: const EdgeInsets.fromLTRB(
                              AppDims.gutter,
                              14,
                              AppDims.gutter,
                              14,
                            ),
                            child: Row(
                              children: <Widget>[
                                const Icon(
                                  CupertinoIcons.ellipsis,
                                  color: AppColors.accent,
                                  size: 20,
                                ),
                                const SizedBox(width: 12),
                                Text(
                                  collection.title,
                                  style: AppTypography.title3,
                                ),
                              ],
                            ),
                          ),
                          const Hairline(),
                        ],
                        for (int i = 0; i < tracks.length; i++) ...<Widget>[
                          TrackRow(
                            title: tracks[i].title,
                            subtitle: tracks[i].artist,
                            number: numbered ? i + 1 : null,
                            trailing: downloadable
                                ? const Icon(
                                    CupertinoIcons.cloud_download,
                                    color: AppColors.accent,
                                    size: 20,
                                  )
                                : null,
                            onTap: () => store.play(tracks, startAt: i),
                          ),
                          if (i != tracks.length - 1) const Hairline(),
                        ],
                        const SizedBox(height: AppDims.miniPlayerHeight),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const MiniPlayer(),
            const SizedBox(height: AppDims.homeIndicatorHeight),
          ],
        ),
      ),
    );
  }
}

extension on Collection {
  /// The design swaps the top-right action per kind: a check on Daily Mix, a
  /// download cloud on Playlist.
  IconData get downloadableIcon => switch (kind) {
    CollectionKind.dailyMix => CupertinoIcons.checkmark_alt,
    CollectionKind.playlist => CupertinoIcons.cloud_download,
    CollectionKind.radio => CupertinoIcons.heart,
    CollectionKind.album => CupertinoIcons.plus,
  };
}
