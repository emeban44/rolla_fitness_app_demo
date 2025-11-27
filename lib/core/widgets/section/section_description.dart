import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rolla_fitness_app_demo/core/theme/theme_extensions.dart';

/// Reusable section description text.
class SectionDescription extends StatelessWidget {
  final String text;

  const SectionDescription({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: GoogleFonts.outfit(
        fontSize: 16,
        fontWeight: FontWeight.w400,
        height: 22 / 16, // 22px line height / 16px font size = 1.375
        letterSpacing: 0,
        color: context.colors.foregroundSubtle,
      ),
    );
  }
}
