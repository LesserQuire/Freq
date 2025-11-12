import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class AppNoTransitionPage<T> extends CustomTransitionPage<T> {
  const AppNoTransitionPage({required super.child, required LocalKey super.key}) : super(transitionsBuilder: _noTransition);

  static Widget _noTransition(BuildContext context, Animation<double> animation, Animation<double> secondaryAnimation, Widget child) {
    return child;
  }
}
