import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Extension to easily access theme colors
extension ThemeExtension on BuildContext {
  /// Get app colors based on current theme
  AppColorsExtension get colors => AppColorsExtension(this);
}

/// App colors extension that provides easy access to themed colors
class AppColorsExtension {
  final BuildContext context;

  AppColorsExtension(this.context);

  bool get _isDark => Theme.of(context).brightness == Brightness.dark;

  // Foreground colors (for text, icons, etc.) with opacity variants
  Color get foregroundPrimary => _isDark ? AppColors.darkTextPrimary : AppColors.lightTextPrimary;
  Color get foregroundSecondary => _isDark ? AppColors.darkTextSecondary : AppColors.lightTextSecondary;
  Color get foregroundMuted => foregroundPrimary.withValues(alpha: 0.7);
  Color get foregroundSubtle => foregroundPrimary.withValues(alpha: 0.6);
  Color get foregroundDisabled => foregroundPrimary.withValues(alpha: 0.3);
  Color get foregroundFaint => foregroundPrimary.withValues(alpha: 0.15);

  // Surface colors
  Color get surface => _isDark ? AppColors.darkSurface : AppColors.lightSurface;
  Color get background => _isDark ? AppColors.darkBackground : AppColors.lightBackground;
  Color get cardBackground => _isDark ? AppColors.darkCardBackground : AppColors.lightCardBackground;

  // Border and divider colors
  Color get border => _isDark ? AppColors.darkBorder : AppColors.lightBorder;
  Color get divider => _isDark ? AppColors.darkDivider : AppColors.lightDivider;

  // Grid and chart colors
  Color get gridLine => _isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.2);

  // Skeleton/loading colors
  Color get skeletonBase => _isDark ? Colors.white.withValues(alpha: 0.2) : Colors.grey.withValues(alpha: 0.3);
  Color get skeletonShimmer => _isDark ? Colors.white.withValues(alpha: 0.1) : Colors.grey.withValues(alpha: 0.2);

  // Decorative elements (dots, backgrounds, overlays)
  Color decorativeWithOpacity(double opacity) =>
      _isDark ? Colors.white.withValues(alpha: opacity) : Colors.grey.withValues(alpha: opacity);

  // Shadow colors
  Color get shadowLight => Colors.black.withValues(alpha: 0.05);
  Color get shadowMedium => _isDark
      ? Colors.black.withValues(alpha: 0.3)
      : Colors.black.withValues(alpha: 0.1);
  Color get shadowStrong => _isDark
      ? Colors.black.withValues(alpha: 0.15)
      : Colors.white.withValues(alpha: 0.8);

  // Accent colors
  Color get healthPurple => AppColors.healthPurple;
  Color get readinessBlue => AppColors.readinessBlue;
  Color get activityGreen => AppColors.activityGreen;

  // Status colors
  Color get error => AppColors.error;
  Color get warning => AppColors.warning;
  Color get info => AppColors.info;
  Color get success => AppColors.success;

  // Score colors
  Color get scoreGood => AppColors.scoreGood;
  Color get scoreModerate => AppColors.scoreModerate;
  Color get scoreNeutral => AppColors.scoreNeutral;

  // Helper methods
  Color getScoreColor(int? score) => AppColors.getScoreColor(score);
  Color getAccentColor(String scoreType) => AppColors.getAccentColor(scoreType);
}
