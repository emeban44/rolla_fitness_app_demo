import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/core/theme/app_colors.dart';

/// Enum representing different types of scores
enum ScoreType {
  health,
  readiness,
  activity;

  /// Get display name for the score type
  String get displayName {
    switch (this) {
      case ScoreType.health:
        return 'Health Score';
      case ScoreType.readiness:
        return 'Readiness';
      case ScoreType.activity:
        return 'Activity';
    }
  }

  /// Get accent color for the score type
  Color get accentColor {
    switch (this) {
      case ScoreType.health:
        return AppColors.healthPurple;
      case ScoreType.readiness:
        return AppColors.readinessBlue;
      case ScoreType.activity:
        return AppColors.activityGreen;
    }
  }

  /// Parse from string
  static ScoreType fromString(String value) {
    return ScoreType.values.firstWhere(
      (e) => e.name.toLowerCase() == value.toLowerCase(),
      orElse: () => ScoreType.health,
    );
  }
}
