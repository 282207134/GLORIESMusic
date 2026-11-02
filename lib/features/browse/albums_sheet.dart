import 'package:flutter/cupertino.dart';

import '../../core/data/catalog.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_dims.dart';
import '../../core/design/app_typography.dart';
import '../../core/models/media.dart';
import '../../core/state/app_scope.dart';
import '../../widgets/app_sheet.dart';
import '../../widgets/rows.dart';

/// Albums artboard: sheet with a search field and an A–Z index rail.
class AlbumsSheet extends StatefulWidget {
  const AlbumsSheet({super.key});

  @override
  State<AlbumsSheet> createState() => _AlbumsSheetState();
}

class _AlbumsSheetState extends State<AlbumsSheet> {
  static const List<String> _letters = <String>[
    '#',
    'A',
    'B',
    'C',
    'D',
    'E',
    'F',
    'G',
    'H',
    'I',
    'J',
    'K',
    'L',
    'M',
    'N',
    'O',
    'P',
    'Q',
    'R',
    'S',
    'T',
    'U',
    'V',
    'W',
    'X',
    'Y',
    'Z',
  ];

  final ScrollController _scroll = ScrollController();

  @override
  void dispose() {
    _scroll.dispose();
    super.dispose();
  }

  List<Track> get _all => <Track>[...Catalog.fresh, ...Catalog.chart];

  void _jumpTo(String letter) {
    final int index = _all.indexWhere(
      (Track t) => t.title[0].toUpperCase() == letter,
    );
    if (index < 0 || !_scroll.hasClients) return;
    _scroll.animateTo(
      (index * 72).toDouble().clamp(0.0, _scroll.position.maxScrollExtent),
      duration: const Duration(milliseconds: 220),
      curve: Curves.easeOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    final List<Track> tracks = _all;
    return AppSheet(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(AppDims.gutter, 18, AppDims.gutter, 0),
            child: Text('Albums', style: AppTypography.largeTitle),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDims.gutter),
            child: const _SearchField(),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Row(
              children: <Widget>[
                Expanded(
                  child: ListView.separated(
                    controller: _scroll,
                    padding: const EdgeInsets.only(top: 8, bottom: 24),
                    itemCount: tracks.length,
                    separatorBuilder: (_, _) => const Hairline(),
                    itemBuilder: (BuildContext context, int i) => TrackRow(
                      title: tracks[i].title,
                      subtitle: tracks[i].artist,
                      onTap: () =>
                          AppScope.of(context).play(tracks, startAt: i),
                    ),
                  ),
                ),
                _IndexBar(letters: _letters, onSelect: _jumpTo),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchField extends StatelessWidget {
  const _SearchField();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
      ),
      child: const SizedBox(
        height: 40,
        child: Row(
          children: <Widget>[
            SizedBox(width: 10),
            Icon(
              CupertinoIcons.search,
              size: 15,
              color: AppColors.textSecondary,
            ),
            SizedBox(width: 8),
            Text('Search', style: AppTypography.body),
            Spacer(),
            Padding(
              padding: EdgeInsets.only(right: 12),
              child: Icon(
                CupertinoIcons.mic,
                size: 16,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IndexBar extends StatelessWidget {
  const _IndexBar({required this.letters, required this.onSelect});

  final List<String> letters;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          for (final String letter in letters)
            CupertinoButton(
              padding: const EdgeInsets.symmetric(vertical: 1),
              minimumSize: const Size(0, 0),
              onPressed: () => onSelect(letter),
              child: Text(
                letter,
                style: AppTypography.caption.copyWith(
                  fontSize: 10,
                  color: AppColors.accent,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
