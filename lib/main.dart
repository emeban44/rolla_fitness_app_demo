import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolla_fitness_app_demo/core/di/scores_injection.dart';
import 'package:rolla_fitness_app_demo/core/theme/app_theme.dart';
import 'package:rolla_fitness_app_demo/core/theme/theme_cubit.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/pages/scores_home_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Set preferred orientations to portrait only (up and down)
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);

  // Initialize dependency injection
  await configureDependencies();

  runApp(const RollaFitnessApp());
}

class RollaFitnessApp extends StatelessWidget {
  const RollaFitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ThemeCubit(),
      child: BlocBuilder<ThemeCubit, ThemeMode>(
        builder: (context, themeMode) {
          return MaterialApp(
            title: 'Rolla Fitness',
            debugShowCheckedModeBanner: false,
            theme: AppTheme.light(),
            darkTheme: AppTheme.dark(),
            themeMode: themeMode,
            home: const ScoresHomePage(),
          );
        },
      ),
    );
  }
}
