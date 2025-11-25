import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/core/theme/app_colors.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/metric_info.dart';

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

  /// Get info description for the score type
  MetricInfo getInfo() {
    switch (this) {
      case ScoreType.health:
        return const MetricInfo(
          title: 'How It Works?',
          description:
              'Your Health Score brings rest and activity together into one number, showing how balanced your day is. It\'s the average of your Readiness and Activity scores.',
          baselineInfo:
              'A score of 80 represents your personal baseline. This is the point where your daily metrics align with your 30-day averages. Get above 80 and you\'re doing better than your typical day.',
        );
      case ScoreType.readiness:
        return const MetricInfo(
          title: 'How It Works?',
          description:
              'Your Readiness Score shows how well your body has recovered and how prepared you are to perform today. It\'s based on your sleep, resting heart rate, and heart rate variability.',
          baselineInfo:
              'A score of 80 is your personal baseline. The point where your body feels balanced and ready for a normal day. Higher scores mean you\'re recharged and primed for activity. Lower scores suggest your body needs more rest, better sleep, or lighter movement.',
        );
      case ScoreType.activity:
        return const MetricInfo(
          title: 'How It Works?',
          description:
              'Your Activity Score measures how much you\'ve moved throughout the day and how consistent your activity has been. It looks at your steps, active points, and move hours to capture both effort and frequency.',
          baselineInfo:
              'A score of 80 represents your personal baseline, your typical daily activity over the past 30 days. Higher scores mean you\'ve gone above your usual pace or intensity. Lower scores show lighter movement or more rest than normal.',
        );
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
