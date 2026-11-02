import 'package:flutter/cupertino.dart';

import '../../core/data/catalog.dart';
import '../../core/design/app_colors.dart';
import '../../core/design/app_dims.dart';
import '../../core/design/app_typography.dart';
import '../../widgets/app_sheet.dart';
import '../../widgets/cards.dart';
import '../../widgets/page_chrome.dart';
import '../../widgets/rows.dart';
import '../library/collection_page.dart';
import 'results_page.dart';
import 'scans_sheet.dart';

/// Search #1 (idle grid) and Search #2 (typing + suggestions) in one page: the
/// design changes the body based on whether the field has focus.
class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _query = TextEditingController();
  final FocusNode _field = FocusNode();
  bool _focused = false;
  int _scope = 0;

  bool get _typing => _focused || _query.text.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _query.addListener(() => setState(() {}));
    _field.addListener(() => setState(() => _focused = _field.hasFocus));
  }

  @override
  void dispose() {
    _query.dispose();
    _field.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ColoredBox(
      color: AppColors.canvas,
      child: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            Expanded(
              child: CustomScrollView(
                slivers: <Widget>[
                  if (!_typing)
                    const SliverToBoxAdapter(
                      child: LargeTitleHeader(
                        title: 'Search',
                        showDivider: false,
                      ),
                    ),
                  SliverToBoxAdapter(
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(
                        AppDims.gutter,
                        8,
                        AppDims.gutter,
                        0,
                      ),
                      child: Row(
                        children: <Widget>[
                          Expanded(
                            child: CupertinoTextField(
                              controller: _query,
                              placeholder: 'Search',
                              prefix: const Padding(
                                padding: EdgeInsets.only(left: 10, right: 6),
                                child: Icon(
                                  CupertinoIcons.search,
                                  size: 15,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              suffix: _typing
                                  ? Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: CupertinoButton(
                                        padding: EdgeInsets.zero,
                                        minimumSize: const Size(0, 0),
                                        onPressed: _clear,
                                        child: const Icon(
                                          CupertinoIcons.clear_circled_solid,
                                          size: 16,
                                          color: AppColors.textSecondary,
                                        ),
                                      ),
                                    )
                                  : null,
                              focusNode: _field,
                              onSubmitted: (_) => _openResults(),
                              style: AppTypography.body,
                              placeholderStyle: AppTypography.body.copyWith(
                                color: AppColors.textSecondary,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.surface,
                                borderRadius: BorderRadius.circular(10),
                              ),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 30,
                                vertical: 10,
                              ),
                            ),
                          ),
                          if (_typing)
                            CupertinoButton(
                              padding: const EdgeInsets.only(left: 12),
                              minimumSize: const Size(0, 0),
                              onPressed: _clear,
                              child: Text(
                                'Cancel',
                                style: AppTypography.body.copyWith(
                                  color: AppColors.accent,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                  if (_typing) ...<Widget>[
                    SliverToBoxAdapter(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          AppDims.gutter,
                          14,
                          AppDims.gutter,
                          8,
                        ),
                        child: _ScopeSwitcher(
                          selected: _scope,
                          onSelected: (int i) => setState(() => _scope = i),
                        ),
                      ),
                    ),
                    SliverList.separated(
                      itemCount: Catalog.searchSuggestions.length,
                      separatorBuilder: (_, _) => const Hairline(),
                      itemBuilder: (BuildContext context, int i) => _Suggestion(
                        phrase: Catalog.searchSuggestions[i],
                        typed: _query.text,
                      ),
                    ),
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.only(top: 8),
                        child: Hairline(),
                      ),
                    ),
                    SliverList.separated(
                      itemCount: Catalog.artists.length,
                      separatorBuilder: (_, _) => const Hairline(),
                      itemBuilder: (BuildContext context, int i) => TrackRow(
                        title: Catalog.artists[i].name,
                        subtitle: 'Artist',
                        leading: ArtSlot(
                          art: Catalog.artists[i].art,
                          size: 52,
                          circular: true,
                        ),
                        onTap: () => _openResults(),
                      ),
                    ),
                  ] else ...<Widget>[
                    const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          AppDims.gutter,
                          20,
                          AppDims.gutter,
                          12,
                        ),
                        child: Text(
                          'Browse Categoris',
                          style: AppTypography.title3,
                        ),
                      ),
                    ),
                    SliverPadding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppDims.gutter,
                      ),
                      sliver: SliverGrid(
                        gridDelegate:
                            const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              mainAxisSpacing: 16,
                              crossAxisSpacing: 16,
                              childAspectRatio: 166 / 120,
                            ),
                        delegate: SliverChildBuilderDelegate(
                          (BuildContext context, int i) => CategoryTile(
                            category: Catalog.categories[i],
                            onTap: () =>
                                CollectionPage.push(context, Catalog.dancing),
                          ),
                          childCount: Catalog.categories.length,
                        ),
                      ),
                    ),
                    const SliverToBoxAdapter(child: SizedBox(height: 24)),
                    SliverToBoxAdapter(
                      child: Center(
                        child: CupertinoButton(
                          onPressed: () =>
                              AppSheet.show(context, const ScansSheet()),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Icon(CupertinoIcons.qrcode_viewfinder, size: 20),
                              SizedBox(width: 8),
                              Text('Scan Codes', style: AppTypography.headline),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  const SliverToBoxAdapter(
                    child: SizedBox(height: AppDims.rowHeight),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _clear() {
    _query.clear();
    setState(() => _focused = false);
    _field.unfocus();
  }

  void _openResults() => Navigator.of(context).push(
    CupertinoPageRoute<void>(builder: (_) => ResultsPage(query: _query.text)),
  );
}

/// `Deep Music | Your Library` segmented control from Search #2.
class _ScopeSwitcher extends StatelessWidget {
  const _ScopeSwitcher({required this.selected, required this.onSelected});

  static const List<String> _labels = <String>['Deep Music', 'Your Library'];

  final int selected;
  final ValueChanged<int> onSelected;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(9),
      ),
      child: Row(
        children: <Widget>[
          for (int i = 0; i < _labels.length; i++)
            Expanded(
              child: CupertinoButton(
                padding: const EdgeInsets.symmetric(vertical: 8),
                minimumSize: const Size(0, 0),
                onPressed: () => onSelected(i),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: i == selected
                        ? AppColors.surfaceHigh
                        : CupertinoColors.transparent,
                    borderRadius: BorderRadius.circular(7),
                  ),
                  child: Text(
                    _labels[i],
                    style: AppTypography.callout.copyWith(
                      color: i == selected
                          ? AppColors.textSecondary
                          : AppColors.textPrimary,
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Suggestion row where the typed prefix stays white and the rest dims.
class _Suggestion extends StatelessWidget {
  const _Suggestion({required this.phrase, required this.typed});

  final String phrase;
  final String typed;

  @override
  Widget build(BuildContext context) {
    final int cut = typed.trim().toLowerCase() == phrase.toLowerCase()
        ? phrase.length
        : _prefixLength(phrase, typed);
    return SizedBox(
      height: 52,
      child: Row(
        children: <Widget>[
          const SizedBox(width: AppDims.gutter),
          const Icon(
            CupertinoIcons.search,
            size: 16,
            color: AppColors.textPrimary,
          ),
          const SizedBox(width: 14),
          Text.rich(
            TextSpan(
              children: <InlineSpan>[
                TextSpan(
                  text: phrase.substring(0, cut),
                  style: AppTypography.body,
                ),
                TextSpan(
                  text: phrase.substring(cut),
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static int _prefixLength(String phrase, String typed) {
    final String needle = typed.trim().toLowerCase();
    if (needle.isEmpty) return 1;
    return phrase.toLowerCase().startsWith(needle) ? needle.length : 1;
  }
}
