import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:dakika/screens/splash.dart';
import 'package:dakika/screens/digest_feed.dart';
import 'package:dakika/screens/explore.dart';
import 'package:dakika/screens/saved.dart';
import 'package:dakika/screens/profile.dart';
import 'package:dakika/screens/full_article.dart';
import 'package:dakika/screens/referral_screen.dart';
import 'package:dakika/screens/admin_dashboard.dart';
import 'package:dakika/screens/premium_paywall.dart';
import 'package:dakika/screens/notification_settings.dart';
import 'package:dakika/screens/about_screen.dart';
import 'package:dakika/screens/terms_screen.dart';
import 'package:dakika/screens/onboarding.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/splash',
  routes: [
    GoRoute(
      path: '/splash',
      builder: (context, state) => const SplashScreen(),
    ),
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) => ScaffoldWithNav(child: child),
      routes: [
        GoRoute(
          path: '/',
          builder: (context, state) => const DigestFeedScreen(),
        ),
        GoRoute(
          path: '/explore',
          builder: (context, state) => const ExploreScreen(),
        ),
        GoRoute(
          path: '/saved',
          builder: (context, state) => const SavedScreen(),
        ),
        GoRoute(
          path: '/profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: '/referral',
          builder: (context, state) => const ReferralScreen(),
        ),
        GoRoute(
          path: '/admin',
          builder: (context, state) => const AdminDashboardScreen(),
        ),
        GoRoute(
          path: '/premium',
          builder: (context, state) => const PremiumPaywallScreen(),
        ),
        GoRoute(
          path: '/notifications',
          builder: (context, state) => const NotificationSettingsScreen(),
        ),
        GoRoute(
          path: '/about',
          builder: (context, state) => const AboutScreen(),
        ),
        GoRoute(
          path: '/terms',
          builder: (context, state) => const TermsScreen(),
        ),
        GoRoute(
          path: '/onboarding',
          builder: (context, state) => const OnboardingScreen(),
        ),
      ],
    ),
    GoRoute(
      path: '/article/:id',
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => FullArticleScreen(
        articleId: state.pathParameters['id']!,
      ),
    ),
  ],
);

class ScaffoldWithNav extends StatelessWidget {
  final Widget child;

  const ScaffoldWithNav({super.key, required this.child});

  static int _indexFromLocation(String location) {
    if (location.startsWith('/explore')) return 1;
    if (location.startsWith('/saved')) return 2;
    if (location.startsWith('/profile')) return 3;
    if (location.startsWith('/referral')) return 4;
    if (location.startsWith('/admin')) return 5;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    final currentIndex = _indexFromLocation(location);

    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: (index) {
          switch (index) {
            case 0:
              context.go('/');
            case 1:
              context.go('/explore');
            case 2:
              context.go('/saved');
            case 3:
              context.go('/profile');
            case 4:
              context.go('/referral');
            case 5:
              context.go('/admin');
          }
        },
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.article_outlined),
            selectedIcon: Icon(Icons.article),
            label: 'Digest',
          ),
          NavigationDestination(
            icon: Icon(Icons.explore_outlined),
            selectedIcon: Icon(Icons.explore),
            label: 'Explore',
          ),
          NavigationDestination(
            icon: Icon(Icons.bookmark_outline),
            selectedIcon: Icon(Icons.bookmark),
            label: 'Saved',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person),
            label: 'Profile',
          ),
          NavigationDestination(
            icon: Icon(Icons.card_giftcard_outlined),
            selectedIcon: Icon(Icons.card_giftcard),
            label: 'Referrals',
          ),
          NavigationDestination(
            icon: Icon(Icons.admin_panel_settings_outlined),
            selectedIcon: Icon(Icons.admin_panel_settings),
            label: 'Admin',
          ),
        ],
      ),
    );
  }
}
