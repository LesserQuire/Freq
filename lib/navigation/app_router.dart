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
import '../utils/no_transition_page.dart';

final router = GoRouter(
  initialLocation: '/signup',
  routes: [
    GoRoute(
      path: '/player',
      pageBuilder: (context, state) => CustomTransitionPage(
        child: const PlayerPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return const FadeUpwardsPageTransitionsBuilder().buildTransitions(
            null,
            context,
            animation,
            secondaryAnimation,
            child,
          );
        },
      ),
    ),
    GoRoute(
      path: '/signup',
      pageBuilder: (context, state) => AppNoTransitionPage(
        child: const SignupPage(),
        key: state.pageKey,
      ),
    ),
    ShellRoute(
      builder: (context, state, child) {
        return Scaffold(
          body: child,
          bottomNavigationBar: const Playbar(),
        );
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) {
            final isPremium = state.uri.queryParameters['premium'] == 'true';
            return HomePage(isPremium: isPremium);
          },
        ),
        GoRoute(path: '/account', builder: (context, state) => const AccountPage()),
        GoRoute(path: '/search', builder: (context, state) => const SearchPage()),
        GoRoute(path: '/add-url', builder: (context, state) => const AddUrlPage()),
        GoRoute(
            path: '/search-details',
            builder: (context, state) => const SearchDetailsPage()),
        GoRoute(
            path: '/details',
            builder: (context, state) {
              if (state.extra is Map<String, dynamic>) {
                return DetailsPage(
                  extra: state.extra as Map<String, dynamic>?,
                );
              } else {
                return const DetailsPage(extra: null);
              }
            }),
        GoRoute(path: '/chat', builder: (context, state) => const ChatPage()),
      ],
    ),
  ],
);
