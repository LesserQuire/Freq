import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/playbar_bloc.dart';
import 'navigation/app_router.dart';
import 'theme/theme.dart';

void main() {
  runApp(const FreqApp());
}

class FreqApp extends StatelessWidget {
  const FreqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PlaybarBloc(),
      child: MaterialApp.router(
        title: 'Freq',
        theme: lightTheme,
        darkTheme: darkTheme,
        routerConfig: router,
      ),
    );
  }
}
