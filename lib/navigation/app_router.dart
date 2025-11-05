import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../pages/add_url.dart';
import '../pages/account.dart';
import '../pages/search_details.dart';
import '../pages/search.dart';
import '../pages/home.dart';
import '../pages/details.dart';
import '../pages/chat.dart';
import '../pages/signup.dart';
import '../pages/playbar.dart';
import '../pages/player_page.dart';
import '../pages/splash_page.dart';

final router = GoRouter(
  initialLocation: '/splash',
  routes: [
    GoRoute(path: '/splash', pageBuilder: (c, s) => _crossfadePage(const SplashPage(), s)),
    GoRoute(path: '/signup', pageBuilder: (c, s) => _crossfadePage(const SignupPage(), s)),
    GoRoute(path: '/player', pageBuilder: (c, s) => _crossfadePage(const PlayerPage(), s)),
    ShellRoute(
      builder: (context, state, child) => Scaffold(
        body: child,
        bottomNavigationBar: const Playbar(),
      ),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (c, s) =>
              _crossfadePage(HomePage(isPremium: s.uri.queryParameters['premium'] == 'true'), s),
        ),
        GoRoute(path: '/account', pageBuilder: (c, s) => _crossfadePage(const AccountPage(), s)),
        GoRoute(path: '/search', pageBuilder: (c, s) => _crossfadePage(const SearchPage(), s)),
        GoRoute(path: '/add-url', pageBuilder: (c, s) => _crossfadePage(const AddUrlPage(), s)),
        GoRoute(path: '/search-details', pageBuilder: (c, s) => _crossfadePage(const SearchDetailsPage(), s)),
        GoRoute(
          path: '/details',
          pageBuilder: (c, s) {
            final extra = s.extra is Map<String, dynamic> ? s.extra as Map<String, dynamic> : null;
            return _crossfadePage(DetailsPage(extra: extra), s);
          },
        ),
        GoRoute(path: '/chat', pageBuilder: (c, s) => _crossfadePage(const ChatPage(), s)),
      ],
    ),
  ],
);

CustomTransitionPage _crossfadePage(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      final fadeIn = FadeTransition(
        opacity: animation,
        child: child,
      );

      final fadeOut = FadeTransition(
        opacity: Tween<double>(begin: 1.0, end: 0.0).animate(secondaryAnimation),
        child: child,
      );

      return Stack(
        children: [
          fadeOut,
          fadeIn,
        ],
      );
    },
  );
}
