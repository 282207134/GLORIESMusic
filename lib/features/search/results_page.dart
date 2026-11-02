import 'package:flutter/cupertino.dart';

import '../../core/data/catalog.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_dims.dart';
import '../../core/design/app_typography.dart';
import '../../core/models/media.dart';
import '../../core/state/app_scope.dart';
import '../../widgets/buttons.dart';
import '../../widgets/mini_player.dart';
import '../../widgets/rows.dart';

/// Search #3: filter pills over a mixed list of artist and album hits.
class ResultsPage extends StatefulWidget {
  const ResultsPage({super.key, this.query = 'justin'});

  final String query;

  @override
  State<ResultsPage> createState() => _ResultsPageState();
}

class _ResultsPageState extends State<ResultsPage> {
  static const List<String> _filters = <String>[
    'Top Results',
    'Artists',
    'Albums',
    'Songs',
    'Playlist',
  ];

  int _filter = 0;

  @override
  Widget build(BuildContext context) {
    final List<Track> results = Catalog.bieber;
    return ColoredBox(
      color: AppColors.canvas,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppDims.gutter,
                8,
                AppDims.gutter,
                12,
              ),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Row(
                        children: <Widget>[
                          const SizedBox(width: 10),
                          const Icon(
                            CupertinoIcons.search,
                            size: 15,
                            color: AppColors.textSecondary,
                          ),
                          Expanded(
                            child: Text(
                              widget.query,
                              style: AppTypography.body,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(right: 10),
                            child: Icon(
                              CupertinoIcons.clear_circled_solid,
                              size: 15,
                              color: AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  CupertinoButton(
                    padding: const EdgeInsets.only(left: 12),
                    minimumSize: const Size(0, 0),
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      'Cancel',
                      style: AppTypography.body.copyWith(
                        color: AppColors.accent,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            FilterPillBar(
              labels: _filters,
              selectedIndex: _filter,
              onSelected: (int i) => setState(() => _filter = i),
            ),
            const SizedBox(height: 8),
            const Hairline(),
            Expanded(
              child: ListView.separated(
                itemCount: results.length,
                separatorBuilder: (_, _) => const Hairline(),
                itemBuilder: (BuildContext context, int i) {
                  final bool artistRow = _filter == 0 && i == 0;
                  return TrackRow(
                    title: results[i].title,
                    subtitle: artistRow
                        ? 'Artist'
                        : _filter == 0
                        ? 'Album'
                        : _filters[_filter - 1],
                    leading: ArtSlot(
                      art: artistRow
                          ? Catalog.artists.first.art
                          : AppArt.album(i),
                      size: 60,
                      circular: artistRow,
                    ),
                    onTap: () => AppScope.of(context).play(results, startAt: i),
                  );
                },
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
