import 'package:flutter/cupertino.dart';

import '../widgets/app_shell.dart';
import 'browse/browse_page.dart';
import 'home/home_page.dart';
import 'onboarding/walkthrough_page.dart';
import 'profile/profile_page.dart';
import 'search/search_page.dart';

/// Entry point after launch: the three-step walkthrough, then the tabbed shell.
class RootPage extends StatefulWidget {
  const RootPage({super.key});

  @override
  State<RootPage> createState() => _RootPageState();
}

class _RootPageState extends State<RootPage> {
  bool _onboarded = false;
  int _tab = 0;

  static const List<Widget> _tabs = <Widget>[
    HomePage(),
    BrowsePage(),
    SearchPage(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    if (!_onboarded) {
      return WalkthroughPage(
        onFinished: () => setState(() => _onboarded = true),
      );
    }
    return AppShell(
      tabs: _tabs,
      currentIndex: _tab,
      onTabChanged: (int i) => setState(() => _tab = i),
    );
  }
}
