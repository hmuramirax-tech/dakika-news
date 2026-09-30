import 'package:flutter/material.dart';
import 'package:dakika/components/greeting.dart';
import 'package:dakika/components/category_tabs.dart';
import 'package:dakika/components/ring.dart';
import 'package:dakika/components/story_card.dart';
import 'package:dakika/components/offline_indicator.dart';
import 'package:dakika/components/ad_banner.dart';
import 'package:dakika/theme/tokens.dart';
import 'package:dakika/repositories/article_repository.dart';
import 'package:dakika/repositories/category_repository.dart';
import 'package:dakika/repositories/offline_cache.dart';
import 'package:dakika/services/connectivity_service.dart';
import 'package:dakika/models/models.dart';

/// Digest Feed — the core screen where 90% of user time is spent.
class DigestFeedScreen extends StatefulWidget {
  const DigestFeedScreen({super.key});

  @override
  State<DigestFeedScreen> createState() => _DigestFeedScreenState();
}

class _DigestFeedScreenState extends State<DigestFeedScreen> {
  static const _categories = [
    'All', 'Sports', 'Business', 'Tech', 'Politics', 'Entertainment', 'Health',
  ];

  String _selectedCategory = 'All';
  double _readingProgress = 0.0;
  bool _loading = true;
  bool _offline = false;
  List<Article> _articles = [];
  final _articleRepo = ArticleRepository();
  final _categoryRepo = CategoryRepository();
  final _connectivityService = ConnectivityService();
  OfflineCache? _cache;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    _cache = await OfflineCache.create();
    _offline = !await _connectivityService.isOnline();
    await _loadArticles();
  }

  Future<void> _loadArticles() async {
    setState(() => _loading = true);
    try {
      final articles = await _articleRepo.getArticles(
        category: _selectedCategory == 'All' ? null : _selectedCategory,
        limit: 20,
      );

      // Cache for offline reading
      if (articles.isNotEmpty && _cache != null) {
        // TODO: Cache as digest
      }

      setState(() {
        _articles = articles;
        _loading = false;
      });
    } catch (e) {
      // Fallback to cache
      if (_cache != null) {
        final cached = await _cache!.getAllCachedDigests();
        final cachedArticles = <Article>[];
        for (final d in cached) {
          cachedArticles.addAll(d.articles);
        }
        setState(() {
          _articles = cachedArticles;
          _loading = false;
          _offline = true;
        });
      } else {
        setState(() {
          _loading = false;
          _offline = true;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tokens = Theme.of(context).brightness == Brightness.dark
        ? darkTokens
        : lightTokens;

    final filteredArticles = _selectedCategory == 'All'
        ? _articles
        : _articles
            .where((a) => a.categoryName == _selectedCategory)
            .toList();

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // Offline banner
            if (_offline) const OfflineIndicator(),

            // Header with greeting + ring
            Padding(
              padding: const EdgeInsets.fromLTRB(
                Space.md, Space.md, Space.md, Space.sm,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Expanded(child: Greeting()),
                  const SizedBox(width: Space.md),
                  SixtySecondRing(
                    progress: _readingProgress,
                    size: 44,
                    strokeWidth: 3,
                    label: '${(_readingProgress * 100).round()}%',
                  ),
                ],
              ),
            ),

            // Category tabs
            CategoryTabs(
              categories: _categories,
              selected: _selectedCategory,
              onSelected: (category) {
                setState(() {
                  _selectedCategory = category;
                  _readingProgress = 0.0;
                });
                _loadArticles();
              },
            ),

            const SizedBox(height: Space.sm),

            // Story cards list
            Expanded(
              child: _loading
                  ? const Center(child: CircularProgressIndicator())
                  : RefreshIndicator(
                      onRefresh: _loadArticles,
                      child: ListView.builder(
                        padding: const EdgeInsets.only(bottom: Space.xxl),
                        itemCount: filteredArticles.length + (filteredArticles.length ~/ 3),
                        itemBuilder: (context, index) {
                          // Show ad after every 3 story cards
                          if (index > 0 && index % 4 == 3) {
                            return const AdBanner();
                          }

                          final articleIndex = index - (index ~/ 4);
                          if (articleIndex >= filteredArticles.length) {
                            return const SizedBox.shrink();
                          }

                          final article = filteredArticles[articleIndex];
                          return StoryCard(
                            headline: article.title,
                            summary: article.summary ?? '',
                            source: article.sourceName ?? 'Unknown',
                            category: article.categoryName ?? 'General',
                            publishedAt: article.timeAgo,
                            readingTime: article.readingTime,
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                '/article/${article.id}',
                              );
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
                                if (mounted) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(content: Text('Error: $e')),
                                  );
                                }
                              }
                            },
                            onShare: () {
                              // TODO: Share via share_plus
                            },
                          );
                        },
                      ),
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
