import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/core/theme/theme_extensions.dart';

/// Displays a subtle, centered insight note for the selected day
class DailyInsightNote extends StatelessWidget {
  final String text;

  const DailyInsightNote({
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Text(
          text,
          textAlign: TextAlign.center,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            color: context.colors.foregroundSubtle,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
    );
  }
}
