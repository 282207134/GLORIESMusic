import 'package:flutter/cupertino.dart';

import '../core/design/app_colors.dart';
import '../core/design/app_dims.dart';
import '../core/design/app_typography.dart';
import '../core/state/app_scope.dart';
import '../core/state/app_store.dart';
import '../features/player/now_playing_page.dart';
import 'art_image.dart';

/// Persistent "now playing" strip above the tab bar. Present on every tab;
/// tapping it opens the full-screen player.
class MiniPlayer extends StatelessWidget {
  const MiniPlayer({super.key});

  static Future<void> open(BuildContext context) => Navigator.of(context).push(
    CupertinoPageRoute<void>(
      builder: (_) => const NowPlayingPage(),
      fullscreenDialog: true,
    ),
  );

  @override
  Widget build(BuildContext context) {
    final AppStore store = AppScope.of(context);

    return DecoratedBox(
      decoration: const BoxDecoration(
        color: AppColors.canvasDeep,
        border: Border(top: BorderSide(color: AppColors.separator, width: 0.5)),
      ),
      child: SizedBox(
        height: AppDims.miniPlayerHeight,
        child: Row(
          children: <Widget>[
            Expanded(
              child: CupertinoButton(
                padding: const EdgeInsets.only(left: AppDims.gutter),
                minimumSize: const Size(0, 0),
                onPressed: () => open(context),
                child: Row(
                  children: <Widget>[
                    ArtImage(
                      asset: store.currentTrack.art,
                      size: 40,
                      radius: 4,
                    ),
                    const SizedBox(width: 12),
                    Flexible(
                      child: Text(
                        store.currentTrack.title,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.headline,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            CupertinoButton(
              padding: const EdgeInsets.symmetric(horizontal: 14),
              minimumSize: const Size(0, 0),
              onPressed: store.togglePlay,
              child: Icon(
                store.isPlaying
                    ? CupertinoIcons.pause_fill
                    : CupertinoIcons.play_arrow_solid,
                size: 26,
                color: AppColors.textPrimary,
              ),
            ),
            CupertinoButton(
              padding: const EdgeInsets.only(right: AppDims.gutter + 6),
              minimumSize: const Size(0, 0),
              onPressed: () => store.skip(1),
              child: const Icon(
                CupertinoIcons.forward_fill,
                size: 24,
                color: AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
