import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'pages/add_url.dart';
import 'pages/account.dart';
import 'pages/search_details.dart';
import 'pages/search.dart';
import 'pages/home.dart';
import 'pages/details.dart';
import 'pages/chat.dart';
import 'pages/signup.dart';

void main() {
  runApp(const FreqApp());
}

final _router = GoRouter(
  initialLocation: '/signup',
  routes: [
    GoRoute(
      path: '/signup',
      pageBuilder: (context, state) => const NoTransitionPage(
        child: SignupPage(),
      ),
      redirect: (context, state) {
        final canPop = state.matchedLocation != '/signup';
        if (canPop) return '/signup';
        return null;
      },
    ),
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
    GoRoute(path: '/search-details', builder: (context, state) => const SearchDetailsPage()),
    GoRoute(path: '/details', builder: (context, state) => DetailsPage(
      extra: state.extra as Map<String, dynamic>?,
    )),
    GoRoute(path: '/chat', builder: (context, state) => const ChatPage()),
  ],
);


class FreqApp extends StatelessWidget {
  const FreqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Freq',
      theme: ThemeData(useMaterial3: true, colorSchemeSeed: Colors.blue),
      routerConfig: _router,
      builder: (context, child) => WillPopScope(
        onWillPop: () async => false,
        child: child ?? const SizedBox.shrink(),
      ),
    );
  }
}
