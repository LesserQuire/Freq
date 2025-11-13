import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Import Firestore
import 'firebase_options.dart';
import 'bloc/playbar_bloc.dart';
import 'bloc/saved_radios_bloc.dart';
import 'navigation/app_router.dart';
import 'services/audio_service.dart';
import 'services/auth_service.dart';
import 'services/station_service.dart'; // Import StationService
import 'theme/theme.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize the singleton audio service
  await AudioService.instance.init();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const FreqApp());
}

class FreqApp extends StatelessWidget {
  const FreqApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiRepositoryProvider( // Use MultiRepositoryProvider
      providers: [
        RepositoryProvider<AuthService>(
          create: (context) => AuthService(FirebaseAuth.instance),
        ),
        RepositoryProvider<StationService>( // Provide StationService
          create: (context) => StationService(FirebaseFirestore.instance, FirebaseAuth.instance),
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          // Provide the singleton instance to the BLoC
          BlocProvider(create: (context) => PlaybarBloc(AudioService.instance)),
          BlocProvider(
            create: (context) => SavedRadiosBloc(
              context.read<StationService>(),
              context.read<AuthService>(),
            ),
          ),
        ],
        child: MaterialApp.router(
          title: 'Freq',
          theme: lightTheme,
          darkTheme: darkTheme,
          routerConfig: AppRouter.router,
          debugShowCheckedModeBanner: false,
        ),
      ),
    );
  }
}
