import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// App typography using Outfit font
class AppTypography {
  AppTypography._();

  /// Base text theme using Outfit font
  static TextTheme getTextTheme(bool isDark) {
    final baseColor = isDark ? Colors.white : Colors.black;

    return GoogleFonts.outfitTextTheme().copyWith(
      // Display
      displayLarge: GoogleFonts.outfit(
        fontSize: 57,
        fontWeight: FontWeight.w400,
        color: baseColor,
      ),
      displayMedium: GoogleFonts.outfit(
        fontSize: 45,
        fontWeight: FontWeight.w400,
        color: baseColor,
      ),
      displaySmall: GoogleFonts.outfit(
        fontSize: 36,
        fontWeight: FontWeight.w400,
        color: baseColor,
      ),

      // Headline
      headlineLarge: GoogleFonts.outfit(
        fontSize: 32,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      headlineMedium: GoogleFonts.outfit(
        fontSize: 28,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      headlineSmall: GoogleFonts.outfit(
        fontSize: 24,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),

      // Title
      titleLarge: GoogleFonts.outfit(
        fontSize: 22,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      titleMedium: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),
      titleSmall: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: baseColor,
      ),

      // Body
      bodyLarge: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        color: baseColor,
      ),
      bodyMedium: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w400,
        color: baseColor,
      ),
      bodySmall: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w400,
        color: baseColor,
      ),

      // Label
      labelLarge: GoogleFonts.outfit(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),
      labelMedium: GoogleFonts.outfit(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),
      labelSmall: GoogleFonts.outfit(
        fontSize: 11,
        fontWeight: FontWeight.w500,
        color: baseColor,
      ),
    );
  }

  /// Score value text style (large circular gauge number)
  static TextStyle scoreValueLarge(BuildContext context) {
    return GoogleFonts.outfit(
      fontSize: 48,
      fontWeight: FontWeight.w700,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  /// Score value text style (card)
  static TextStyle scoreValueCard(BuildContext context) {
    return GoogleFonts.outfit(
      fontSize: 32,
      fontWeight: FontWeight.w700,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );
  }

  /// Metric value text style
  static TextStyle metricValue(BuildContext context) {
    return GoogleFonts.outfit(
      fontSize: 18,
      fontWeight: FontWeight.w600,
      color: Theme.of(context).textTheme.bodyLarge?.color,
    );
  }
}
