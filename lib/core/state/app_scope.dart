import 'package:flutter/widgets.dart';

import 'app_store.dart';

/// Publishes the single [AppStore] to the tree. Deliberately dependency-free:
/// one `InheritedNotifier` covers every rebuild this app needs.
class AppScope extends InheritedNotifier<AppStore> {
  const AppScope({
    super.key,
    required AppStore this.store,
    required super.child,
  }) : super(notifier: store);

  final AppStore? store;

  static AppStore of(BuildContext context) {
    final AppScope? scope = context
        .dependOnInheritedWidgetOfExactType<AppScope>();
    final AppStore? store = scope?.store;
    assert(store != null, 'No AppScope found above this widget');
    return store!;
  }
}
