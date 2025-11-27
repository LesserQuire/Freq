import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/station.dart';
import '../pages/add_url.dart';
import '../pages/account.dart';
import '../pages/login.dart';
import '../pages/search_details.dart';
import '../pages/search.dart';
import '../pages/home.dart';
import '../pages/details.dart';
import '../pages/chat.dart';
import '../pages/signup.dart';
import '../pages/playbar.dart';
import '../pages/player_page.dart';
import '../pages/splash_page.dart';
import '../services/auth_service.dart';
import 'go_router_refresh_stream.dart';

enum TransitionType {
  fade,
  up,
  down,
  right,
  horizontalHomeSearch,
}

class AppRouter {
  final AuthService _authService;

  AppRouter(this._authService);

  GoRouter get router => GoRouter(
        initialLocation: '/splash',
        refreshListenable:
            GoRouterRefreshStream(_authService.authStateChanges),
        routes: [
          GoRoute(
            path: '/splash',
            pageBuilder: (context, state) =>
                _customPage(SplashPage(authService: _authService), state,
                    transition: TransitionType.fade),
          ),
          GoRoute(
            path: '/login',
            pageBuilder: (c, s) => _customPage(
                const LoginPage(), s,
                transition: TransitionType.fade),
          ),
          GoRoute(
            path: '/signup',
            pageBuilder: (c, s) => _customPage(
                const SignupPage(), s,
                transition: TransitionType.fade),
          ),
          GoRoute(
            path: '/player',
            pageBuilder: (c, s) =>
                _customPage(const PlayerPage(), s, transition: TransitionType.fade),
          ),
          ShellRoute(
            builder: (context, state, child) => Scaffold(
              body: child,
              bottomNavigationBar: const Playbar(),
            ),
            routes: [
              GoRoute(
                path: '/home',
                pageBuilder: (c, s) => _customPage(
                    HomePage(isPremium: s.uri.queryParameters['premium'] == 'true'),
                    s,
                    transition: TransitionType.up),
              ),
              GoRoute(
                path: '/account',
                pageBuilder: (c, s) =>
                    _customPage(const AccountPage(), s, transition: TransitionType.down),
              ),
              GoRoute(
                path: '/search',
                pageBuilder: (c, s) =>
                    _customPage(const SearchPage(), s, transition: TransitionType.horizontalHomeSearch),
              ),
              GoRoute(
                path: '/add-url',
                pageBuilder: (c, s) =>
                    _customPage(const AddUrlPage(), s, transition: TransitionType.up),
              ),
              GoRoute(
                path: '/search-details',
                pageBuilder: (c, s) {
                  final station = s.extra as Station?;
                  if (station == null) {
                    return _customPage(
                        const Text('Error: Station not found'), s,
                        transition: TransitionType.up);
                  }
                  return _customPage(
                      SearchDetailsPage(station: station), s,
                      transition: TransitionType.up);
                },
              ),
              GoRoute(
                path: '/station-details',
                pageBuilder: (c, s) {
                  final station = s.extra as Station?;
                  if (station == null) {
                    return _customPage(
                        const Text('Error: Station not found'), s,
                        transition: TransitionType.up);
                  }
                  return _customPage(
                      DetailsPage(station: station), s,
                      transition: TransitionType.up);
                },
              ),
              GoRoute(
                path: '/chat',
                pageBuilder: (c, s) =>
                    _customPage(const ChatPage(), s, transition: TransitionType.up),
              ),
            ],
          ),
        ],
        redirect: (context, state) {
          final user = _authService.currentUser;
          final loggingIn =
              state.matchedLocation == '/login' || state.matchedLocation == '/signup';
          final splashing = state.matchedLocation == '/splash';

          if (splashing) return null;

          if (user == null) return loggingIn ? null : '/login';

          if (loggingIn) return '/home?premium=false';

          return null;
        },
      );

  static CustomTransitionPage _customPage(
      Widget child, GoRouterState state,
      {TransitionType transition = TransitionType.fade}) {
    return CustomTransitionPage(
      key: state.pageKey,
      child: child,
      transitionDuration: const Duration(milliseconds: 300),
      reverseTransitionDuration: const Duration(milliseconds: 300),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        switch (transition) {
          case TransitionType.fade:
            return FadeTransition(opacity: animation, child: child);

          case TransitionType.up:
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, 1), end: Offset.zero)
                  .animate(animation),
              child: child,
            );

          case TransitionType.down:
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
                  .animate(animation),
              child: child,
            );

          case TransitionType.right:
            return SlideTransition(
              position: Tween<Offset>(begin: const Offset(1, 0), end: Offset.zero)
                  .animate(animation),
              child: child,
            );

          case TransitionType.horizontalHomeSearch:
            return Stack(
              children: [
                SlideTransition(
                  position: Tween<Offset>(
                    begin: Offset.zero,
                    end: const Offset(1, 0),
                  ).animate(secondaryAnimation),
                  child: _getPreviousPageWidget(context),
                ),
                SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(-1, 0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              ],
            );
        }
      },
    );
  }

  static Widget _getPreviousPageWidget(BuildContext context) {
    return Container(color: Colors.transparent);
  }
}
