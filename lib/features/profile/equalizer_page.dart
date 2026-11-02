import 'package:flutter/cupertino.dart';

import '../../core/data/catalog.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_typography.dart';
import '../../core/state/app_scope.dart';
import '../../core/state/app_store.dart';
import '../../widgets/page_chrome.dart';
import '../../widgets/rows.dart';

/// Setting #2: the two-curve equalizer graph over the playback rows.
class EqualizerPage extends StatelessWidget {
  const EqualizerPage({super.key});

  @override
  Widget build(BuildContext context) {
    final AppStore store = AppScope.of(context);
    return ColoredBox(
      color: AppColors.canvas,
      child: SafeArea(
        bottom: false,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            const NavBar(title: 'Equalizer', backTitle: 'Setting'),
            const SizedBox(height: 12),
            const SizedBox(
              height: 260,
              child: CustomPaint(size: Size.infinite, painter: _CurvePainter()),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: <Widget>[
                  for (final String band in Catalog.equalizerBands)
                    Expanded(
                      child: Center(
                        child: Text(band, style: AppTypography.caption),
                      ),
                    ),
                ],
              ),
            ),
            const Hairline(indent: 0),
            SwitchRow(
              title: 'Auto Play Related Tracks',
              value: store.autoPlayRelated,
              onChanged: (_) => store.toggleAutoPlay(),
            ),
            const Hairline(),
            const LinkRow(title: 'Devices'),
            const Hairline(),
            const LinkRow(title: 'Playback', trailing: _CheckDot()),
            const Hairline(),
            const LinkRow(title: 'Social', trailing: SizedBox.shrink()),
            const Hairline(),
            const LinkRow(title: 'Music Quality', trailing: SizedBox.shrink()),
            const Hairline(),
          ],
        ),
      ),
    );
  }
}

class _CheckDot extends StatelessWidget {
  const _CheckDot();

  @override
  Widget build(BuildContext context) => const DecoratedBox(
    decoration: BoxDecoration(color: AppColors.accent, shape: BoxShape.circle),
    child: SizedBox(
      width: 30,
      height: 30,
      child: Icon(
        CupertinoIcons.checkmark,
        size: 16,
        color: AppColors.canvasDeep,
      ),
    ),
  );
}

/// Two polylines with round vertex markers, matching the artboard curves.
class _CurvePainter extends CustomPainter {
  const _CurvePainter();

  @override
  void paint(Canvas canvas, Size size) {
    _drawCurve(canvas, size, Catalog.equalizerLeft, AppColors.accent);
    _drawCurve(canvas, size, Catalog.equalizerRight, AppColors.blue);
  }

  void _drawCurve(Canvas canvas, Size size, List<double> points, Color color) {
    final Paint stroke = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..strokeJoin = StrokeJoin.round;
    final Paint dot = Paint()..color = color;
    final double step = size.width / (points.length - 1);

    final Path path = Path()..moveTo(0, size.height * (1 - points.first));
    for (int i = 1; i < points.length; i++) {
      path.lineTo(step * i, size.height * (1 - points[i]));
    }
    canvas.drawPath(path, stroke);

    for (int i = 0; i < points.length; i++) {
      canvas.drawCircle(
        Offset(step * i, size.height * (1 - points[i])),
        5,
        dot,
      );
    }
  }

  @override
  bool shouldRepaint(_CurvePainter oldDelegate) => false;
}
