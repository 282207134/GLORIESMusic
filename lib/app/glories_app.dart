import 'package:flutter/cupertino.dart';

import '../core/design/app_theme.dart';
import '../core/state/app_scope.dart';
import '../core/state/app_store.dart';
import '../features/root_page.dart';

/// Root of the widget tree. Owns the single [AppStore] and hands the Cupertino
/// theming down to everything below.
class GloriesApp extends StatefulWidget {
  const GloriesApp({super.key});

  @override
  State<GloriesApp> createState() => _GloriesAppState();
}

class _GloriesAppState extends State<GloriesApp> {
  final AppStore _store = AppStore();

  @override
  void dispose() {
    _store.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      title: 'GLORIES Music',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.cupertino,
      home: const RootPage(),
      // Above the Navigator, so pushed routes and sheets can read the store.
      builder: (BuildContext context, Widget? child) =>
          AppScope(store: _store, child: child!),
    );
  }
}
