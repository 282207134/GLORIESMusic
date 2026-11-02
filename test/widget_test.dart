import 'package:flutter/cupertino.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:glories_music/app/glories_app.dart';
import 'package:glories_music/core/data/catalog.dart';
import 'package:glories_music/core/models/media.dart';
import 'package:glories_music/core/state/app_scope.dart';
import 'package:glories_music/core/state/app_store.dart';

/// Boots the app on a phone-sized surface so the artboard layouts are exercised
/// at the width they were designed for.
Future<void> boot(WidgetTester tester) async {
  tester.view.physicalSize = const Size(750, 1624);
  tester.view.devicePixelRatio = 2;
  addTearDown(tester.view.reset);
  await tester.pumpWidget(const GloriesApp());
  await settle(tester);
}

/// Advances page and route transitions; the store's 1s ticker means
/// `pumpAndSettle` is not an option here.
Future<void> settle(WidgetTester tester) async {
  for (int i = 0; i < 8; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

Future<void> tapText(WidgetTester tester, String label) async {
  await tester.tap(find.text(label));
  await settle(tester);
}

Future<void> onboard(WidgetTester tester) async {
  await tapText(tester, 'Log In');
  await tapText(tester, 'Discovery Now');
  await tapText(tester, 'Discovery Now');
}

void main() {
  testWidgets('walkthrough hands over to the tabbed shell', (
    WidgetTester tester,
  ) async {
    await boot(tester);
    expect(find.text('Music Everywhere'), findsOneWidget);

    await tapText(tester, 'Log In');
    expect(find.text('Your Favorite'), findsOneWidget);

    await tapText(tester, 'Discovery Now');
    expect(find.text('Favorite Artist'), findsOneWidget);

    await tapText(tester, 'Discovery Now');
    expect(find.text('FOR YOU'), findsOneWidget);
    expect(find.text('Search'), findsOneWidget);
  });

  testWidgets('genre chips toggle through the store', (
    WidgetTester tester,
  ) async {
    await boot(tester);
    await tapText(tester, 'Log In');

    const String genre = 'Alternative';
    final AppStore store = tester
        .widget<AppScope>(find.byType(AppScope))
        .store!;
    expect(store.selectedGenres, contains(genre));

    await tester.tap(find.text(genre));
    await settle(tester);
    expect(store.selectedGenres, isNot(contains(genre)));

    await tester.tap(find.text(genre));
    await settle(tester);
    expect(store.selectedGenres, contains(genre));
  });

  testWidgets('transport and lyrics follow the store', (
    WidgetTester tester,
  ) async {
    await boot(tester);
    await onboard(tester);

    final Track current = Catalog.mix.first;
    expect(find.text(current.title), findsWidgets);

    await tester.tap(find.byIcon(CupertinoIcons.play_arrow_solid).last);
    await settle(tester);
    expect(find.byIcon(CupertinoIcons.pause_fill), findsWidgets);

    await tester.tap(find.text(current.title).last);
    await settle(tester);
    await tester.tap(find.byIcon(CupertinoIcons.text_bubble));
    await settle(tester);
    expect(find.text(Catalog.lyrics.first), findsOneWidget);
  });

  testWidgets('tabs switch and search reacts to typing', (
    WidgetTester tester,
  ) async {
    await boot(tester);
    await onboard(tester);

    await tapText(tester, 'Browse');
    expect(find.text('CHILL OUT TONIGHT'), findsOneWidget);

    await tapText(tester, 'Search');
    await tester.enterText(find.byType(CupertinoTextField).first, 'Sia');
    await settle(tester);
    expect(find.text('Cancel'), findsOneWidget);
    expect(find.text('Sia'), findsWidgets);
  });
}
