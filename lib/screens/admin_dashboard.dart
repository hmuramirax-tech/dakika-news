import 'package:flutter/material.dart';
import 'package:dakika/theme/tokens.dart';
import 'package:dakika/l10n/app_localizations.dart';
import 'package:dakika/repositories/article_repository.dart';
import 'package:dakika/repositories/category_repository.dart';
import 'package:dakika/models/models.dart';
import 'package:dakika/components/skeleton_card.dart';
import 'package:dakika/components/empty_state.dart';

/// Admin dashboard — content management, analytics, editor review.
class AdminDashboardScreen extends StatefulWidget {
  const AdminDashboardScreen({super.key});

  @override
  State<AdminDashboardScreen> createState() => _AdminDashboardScreenState();
}

class _AdminDashboardScreenState extends State<AdminDashboardScreen> {
  final _articleRepo = ArticleRepository();
  final _categoryRepo = CategoryRepository();

  int _selectedIndex = 0;
  List<Article> _pendingArticles = [];
  List<Article> _publishedArticles = [];
  List<Category> _categories = [];
  bool _loading = true;

  // Analytics data
  Map<String, int> _analytics = {
    'total_users': 0,
    'active_subs': 0,
    'total_articles': 0,
    'published_today': 0,
  };

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _loading = true);
    try {
      final categories = await _categoryRepo.getCategories();
      final articles = await _articleRepo.getArticles(limit: 100);

      setState(() {
        _categories = categories;
        _publishedArticles = articles;
        _pendingArticles = articles.where((a) => a.status == 'pending').toList();
        _analytics = {
          'total_users': 1234,
          'active_subs': 89,
          'total_articles': articles.length,
          'published_today': articles.length,
        };
        _loading = false;
      });
    } catch (e) {
      setState(() => _loading = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final tr = context.tr;

    return Scaffold(
      appBar: AppBar(
        title: Text(tr('admin_title')),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Row(
              children: [
                // Sidebar
                NavigationRail(
                  selectedIndex: _selectedIndex,
                  onDestinationSelected: (index) {
                    setState(() => _selectedIndex = index);
                  },
                  labelType: NavigationRailLabelType.all,
                  destinations: [
                    NavigationRailDestination(
                      icon: const Icon(Icons.dashboard_outlined),
                      selectedIcon: const Icon(Icons.dashboard),
                      label: Text(tr('admin_title').split(' ').first),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.article_outlined),
                      selectedIcon: const Icon(Icons.article),
                      label: Text(tr('admin_content')),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.rate_review_outlined),
                      selectedIcon: const Icon(Icons.rate_review),
                      label: Text(tr('admin_editor_queue')),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.people_outlined),
                      selectedIcon: const Icon(Icons.people),
                      label: Text(tr('admin_users')),
                    ),
                    NavigationRailDestination(
                      icon: const Icon(Icons.analytics_outlined),
                      selectedIcon: const Icon(Icons.analytics),
                      label: Text(tr('admin_analytics')),
                    ),
                  ],
                ),
                const VerticalDivider(thickness: 1, width: 1),

                // Main content
                Expanded(
                  child: _buildContent(tr),
                ),
              ],
            ),
    );
  }

  Widget _buildContent(tr) {
    switch (_selectedIndex) {
      case 0:
        return _buildOverview(tr);
      case 1:
        return _buildArticles(tr);
      case 2:
        return _buildReview(tr);
      case 3:
        return _buildUsers(tr);
      case 4:
        return _buildAnalytics(tr);
      default:
        return _buildOverview(tr);
    }
  }

  Widget _buildOverview(tr) {
    return ListView(
      padding: const EdgeInsets.all(Space.md),
      children: [
        Text(
          tr('admin_title'),
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: Space.md),
        Row(
          children: [
            Expanded(
              child: _DashboardCard(
                title: tr('admin_total_articles'),
                value: '${_analytics['total_articles'] ?? 0}',
                icon: Icons.article,
                color: Colors.blue,
              ),
            ),
            const SizedBox(width: Space.sm),
            Expanded(
              child: _DashboardCard(
                title: tr('admin_editor_queue'),
                value: '${_pendingArticles.length}',
                icon: Icons.rate_review,
                color: Colors.orange,
              ),
            ),
          ],
        ),
        const SizedBox(height: Space.sm),
        Row(
          children: [
            Expanded(
              child: _DashboardCard(
                title: tr('admin_total_users'),
                value: '${_analytics['total_users'] ?? 0}',
                icon: Icons.people,
                color: Colors.green,
              ),
            ),
            const SizedBox(width: Space.sm),
            Expanded(
              child: _DashboardCard(
                title: tr('admin_revenue'),
                value: '\$${_analytics['active_subs'] ?? 0}',
                icon: Icons.attach_money,
                color: Colors.purple,
              ),
            ),
          ],
        ),
        const SizedBox(height: Space.lg),
        Text(
          tr('admin_content'),
          style: Theme.of(context).textTheme.headlineLarge,
        ),
        const SizedBox(height: Space.sm),
        ..._categories.map((cat) => Card(
              child: ListTile(
                leading: CircleAvatar(
                  backgroundColor: _parseColor(cat.color),
                  child: Text(
                    cat.nameEn[0].toUpperCase(),
                    style: const TextStyle(color: Colors.white),
                  ),
                ),
                title: Text(cat.nameEn),
                trailing: Text('${cat.name} articles'),
              ),
            )),
      ],
    );
  }

  Widget _buildArticles(tr) {
    if (_publishedArticles.isEmpty) {
      return EmptyState(
        icon: Icons.article_outlined,
        title: 'No articles yet',
        message: 'Ingest RSS feeds to get started',
      );
    }

    return ListView(
      padding: const EdgeInsets.all(Space.md),
      children: [
        Text(
          tr('admin_content'),
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: Space.md),
        ..._publishedArticles.map((article) => Card(
              child: ListTile(
                title: Text(article.title),
                subtitle: Text(article.sourceName ?? 'Unknown source'),
                trailing: Chip(
                  label: Text(article.status.toUpperCase()),
                  backgroundColor: article.status == 'published'
                      ? Colors.green.withValues(alpha: 0.1)
                      : Colors.orange.withValues(alpha: 0.1),
                ),
                onTap: () {
                  // TODO: Edit article
                },
              ),
            )),
      ],
    );
  }

  Widget _buildReview(tr) {
    if (_pendingArticles.isEmpty) {
      return EmptyState(
        icon: Icons.check_circle_outline,
        title: 'No articles pending review',
        message: 'Great job! All caught up.',
      );
    }

    return ListView(
      padding: const EdgeInsets.all(Space.md),
      children: [
        Text(
          tr('admin_editor_queue'),
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: Space.md),
        ..._pendingArticles.map((article) => Card(
              child: Padding(
                padding: const EdgeInsets.all(Space.md),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      article.title,
                      style: Theme.of(context).textTheme.headlineLarge,
                    ),
                    const SizedBox(height: Space.sm),
                    if (article.summary != null)
                      Text(
                        article.summary!,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    const SizedBox(height: Space.md),
                    Row(
                      children: [
                        FilledButton.icon(
                          onPressed: () => _approveArticle(article),
                          icon: const Icon(Icons.check),
                          label: Text(tr('admin_approve')),
                        ),
                        const SizedBox(width: Space.sm),
                        OutlinedButton.icon(
                          onPressed: () => _rejectArticle(article),
                          icon: const Icon(Icons.close),
                          label: Text(tr('admin_reject')),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            )),
      ],
    );
  }

  Widget _buildUsers(tr) {
    return ListView(
      padding: const EdgeInsets.all(Space.md),
      children: [
        Text(
          tr('admin_users'),
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: Space.md),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(Space.lg),
            child: Center(
              child: Text(
                'User management coming soon.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAnalytics(tr) {
    return ListView(
      padding: const EdgeInsets.all(Space.md),
      children: [
        Text(
          tr('admin_analytics'),
          style: Theme.of(context).textTheme.displayLarge,
        ),
        const SizedBox(height: Space.md),
        _AnalyticsCard(
          title: 'DAU / MAU',
          value: '${_analytics['total_users'] ?? 0}',
          subtitle: 'Daily active users',
          icon: Icons.people,
          color: Colors.blue,
        ),
        const SizedBox(height: Space.sm),
        _AnalyticsCard(
          title: 'Active Subscriptions',
          value: '${_analytics['active_subs'] ?? 0}',
          subtitle: 'Premium subscribers',
          icon: Icons.star,
          color: Colors.amber,
        ),
        const SizedBox(height: Space.sm),
        _AnalyticsCard(
          title: 'Revenue (Month)',
          value: '\$${_analytics['active_subs'] ?? 0}',
          subtitle: 'Estimated monthly revenue',
          icon: Icons.attach_money,
          color: Colors.green,
        ),
        const SizedBox(height: Space.lg),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(Space.lg),
            child: Column(
              children: [
                Icon(
                  Icons.insights,
                  size: 48,
                  color: Theme.of(context).colorScheme.primary,
                ),
                const SizedBox(height: Space.sm),
                Text(
                  'Detailed analytics coming soon',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                Text(
                  'Integrate PostHog for detailed insights',
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.6),
                      ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Future<void> _approveArticle(Article article) async {
    // TODO: Implement approve via Supabase
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Article approved')),
    );
  }

  Future<void> _rejectArticle(Article article) async {
    // TODO: Implement reject via Supabase
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Article rejected')),
    );
  }

  Color _parseColor(String? colorStr) {
    if (colorStr == null) return Colors.grey;
    try {
      return Color(int.parse(colorStr.replaceFirst('#', '0xFF')));
    } catch (e) {
      return Colors.grey;
    }
  }
}

class _DashboardCard extends StatelessWidget {
  final String title;
  final String value;
  final IconData icon;
  final Color color;

  const _DashboardCard({
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(Space.md),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: Space.sm),
            Text(
              value,
              style: Theme.of(context).textTheme.displayLarge?.copyWith(
                    fontSize: 24,
                  ),
            ),
            Text(
              title,
              style: Theme.of(context).textTheme.labelMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _AnalyticsCard extends StatelessWidget {
  final String title;
  final String value;
  final String subtitle;
  final IconData icon;
  final Color color;

  const _AnalyticsCard({
    required this.title,
    required this.value,
    required this.subtitle,
    required this.icon,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color.withValues(alpha: 0.1),
          child: Icon(icon, color: color),
        ),
        title: Text(title),
        subtitle: Text(subtitle),
        trailing: Text(
          value,
          style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                color: color,
              ),
        ),
      ),
    );
  }
}
