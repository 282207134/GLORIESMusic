import 'package:flutter/cupertino.dart';

import '../../core/data/catalog.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_dims.dart';
import '../../core/design/app_typography.dart';
import '../../widgets/app_sheet.dart';
import '../../widgets/art_image.dart';
import '../../widgets/buttons.dart';
import '../../widgets/page_chrome.dart';
import '../../widgets/rows.dart';

/// Scans artboard: sheet with a square cover, a waveform laid over it, and the
/// explanatory copy underneath.
class ScansSheet extends StatelessWidget {
  const ScansSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return AppSheet(
      child: Column(
        children: <Widget>[
          const Padding(
            padding: EdgeInsets.fromLTRB(
              AppDims.gutter,
              18,
              AppDims.gutter,
              24,
            ),
            child: Text('Scan Codes', style: AppTypography.largeTitle),
          ),
          const Hairline(),
          Expanded(
            child: Center(
              child: SizedBox(
                width: 280,
                height: 280,
                child: Stack(
                  alignment: Alignment.center,
                  children: <Widget>[
                    ArtImage(
                      asset: Catalog.categories.first.art,
                      radius: AppDims.radiusTile,
                    ),
                    const Positioned(bottom: 40, child: _Waveform()),
                  ],
                ),
              ),
            ),
          ),
          const Hairline(),
          const Padding(
            padding: EdgeInsets.fromLTRB(40, 24, 40, 32),
            child: Text(
              'There\'s a uinique code for everything on Deep Music. '
              'Scan a code on a friend\'s phone and go to that song, '
              'artist, or playlist.',
              textAlign: TextAlign.center,
              style: AppTypography.title3,
            ),
          ),
          BottomBar(
            insetsHome: false,
            child: PrimaryButton(
              label: 'Scan',
              onTap: () => Navigator.of(context).pop(),
            ),
          ),
          const SizedBox(height: AppDims.homeIndicatorHeight),
        ],
      ),
    );
  }
}

/// Static bar pattern matching the audio glyph drawn on the artboard.
class _Waveform extends StatelessWidget {
  const _Waveform();

  static const List<double> _bars = <double>[
    6,
    14,
    9,
    22,
    12,
    30,
    16,
    38,
    20,
    44,
    24,
    36,
    18,
    28,
    14,
    20,
    10,
  ];

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      for (final double h in _bars)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 1.5),
          child: Container(
            width: 2.5,
            height: h,
            decoration: BoxDecoration(
              color: AppColors.textPrimary,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ),
    ],
  );
}
