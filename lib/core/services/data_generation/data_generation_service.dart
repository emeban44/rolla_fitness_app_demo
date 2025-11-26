import 'package:flutter/foundation.dart';
import 'package:injectable/injectable.dart';
import 'package:rolla_fitness_app_demo/core/services/data_generation/data_generator.dart';
import 'package:rolla_fitness_app_demo/features/scores/data/datasources/scores_local_datasource.dart';

/// Service for generating fitness data using pure Dart
/// Runs the data generation at app startup to ensure fresh data
@lazySingleton
class DataGenerationService {
  final ScoresLocalDataSource localDataSource;
  final DataGenerator _generator = DataGenerator();

  DataGenerationService(this.localDataSource);

  /// Generate fresh fitness data using Dart
  /// Returns true if successful, false otherwise
  Future<bool> generateData() async {
    try {
      // Generate data using pure Dart
      final data = await _generator.generateCompleteData();

      if (data != null) {
        // Set the generated data directly in the datasource (in-memory)
        localDataSource.setGeneratedData(data);
        return true;
      } else {
        debugPrint('❌ Data generation failed');
        return false;
      }
    } catch (e) {
      debugPrint('❌ Error generating data: $e');
      return false;
    }
  }

  /// Generate fresh data for pull-to-refresh
  /// Runs the full generation to get fresh data and see the tween animations
  Future<bool> refreshData() async {
    return await generateData();
  }
}
