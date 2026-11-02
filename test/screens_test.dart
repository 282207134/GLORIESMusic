import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:glories_music/core/data/catalog.dart';
import 'package:glories_music/core/design/app_theme.dart';
import 'package:glories_music/core/state/app_scope.dart';
import 'package:glories_music/core/state/app_store.dart';
import 'package:glories_music/features/browse/albums_sheet.dart';
import 'package:glories_music/features/browse/browse_page.dart';
import 'package:glories_music/features/browse/radio_page.dart';
import 'package:glories_music/features/home/home_page.dart';
import 'package:glories_music/features/library/collection_page.dart';
import 'package:glories_music/features/library/library_page.dart';
import 'package:glories_music/features/onboarding/walkthrough_page.dart';
import 'package:glories_music/features/player/now_playing_page.dart';
import 'package:glories_music/features/profile/equalizer_page.dart';
import 'package:glories_music/features/profile/profile_page.dart';
import 'package:glories_music/features/profile/settings_page.dart';
import 'package:glories_music/features/search/results_page.dart';
import 'package:glories_music/features/search/scans_sheet.dart';
import 'package:glories_music/features/search/search_page.dart';

/// Every screen in the design file, pumped on a 375x812 canvas. A layout that
/// does not fit throws during the test, so this is the overflow guard for the
/// whole app.
void main() {
  final Map<String, Widget> screens = <String, Widget>{
    'walkthrough': WalkthroughPage(onFinished: () {}),
    'home': const HomePage(),
    'browse': const BrowsePage(),
    'radio': const RadioPage(),
    'library': const LibraryPage(),
    'search': const SearchPage(),
    'results': const ResultsPage(query: 'Sia'),
    'profile': const ProfilePage(),
    'settings': const SettingsPage(),
    'equalizer': const EqualizerPage(),
    'daily-mix': CollectionPage(collection: Catalog.dailyMix),
    'playlist': CollectionPage(collection: Catalog.playlist),
    'album': CollectionPage(collection: Catalog.dancing),
    'now-playing': const NowPlayingPage(),
    'albums-sheet': const AlbumsSheet(),
    'scans-sheet': const ScansSheet(),
    'track-actions': TrackActionsSheet(track: Catalog.chart.first),
  };

  for (final MapEntry<String, Widget> entry in screens.entries) {
    testWidgets('${entry.key} fits 375x812', (WidgetTester tester) async {
      tester.view.physicalSize = const Size(750, 1624);
      tester.view.devicePixelRatio = 2;
      addTearDown(tester.view.reset);

      final AppStore store = AppStore();

      await tester.pumpWidget(
        CupertinoApp(
          debugShowCheckedModeBanner: false,
          theme: AppTheme.cupertino,
          home: AppScope(store: store, child: entry.value),
        ),
      );
      await tester.pump(const Duration(milliseconds: 400));
      expect(tester.takeException(), isNull);
      // Detach the scope's listener before the store goes away.
      await tester.pumpWidget(const SizedBox());
      store.dispose();
    });
  }
}
