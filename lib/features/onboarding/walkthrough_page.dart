import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Icons;

import '../../core/data/catalog.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_dims.dart';
import '../../core/design/app_typography.dart';
import '../../core/state/app_scope.dart';
import '../../core/state/app_store.dart';
import '../../widgets/art_image.dart';
import '../../widgets/buttons.dart';

/// Walkthrough #1 → #2 → #3 from the design file, as one swipeable flow.
class WalkthroughPage extends StatefulWidget {
  const WalkthroughPage({super.key, required this.onFinished});

  final VoidCallback onFinished;

  @override
  State<WalkthroughPage> createState() => _WalkthroughPageState();
}

class _WalkthroughPageState extends State<WalkthroughPage> {
  final PageController _controller = PageController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _next() {
    if (_controller.page == 2) {
      widget.onFinished();
    } else {
      _controller.nextPage(
        duration: const Duration(milliseconds: 280),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.canvas,
      child: SafeArea(
        child: PageView(
          controller: _controller,
          children: <Widget>[
            _IntroStep(onLogIn: _next),
            _GenresStep(onNext: _next),
            _ArtistsStep(onNext: _next),
          ],
        ),
      ),
    );
  }
}

/// Headline where the first word is light and the last is bold, exactly as the
/// artboards set "Music Everywhere" / "Your Favorite".
class _SplitHeadline extends StatelessWidget {
  const _SplitHeadline(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    final int cut = text.indexOf(' ');
    if (cut < 0) return Text(text, style: AppTypography.largeTitle);
    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          TextSpan(
            text: '${text.substring(0, cut)} ',
            style: AppTypography.largeTitle.copyWith(
              fontWeight: FontWeight.w400,
            ),
          ),
          TextSpan(
            text: text.substring(cut + 1),
            style: AppTypography.largeTitle,
          ),
        ],
      ),
    );
  }
}

class _StepScaffold extends StatelessWidget {
  const _StepScaffold({
    required this.headline,
    required this.body,
    required this.footer,
    this.eyebrow,
    this.subtitle,
    this.subtitleBold = false,
    this.headAtBottom = false,
  });

  final String headline;
  final String? eyebrow;
  final String? subtitle;
  final Widget body;
  final Widget footer;
  final bool subtitleBold;

  /// Step 1 has no content of its own, so the artboard drops the copy to the
  /// bottom of the screen instead of the usual top-aligned block.
  final bool headAtBottom;

  @override
  Widget build(BuildContext context) {
    final TextStyle subtitleStyle =
        (subtitleBold
                ? AppTypography.title2
                : AppTypography.title2.copyWith(fontWeight: FontWeight.w400))
            .copyWith(height: 1.25);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppDims.gutter),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (headAtBottom) const Spacer() else const SizedBox(height: 72),
          if (eyebrow != null) ...<Widget>[
            Text(eyebrow!, style: AppTypography.overline),
            const SizedBox(height: 6),
          ],
          _SplitHeadline(headline),
          if (subtitle != null) ...<Widget>[
            const SizedBox(height: 18),
            Text(subtitle!, style: subtitleStyle),
          ],
          if (headAtBottom)
            const SizedBox(height: 40)
          else
            Expanded(child: body),
          footer,
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

class _IntroStep extends StatelessWidget {
  const _IntroStep({required this.onLogIn});

  final VoidCallback onLogIn;

  @override
  Widget build(BuildContext context) => _StepScaffold(
    headline: 'Music Everywhere',
    subtitle: '“Life without playing music would be inconceivable”\n- Albert Einstein',
    body: const SizedBox.shrink(),
    headAtBottom: true,
    footer: PrimaryButton(label: 'Log In', onTap: onLogIn),
  );
}

class _GenresStep extends StatelessWidget {
  const _GenresStep({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    final AppStore store = AppScope.of(context);
    return _StepScaffold(
      eyebrow: 'FEATURE 1/3',
      headline: 'Your Favorite',
      subtitle: 'You should choose at least 5 genres to set up your profile.',
      subtitleBold: true,
      body: ListView(
        padding: const EdgeInsets.only(top: 40),
        children: <Widget>[
          Wrap(
            spacing: 12,
            runSpacing: 14,
            children: <Widget>[
              for (final String genre in Catalog.genres)
                GenreChip(
                  label: genre,
                  selected: store.selectedGenres.contains(genre),
                  onTap: () => store.toggleGenre(genre),
                ),
            ],
          ),
        ],
      ),
      footer: _DiscoveryFooter(onNext: onNext),
    );
  }
}

class _ArtistsStep extends StatelessWidget {
  const _ArtistsStep({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) => _StepScaffold(
    eyebrow: 'FEATURE 2/3',
    headline: 'Favorite Artist',
    subtitle: 'You should choose at least 5 genres to set up your profile.',
    subtitleBold: true,
    body: Padding(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          for (int i = 0; i < Catalog.artists.length; i++)
            Padding(
              padding: EdgeInsets.only(bottom: 18, right: i.isEven ? 0 : 96),
              child: ArtImage(
                asset: Catalog.artists[i].art,
                size: 108,
                radius: 54,
              ),
            ),
        ],
      ),
    ),
    footer: _DiscoveryFooter(onNext: onNext),
  );
}

class _DiscoveryFooter extends StatelessWidget {
  const _DiscoveryFooter({required this.onNext});

  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) => Row(
    children: <Widget>[
      Expanded(
        flex: 3,
        child: PrimaryButton(label: 'Discovery Now', onTap: onNext),
      ),
      const SizedBox(width: 16),
      const Expanded(flex: 2, child: _SecureByApple()),
    ],
  );
}

class _SecureByApple extends StatelessWidget {
  const _SecureByApple();

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: <Widget>[
      Text(
        'Secure by',
        style: AppTypography.footnote.copyWith(color: AppColors.textPrimary),
      ),
      const FittedBox(
        fit: BoxFit.scaleDown,
        alignment: Alignment.centerLeft,
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.apple, size: 22, color: AppColors.textPrimary),
            SizedBox(width: 4),
            Text('Apple', style: AppTypography.title2),
          ],
        ),
      ),
    ],
  );
}
