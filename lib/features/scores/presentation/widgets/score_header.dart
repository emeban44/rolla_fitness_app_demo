import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/score_type.dart';
import 'package:rolla_fitness_app_demo/features/scores/presentation/widgets/time_period_selector.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/timeframe.dart';

/// Reusable score header with title, info icon, and time period selector
/// Used consistently across all timeframes (1D, 7D, 30D, 1Y)
class ScoreHeader extends StatelessWidget {
  final ScoreType scoreType;
  final VoidCallback? onInfoTap;
  final DateTime selectedDate;
  final Timeframe timeframe;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool canGoNext;

  const ScoreHeader({
    super.key,
    required this.scoreType,
    this.onInfoTap,
    required this.selectedDate,
    required this.timeframe,
    required this.onPrevious,
    required this.onNext,
    required this.canGoNext,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 4, 0),
      child: Row(
        children: [
          // Title with info icon
          Text(
            scoreType.displayName,
            style: GoogleFonts.outfit(
              fontSize: 19,
              fontWeight: FontWeight.w400,
              height: 1.0,
              letterSpacing: 0,
              color: Theme.of(context).textTheme.bodyLarge?.color,
            ),
          ),
          const SizedBox(width: 6),
          if (onInfoTap != null)
            GestureDetector(
              onTap: onInfoTap,
              child: Container(
                width: 20,
                height: 20,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Theme.of(context)
                      .textTheme
                      .bodySmall
                      ?.color
                      ?.withValues(alpha: 0.15),
                ),
                child: Center(
                  child: Icon(
                    Icons.help_outline,
                    size: 14,
                    color: Theme.of(context)
                        .textTheme
                        .bodySmall
                        ?.color
                        ?.withValues(alpha: 0.7),
                  ),
                ),
              ),
            ),
          const Spacer(),
          // Time period selector
          TimePeriodSelector(
            selectedDate: selectedDate,
            timeframe: timeframe,
            onPrevious: onPrevious,
            onNext: onNext,
            canGoNext: canGoNext,
          ),
        ],
      ),
    );
  }
}
