import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;

import '../core/design/app_colors.dart';
import '../core/design/app_dims.dart';
import '../core/design/app_typography.dart';
import '../core/state/app_scope.dart';
import '../core/state/app_store.dart';
import 'page_chrome.dart';

/// Thin track with a round thumb, matching the scrubber drawn on the artboards.
/// Cupertino has no slider with this geometry, so it is painted directly.
class AppSlider extends StatelessWidget {
  const AppSlider({
    super.key,
    required this.value,
    required this.onChanged,
    this.thumbRadius = 6,
  });

  /// 0..1 position of the thumb.
  final double value;
  final ValueChanged<double> onChanged;
  final double thumbRadius;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final double width = constraints.maxWidth;
        void report(double x) => onChanged((x / width).clamp(0.0, 1.0));
        return GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTapDown: (TapDownDetails d) => report(d.localPosition.dx),
          onHorizontalDragDown: (DragDownDetails d) =>
              report(d.localPosition.dx),
          onHorizontalDragUpdate: (DragUpdateDetails d) =>
              report(d.localPosition.dx),
          child: SizedBox(
            height: thumbRadius * 3,
            child: CustomPaint(
              painter: _SliderPainter(value: value, thumbRadius: thumbRadius),
            ),
          ),
        );
      },
    );
  }
}

class _SliderPainter extends CustomPainter {
  const _SliderPainter({required this.value, required this.thumbRadius});

  final double value;
  final double thumbRadius;

  @override
  void paint(Canvas canvas, Size size) {
    final double midY = size.height / 2;
    final double thumbX = size.width * value;
    canvas.drawLine(
      Offset(0, midY),
      Offset(size.width, midY),
      Paint()
        ..color = AppColors.surfaceHigh
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawLine(
      Offset(0, midY),
      Offset(thumbX, midY),
      Paint()
        ..color = AppColors.textPrimary
        ..strokeWidth = 3
        ..strokeCap = StrokeCap.round,
    );
    canvas.drawCircle(
      Offset(thumbX, midY),
      thumbRadius,
      Paint()..color = AppColors.textPrimary,
    );
  }

  @override
  bool shouldRepaint(_SliderPainter old) =>
      old.value != value || old.thumbRadius != thumbRadius;
}

/// Scrubber plus the `0:06 / -2:59` readout underneath it.
class SeekBar extends StatelessWidget {
  const SeekBar({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStore store = AppScope.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        AppSlider(value: store.progress, onChanged: store.seek),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                store.positionLabel,
                style: AppTypography.footnote.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                ),
              ),
              Text(
                store.remainingLabel,
                style: AppTypography.footnote.copyWith(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// Prev / play-pause / next.
class TransportRow extends StatelessWidget {
  const TransportRow({super.key, this.size = 44});

  final double size;

  @override
  Widget build(BuildContext context) {
    final AppStore store = AppScope.of(context);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _Transport(CupertinoIcons.backward_fill, () => store.skip(-1), size),
        _Transport(
          store.isPlaying
              ? CupertinoIcons.pause_fill
              : CupertinoIcons.play_arrow_solid,
          store.togglePlay,
          size * 1.25,
        ),
        _Transport(CupertinoIcons.forward_fill, () => store.skip(1), size),
      ],
    );
  }
}

class _Transport extends StatelessWidget {
  const _Transport(this.icon, this.onTap, this.size);

  final IconData icon;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) => CupertinoButton(
    padding: const EdgeInsets.all(10),
    minimumSize: const Size(0, 0),
    onPressed: onTap,
    child: Icon(icon, size: size, color: AppColors.textPrimary),
  );
}

/// Volume rail flanked by the two speaker glyphs.
class VolumeBar extends StatelessWidget {
  const VolumeBar({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStore store = AppScope.of(context);
    return Row(
      children: <Widget>[
        const Icon(
          CupertinoIcons.speaker_slash_fill,
          size: 14,
          color: AppColors.textSecondary,
        ),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: AppSlider(
              value: store.volume,
              thumbRadius: 8,
              onChanged: store.setVolume,
            ),
          ),
        ),
        const Icon(
          CupertinoIcons.speaker_2_fill,
          size: 14,
          color: AppColors.textSecondary,
        ),
      ],
    );
  }
}

enum PlayerTab { lyrics, airplay, queue }

/// The three-way switch at the foot of the player. The selected one gets the
/// rounded accent plate seen in Now Playing #3/#4.
class PlayerTabRow extends StatelessWidget {
  const PlayerTabRow({
    super.key,
    required this.selected,
    required this.onSelected,
  });

  final PlayerTab? selected;
  final ValueChanged<PlayerTab> onSelected;

  static const Map<PlayerTab, IconData> _icons = <PlayerTab, IconData>{
    PlayerTab.lyrics: CupertinoIcons.text_bubble,
    PlayerTab.airplay: Icons.airplay,
    PlayerTab.queue: CupertinoIcons.list_bullet,
  };

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        for (final PlayerTab tab in PlayerTab.values)
          CupertinoButton(
            padding: const EdgeInsets.all(10),
            minimumSize: const Size(0, 0),
            onPressed: () => onSelected(tab),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: tab == selected
                    ? AppColors.accent
                    : CupertinoColors.transparent,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _icons[tab],
                size: 22,
                color: tab == selected
                    ? AppColors.textPrimary
                    : AppColors.textSecondary,
              ),
            ),
          ),
      ],
    );
  }
}

/// Grabber + track identity + overflow button, shared by the player sheets.
class PlayerHeader extends StatelessWidget {
  const PlayerHeader({
    super.key,
    required this.title,
    required this.artist,
    this.onClose,
    this.onMore,
    this.centered = false,
    this.grabber = true,
    this.artistColor = AppColors.accent,
    this.moreColor = AppColors.accent,
  });

  final String title;
  final String artist;
  final VoidCallback? onClose;
  final VoidCallback? onMore;
  final bool centered;
  final bool grabber;
  final Color artistColor;
  final Color moreColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        if (grabber) const Grabber(),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppDims.gutter),
          child: Row(
            mainAxisAlignment: centered
                ? MainAxisAlignment.center
                : MainAxisAlignment.start,
            children: <Widget>[
              Column(
                crossAxisAlignment: centered
                    ? CrossAxisAlignment.center
                    : CrossAxisAlignment.start,
                children: <Widget>[
                  Text(title, style: AppTypography.title2),
                  Text(
                    artist,
                    style: AppTypography.body.copyWith(color: artistColor),
                  ),
                ],
              ),
              const Spacer(),
              if (onMore != null)
                CupertinoButton(
                  padding: EdgeInsets.zero,
                  minimumSize: const Size(0, 0),
                  onPressed: onMore,
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      color: moreColor,
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        CupertinoIcons.ellipsis,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
              if (onClose != null)
                CupertinoButton(
                  padding: const EdgeInsets.only(left: 8),
                  minimumSize: const Size(0, 0),
                  onPressed: onClose,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceHigh,
                      shape: BoxShape.circle,
                    ),
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Icon(
                        CupertinoIcons.xmark,
                        size: 18,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}
