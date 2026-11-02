import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;

import '../../core/data/catalog.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_dims.dart';
import '../../core/design/app_typography.dart';
import '../../core/models/media.dart';
import '../../core/state/app_scope.dart';
import '../../core/state/app_store.dart';
import '../../widgets/app_sheet.dart';
import '../../widgets/art_image.dart';
import '../../widgets/player_controls.dart';
import '../../widgets/rows.dart';

/// Now Playing #1–#5. The five artboards are one screen in three states
/// (cover / lyrics / queue) plus its overflow sheet, so they live here.
class NowPlayingPage extends StatefulWidget {
  const NowPlayingPage({super.key});

  @override
  State<NowPlayingPage> createState() => _NowPlayingPageState();
}

class _NowPlayingPageState extends State<NowPlayingPage> {
  PlayerTab? _tab;

  @override
  Widget build(BuildContext context) {
    final AppStore store = AppScope.of(context);
    final Track track = store.currentTrack;
    final bool immersive = _tab != null;

    return AppSheet(
      gradient: immersive,
      child: Column(
        children: <Widget>[
          if (immersive)
            PlayerHeader(
              title: track.title,
              artist: track.artist,
              centered: true,
              moreColor: AppColors.surfaceHigh,
              artistColor: _tab == PlayerTab.lyrics
                  ? AppColors.accent
                  : AppColors.textSecondary,
              onMore: () => _showActions(context, track),
            )
          else
            const SizedBox(height: 8),
          Expanded(child: _body(store, track)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppDims.gutter),
            child: Column(
              children: <Widget>[
                if (!immersive)
                  PlayerHeader(
                    title: track.title,
                    artist: track.artist,
                    grabber: false,
                    onMore: () => _showActions(context, track),
                  ),
                const SeekBar(),
                const TransportRow(),
                const SizedBox(height: 8),
                const Hairline(indent: 0),
                const SizedBox(height: 8),
                const VolumeBar(),
                PlayerTabRow(
                  selected: _tab,
                  onSelected: (PlayerTab t) =>
                      setState(() => _tab = _tab == t ? null : t),
                ),
                const SizedBox(height: AppDims.homeIndicatorHeight),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _body(AppStore store, Track track) => switch (_tab) {
    null => Padding(
      padding: const EdgeInsets.all(AppDims.gutter),
      child: Align(
        alignment: Alignment.topCenter,
        child: AspectRatio(
          aspectRatio: 1,
          child: ArtImage(asset: track.art, radius: AppDims.radiusCard),
        ),
      ),
    ),
    PlayerTab.lyrics => _Lyrics(store: store),
    PlayerTab.airplay => const _Airplay(),
    PlayerTab.queue => _Queue(store: store),
  };

  void _showActions(BuildContext context, Track track) =>
      showCupertinoModalPopup<void>(
        context: context,
        builder: (_) => TrackActionsSheet(track: track),
      );
}

/// Now Playing #3 — the active line is bright, the rest fade back.
class _Lyrics extends StatelessWidget {
  const _Lyrics({required this.store});

  final AppStore store;

  @override
  Widget build(BuildContext context) {
    final int active = (store.progress * Catalog.lyrics.length).floor();
    return ListView(
      padding: const EdgeInsets.symmetric(
        horizontal: AppDims.gutter,
        vertical: 32,
      ),
      children: <Widget>[
        for (int i = 0; i < Catalog.lyrics.length; i++)
          Padding(
            padding: const EdgeInsets.only(bottom: 26),
            child: Text(
              Catalog.lyrics[i],
              style: AppTypography.title1.copyWith(
                color: Color.lerp(
                  AppColors.textTertiary,
                  AppColors.textPrimary,
                  i <= active ? 1 : 0,
                ),
              ),
            ),
          ),
      ],
    );
  }
}

/// Now Playing #4 — the upcoming queue with shuffle / repeat toggles.
class _Queue extends StatelessWidget {
  const _Queue({required this.store});

  final AppStore store;

  @override
  Widget build(BuildContext context) {
    final List<Track> queue = store.queue;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppDims.gutter,
            24,
            AppDims.gutter,
            0,
          ),
          child: Row(
            children: <Widget>[
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Playing Next', style: AppTypography.title2),
                    Text(
                      'Autoplaying similar music',
                      style: AppTypography.subheadline,
                    ),
                  ],
                ),
              ),
              _ToggleIcon(
                icon: CupertinoIcons.shuffle,
                active: store.isShuffle,
                onTap: store.toggleShuffle,
              ),
              const SizedBox(width: 14),
              _ToggleIcon(
                icon: CupertinoIcons.repeat,
                active: store.isRepeat,
                onTap: store.toggleRepeat,
              ),
            ],
          ),
        ),
        const SizedBox(height: 18),
        Expanded(
          child: ListView.separated(
            padding: const EdgeInsets.only(bottom: 24),
            itemCount: queue.length,
            separatorBuilder: (_, _) => const Hairline(),
            itemBuilder: (BuildContext context, int i) {
              final bool played = i < store.queue.indexOf(store.currentTrack);
              return Opacity(
                opacity: played ? 0.35 : 1,
                child: TrackRow(
                  title: queue[i].title,
                  subtitle: queue[i].artist,
                  trailing: const Icon(
                    CupertinoIcons.list_bullet,
                    color: AppColors.accent,
                    size: 20,
                  ),
                  onTap: () => store.play(queue, startAt: i),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

/// Shuffle / repeat switch — accent when on, grey when off.
class _ToggleIcon extends StatelessWidget {
  const _ToggleIcon({
    required this.icon,
    required this.active,
    required this.onTap,
  });

  final IconData icon;
  final bool active;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => CupertinoButton(
    padding: EdgeInsets.zero,
    minimumSize: const Size(0, 0),
    onPressed: onTap,
    child: Icon(
      icon,
      size: 22,
      color: active ? AppColors.accent : AppColors.textSecondary,
    ),
  );
}

class _Airplay extends StatelessWidget {
  const _Airplay();

  @override
  Widget build(BuildContext context) => const Center(
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Icon(Icons.airplay, size: 72),
        SizedBox(height: 16),
        Text('No devices nearby', style: AppTypography.subheadline),
      ],
    ),
  );
}

/// Now Playing #5 — the iOS action sheet behind the `…` button.
class TrackActionsSheet extends StatelessWidget {
  const TrackActionsSheet({super.key, required this.track});

  final Track track;

  static const List<(String, IconData)> _actions = <(String, IconData)>[
    ('Save', CupertinoIcons.add),
    ('Add To Playlist', CupertinoIcons.bag),
    ('Share', CupertinoIcons.share),
    ('Go to Album', CupertinoIcons.list_bullet),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDims.radiusSheet),
          ),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: AppColors.playerGradient,
              ),
            ),
            child: PlayerHeader(
              title: track.title,
              artist: track.artist,
              grabber: false,
              onClose: () => Navigator.of(context).pop(),
            ),
          ),
        ),
        const Hairline(indent: 0),
        Padding(
          padding: const EdgeInsets.all(AppDims.gutter),
          child: Column(
            children: <Widget>[
              DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(AppDims.radiusTile),
                ),
                child: Column(
                  children: <Widget>[
                    for (int i = 0; i < _actions.length; i++) ...<Widget>[
                      _ActionRow(label: _actions[i].$1, icon: _actions[i].$2),
                      if (i != _actions.length - 1)
                        const Hairline(indent: AppDims.gutter + 8),
                    ],
                  ],
                ),
              ),
              const SizedBox(height: 12),
              const DecoratedBox(
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.all(
                    Radius.circular(AppDims.radiusTile),
                  ),
                ),
                child: _CancelRow(),
              ),
            ],
          ),
        ),
        const SizedBox(height: AppDims.homeIndicatorHeight),
      ],
    );
  }
}

class _ActionRow extends StatelessWidget {
  const _ActionRow({required this.label, required this.icon});

  final String label;
  final IconData icon;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 60,
    child: Row(
      children: <Widget>[
        const SizedBox(width: AppDims.gutter + 8),
        Expanded(
          child: Text(
            label,
            style: AppTypography.title3.copyWith(fontWeight: FontWeight.w400),
          ),
        ),
        Icon(icon, size: 22, color: AppColors.textPrimary),
        const SizedBox(width: AppDims.gutter + 8),
      ],
    ),
  );
}

class _CancelRow extends StatelessWidget {
  const _CancelRow();

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 56,
    child: Center(
      child: Text(
        'Cancel',
        style: AppTypography.button.copyWith(color: AppColors.accent),
      ),
    ),
  );
}
