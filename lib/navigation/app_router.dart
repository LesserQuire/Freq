import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/station.dart';
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
    GoRoute(path: '/splash', pageBuilder: (c, s) => _fadePage(const SplashPage(), s)),
    GoRoute(path: '/signup', pageBuilder: (c, s) => _fadePage(const SignupPage(), s)),
    GoRoute(path: '/player', pageBuilder: (c, s) => _fadePage(const PlayerPage(), s)),
    ShellRoute(
      builder: (context, state, child) => Scaffold(
        body: child,
        bottomNavigationBar: const Playbar(),
      ),
      routes: [
        GoRoute(
          path: '/home',
          pageBuilder: (c, s) => _fadePage(
              HomePage(isPremium: s.uri.queryParameters['premium'] == 'true'), s),
        ),
        GoRoute(path: '/account', pageBuilder: (c, s) => _fadePage(const AccountPage(), s)),
        GoRoute(path: '/search', pageBuilder: (c, s) => _fadePage(const SearchPage(), s)),
        GoRoute(path: '/add-url', pageBuilder: (c, s) => _fadePage(const AddUrlPage(), s)),
        GoRoute(
          path: '/search-details',
          pageBuilder: (c, s) {
            final station = s.extra as Station?;
            if (station == null) {
              return _fadePage(const Text('Error: Station not found'), s);
            }
            return _fadePage(SearchDetailsPage(station: station), s);
          },
        ),
        GoRoute(
          path: '/station-details',
          pageBuilder: (c, s) {
            final station = s.extra as Station?;
            if (station == null) {
              return _fadePage(const Text('Error: Station not found'), s);
            }
            return _fadePage(DetailsPage(station: station), s);
          },
        ),
        GoRoute(path: '/chat', pageBuilder: (c, s) => _fadePage(const ChatPage(), s)),
      ],
    ),
  ],
);

CustomTransitionPage _fadePage(Widget child, GoRouterState state) {
  return CustomTransitionPage(
    child: child,
    transitionDuration: const Duration(milliseconds: 300),
    reverseTransitionDuration: const Duration(milliseconds: 300),
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
  );
}
