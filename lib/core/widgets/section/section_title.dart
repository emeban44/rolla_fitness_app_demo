import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rolla_fitness_app_demo/core/theme/theme_extensions.dart';

/// Reusable section title with optional info icon.
class SectionTitle extends StatelessWidget {
  final String title;
  final VoidCallback? onInfoTap;

  const SectionTitle({
    super.key,
    required this.title,
    this.onInfoTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          title,
          style: GoogleFonts.outfit(
            fontSize: 19,
            fontWeight: FontWeight.w400,
            height: 1.0,
            letterSpacing: 0,
            color: context.colors.foregroundPrimary,
          ),
        ),
        if (onInfoTap != null) ...[
          const SizedBox(width: 6),
          GestureDetector(
            onTap: onInfoTap,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: context.colors.foregroundFaint,
              ),
              child: Center(
                child: Icon(
                  Icons.help_outline,
                  size: 14,
                  color: context.colors.foregroundMuted,
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
