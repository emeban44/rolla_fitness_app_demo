import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Reusable section description text
/// Used for description content in "How It Works?" and "About" sections
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
        color: Theme.of(context).textTheme.bodyLarge?.color?.withValues(alpha: 0.6),
      ),
    );
  }
}
