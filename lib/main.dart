import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/core/di/service_locator.dart';
import 'package:rolla_fitness_app_demo/core/theme/app_theme.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_type.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/pages/score_detail_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize dependency injection
  await configureDependencies();

  runApp(const RollaFitnessApp());
}

class RollaFitnessApp extends StatelessWidget {
  const RollaFitnessApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Rolla Fitness',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      home: const ScoreDetailPage(scoreType: ScoreType.health),
    );
  }
}
