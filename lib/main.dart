import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'bloc/playbar_bloc.dart';
import 'bloc/saved_radios_bloc.dart';
import 'navigation/app_router.dart';
import 'services/audio_service.dart';
import 'theme/theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final audioService = AudioService();
  await audioService.init();
  runApp(FreqApp(audioService: audioService));
}

class FreqApp extends StatelessWidget {
  final AudioService audioService;
  const FreqApp({super.key, required this.audioService});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => PlaybarBloc(audioService)),
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
