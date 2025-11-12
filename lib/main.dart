import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/playbar_bloc.dart';
import 'bloc/saved_radios_bloc.dart';
import 'navigation/app_router.dart';
import 'services/audio_service.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the singleton audio service
  await AudioService.instance.init();
  runApp(const FreqApp());
}

class FreqApp extends StatelessWidget {
  const FreqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        // Provide the singleton instance to the BLoC
        BlocProvider(create: (context) => PlaybarBloc(AudioService.instance)),
        BlocProvider(create: (context) => SavedRadiosBloc()),
      ],
      child: MaterialApp.router(
        title: 'Freq',
        theme: lightTheme,
        darkTheme: darkTheme,
        routerConfig: router,
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}
