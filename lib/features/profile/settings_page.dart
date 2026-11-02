import 'package:flutter/cupertino.dart';

import '../../core/data/catalog.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_dims.dart';
import '../../core/design/app_typography.dart';
import '../../core/state/app_scope.dart';
import '../../core/state/app_store.dart';
import '../../widgets/buttons.dart';
import '../../widgets/page_chrome.dart';
import '../../widgets/rows.dart';
import 'equalizer_page.dart';

/// Setting #1: account block, two accent-headed groups, and a log-out CTA.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  static const List<String> _musicRows = <String>[
    'Devices',
    'Playback',
    'Social',
    'Music Quality',
  ];

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
            const LargeTitleHeader(
              title: 'Setting',
              backTitle: 'Back',
              showDivider: false,
            ),
            const Hairline(),
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 22),
              child: Column(
                children: <Widget>[
                  Text(Catalog.userName, style: AppTypography.title3),
                  SizedBox(height: 2),
                  Text(Catalog.userPhone, style: AppTypography.subheadline),
                ],
              ),
            ),
            const Hairline(),
            const _GroupTitle('Music App'),
            SwitchRow(
              title: 'Auto Play Related Tracks',
              value: store.autoPlayRelated,
              onChanged: (_) => store.toggleAutoPlay(),
            ),
            const Hairline(),
            for (final String row in _musicRows) ...<Widget>[
              _navRow(row, context),
              const Hairline(),
            ],
            const _GroupTitle('System'),
            const LinkRow(title: 'Notifications'),
            const Hairline(),
            const LinkRow(title: 'About'),
            const Hairline(),
            const Padding(
              padding: EdgeInsets.fromLTRB(
                AppDims.gutter,
                24,
                AppDims.gutter,
                8,
              ),
              child: PrimaryButton(label: 'Log Out'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _navRow(String title, BuildContext context) => LinkRow(
    title: title,
    onTap: title == 'Playback'
        ? () => Navigator.of(context).push(
            CupertinoPageRoute<void>(builder: (_) => const EqualizerPage()),
          )
        : null,
  );
}

class _GroupTitle extends StatelessWidget {
  const _GroupTitle(this.label);

  final String label;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.fromLTRB(AppDims.gutter, 22, AppDims.gutter, 12),
    child: Text(
      label,
      style: AppTypography.title3.copyWith(color: AppColors.accent),
    ),
  );
}
