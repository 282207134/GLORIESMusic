import 'package:flutter/cupertino.dart';

import '../core/design/app_colors.dart';
import '../core/design/app_dims.dart';
import 'page_chrome.dart';

/// Card that slides up over the previous screen, as used by Now Playing,
/// Albums and Scan Codes. A 68pt band of the backdrop stays visible at the top,
/// which is what the artboards show.
class AppSheet extends StatelessWidget {
  const AppSheet({
    super.key,
    required this.child,
    this.gradient = false,
    this.topInset = 68,
  });

  final Widget child;
  final bool gradient;
  final double topInset;

  static Future<T?> show<T>(BuildContext context, Widget sheet) =>
      Navigator.of(context).push<T>(
        CupertinoPageRoute<T>(builder: (_) => sheet, fullscreenDialog: true),
      );

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.canvasDeep,
      child: Padding(
        padding: EdgeInsets.only(top: topInset),
        child: ClipRRect(
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(AppDims.radiusSheet),
          ),
          child: DecoratedBox(
            decoration: BoxDecoration(
              gradient: gradient
                  ? const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: AppColors.playerGradient,
                    )
                  : null,
              color: gradient ? null : AppColors.canvas,
            ),
            child: Column(
              children: <Widget>[
                if (!gradient) const Grabber(),
                Expanded(child: child),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
