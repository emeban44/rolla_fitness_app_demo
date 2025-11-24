import 'package:flutter/material.dart';

/// App color constants for light and dark themes
class AppColors {
  AppColors._();

  // Score type accent colors
  static const Color healthPurple = Color(0xFF8B5CF6);
  static const Color readinessBlue = Color(0xFF3B82F6);
  static const Color activityGreen = Color(0xFF10B981);

  // Score progress colors
  static const Color scoreGood = Color(0xFF10B981); // 80+
  static const Color scoreModerate = Color(0xFF3B82F6); // 50-79
  static const Color scoreNeutral = Color(0xFF9CA3AF); // 0-49

  // Light theme colors
  static const Color lightBackground = Color(0xFFFAFAFA);
  static const Color lightSurface = Color(0xFFFFFFFF);
  static const Color lightCardBackground = Color(0xFFFFFFFF);
  static const Color lightTextPrimary = Color(0xFF1F2937);
  static const Color lightTextSecondary = Color(0xFF6B7280);
  static const Color lightDivider = Color(0xFFE5E7EB);
  static const Color lightBorder = Color(0xFFE5E7EB);

  // Dark theme colors
  static const Color darkBackground = Color(0xFF111827);
  static const Color darkSurface = Color(0xFF1F2937);
  static const Color darkCardBackground = Color(0xFF1F2937);
  static const Color darkTextPrimary = Color(0xFFF9FAFB);
  static const Color darkTextSecondary = Color(0xFF9CA3AF);
  static const Color darkDivider = Color(0xFF374151);
  static const Color darkBorder = Color(0xFF374151);

  // Shared colors
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  static const Color success = Color(0xFF10B981);

  /// Get color based on score value
  static Color getScoreColor(int? score) {
    if (score == null) return scoreNeutral;
    if (score >= 80) return scoreGood;
    if (score >= 50) return scoreModerate;
    return scoreNeutral;
  }

  /// Get accent color for score type
  static Color getAccentColor(String scoreType) {
    switch (scoreType.toLowerCase()) {
      case 'health':
        return healthPurple;
      case 'readiness':
        return readinessBlue;
      case 'activity':
        return activityGreen;
      default:
        return scoreNeutral;
    }
  }
}
