import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNoTransitionPage<T> extends CustomTransitionPage<T> {
  const AppNoTransitionPage({required Widget child, required LocalKey key}) : super(child: child, key: key, transitionsBuilder: _noTransition);

  static Widget _noTransition(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
