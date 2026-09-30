import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';
import 'package:dakika/l10n/app_localizations.dart';
import 'package:dakika/repositories/article_repository.dart';
import 'package:dakika/models/models.dart';
import 'package:dakika/components/story_card.dart';
import 'package:dakika/components/empty_state.dart';
import 'package:dakika/components/skeleton_card.dart';

/// Explore screen — search, trending topics, categories grid, sources.
class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final _searchController = TextEditingController();
  final _articleRepo = ArticleRepository();

  bool _isSearching = false;
  bool _showResults = false;
  List<Article> _searchResults = [];
  String _currentQuery = '';

  final _trendingTopics = [
    '#RwandaGDP', '#5GExpansion', '#KigaliTech',
    '#AFCON2027', '#CoffeeExports', '#DigitalHealth',
    '#EACTrade', '#ClimateSummit',
  ];

  final _categories = [
    {'name': 'Sports', 'icon': Icons.sports_soccer, 'count': 24},
    {'name': 'Business', 'icon': Icons.trending_up, 'count': 31},
    {'name': 'Tech', 'icon': Icons.computer, 'count': 18},
    {'name': 'Politics', 'icon': Icons.account_balance, 'count': 15},
    {'name': 'Entertainment', 'icon': Icons.movie, 'count': 12},
    {'name': 'Health', 'icon': Icons.favorite, 'count': 9},
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _performSearch(String query) async {
    if (query.trim().isEmpty) {
      setState(() {
        _showResults = false;
        _searchResults = [];
        _currentQuery = '';
      });
      return;
    }

    setState(() {
      _isSearching = true;
      _showResults = true;
      _currentQuery = query;
    });

    try {
      final results = await _articleRepo.searchArticles(query.trim());
      if (mounted) {
        setState(() {
          _searchResults = results;
          _isSearching = false;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _searchResults = [];
          _isSearching = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;
    final tr = context.tr;

    return Scaffold(
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(Space.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      tr('explore_title'),
                      style: Theme.of(context).textTheme.displayLarge,
                    ),
                    const SizedBox(height: Space.md),

                    // Search bar
                    TextField(
                      controller: _searchController,
                      decoration: InputDecoration(
                        hintText: tr('explore_search_hint'),
                        prefixIcon: const Icon(Icons.search),
                        suffixIcon: _searchController.text.isNotEmpty
                            ? IconButton(
                                icon: const Icon(Icons.clear),
                                onPressed: () {
                                  _searchController.clear();
                                  _performSearch('');
                                },
                              )
                            : null,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Radii.md),
                          borderSide: BorderSide(color: tokens.rule),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(Radii.md),
                          borderSide: BorderSide(color: tokens.rule),
                        ),
                        filled: true,
                        fillColor: tokens.surface,
                      ),
                      onSubmitted: _performSearch,
                      onChanged: (value) {
                        setState(() {});
                        if (value.isEmpty) {
                          _performSearch('');
                        }
                      },
                    ),
                    const SizedBox(height: Space.lg),

                    // Show results or browse content
                    if (_showResults) ...[
                      _buildSearchResults(tokens, tr),
                    ] else ...[
                      _buildTrending(tokens, tr),
                      const SizedBox(height: Space.lg),
                      _buildCategories(tokens, tr),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(AppTokens tokens, tr) {
    if (_isSearching) {
      return Column(
        children: const [
          SkeletonCard(),
          SizedBox(height: Space.sm),
          SkeletonCard(),
          SizedBox(height: Space.sm),
          SkeletonCard(),
        ],
      );
    }

    if (_searchResults.isEmpty) {
      return EmptyState(
        icon: Icons.search_off,
        title: tr('explore_no_results'),
        message: tr('explore_no_results_hint'),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${_searchResults.length} ${tr('explore_stories')}',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: Space.sm),
        ..._searchResults.map((article) => Padding(
              padding: const EdgeInsets.only(bottom: Space.sm),
              child: StoryCard(
                headline: article.title,
                summary: article.summary ?? '',
                source: article.sourceName ?? 'Unknown',
                category: article.categoryName ?? 'General',
                publishedAt: article.timeAgo,
                readingTime: article.readingTime,
                onTap: () {
                  Navigator.pushNamed(context, '/article/${article.id}');
                },
                onSave: () async {
                  try {
                    await _articleRepo.saveStory(article.id);
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Story saved'),
                          duration: Duration(seconds: 2),
                        ),
                      );
                    }
                  } catch (e) {
                    // Handle error
                  }
                },
              ),
            )),
      ],
    );
  }

  Widget _buildTrending(AppTokens tokens, tr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('explore_trending'),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: Space.sm),
        SizedBox(
          height: 36,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: _trendingTopics.length,
            separatorBuilder: (_, __) => const SizedBox(width: Space.sm),
            itemBuilder: (context, index) {
              return ActionChip(
                label: Text(_trendingTopics[index]),
                backgroundColor: tokens.surface,
                side: BorderSide(color: tokens.rule),
                onPressed: () {
                  _searchController.text = _trendingTopics[index];
                  _performSearch(_trendingTopics[index]);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildCategories(AppTokens tokens, tr) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tr('explore_categories'),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: Space.sm),
        GridView.count(
          crossAxisCount: 2,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: Space.sm,
          crossAxisSpacing: Space.sm,
          childAspectRatio: 1.5,
          children: _categories.map((cat) {
            return _CategoryCard(
              name: cat['name'] as String,
              icon: cat['icon'] as IconData,
              count: cat['count'] as int,
            );
          }).toList(),
        ),
      ],
    );
  }
}

class _CategoryCard extends StatelessWidget {
  final String name;
  final IconData icon;
  final int count;

  const _CategoryCard({
    required this.name,
    required this.icon,
    required this.count,
  });

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;
    final color = categoryColors[name] ?? tokens.inkSecondary;

    return Card(
      child: InkWell(
        onTap: () {
          // Navigate to category feed
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Opening $name feed...'),
              duration: const Duration(seconds: 1),
            ),
          );
        },
        borderRadius: BorderRadius.circular(Radii.md),
        child: Padding(
          padding: const EdgeInsets.all(Space.md),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(icon, size: 32, color: color),
              const SizedBox(height: Space.sm),
              Text(
                name,
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
              ),
              Text(
                '$count stories',
                style: Theme.of(context).textTheme.labelMedium,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
