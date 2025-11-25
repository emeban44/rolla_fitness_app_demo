import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rolla_fitness_app_demo/features/scores/domain/entities/timeframe.dart';

/// Time period selector with navigation chevrons
/// Shows single date for 1D, date range for 7D/30D/1Y
class TimePeriodSelector extends StatelessWidget {
  final DateTime selectedDate;
  final Timeframe timeframe;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final bool canGoPrevious;
  final bool canGoNext;

  const TimePeriodSelector({
    super.key,
    required this.selectedDate,
    required this.timeframe,
    required this.onPrevious,
    required this.onNext,
    this.canGoPrevious = true,
    this.canGoNext = true,
  });

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyLarge?.color;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Previous button
        IconButton(
          onPressed: canGoPrevious ? onPrevious : null,
          icon: Icon(
            Icons.chevron_left,
            color: canGoPrevious ? textColor : textColor?.withValues(alpha: 0.3),
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),

        const SizedBox(width: 12),

        // Date/period text
        Text(
          _getDateRangeText(),
          style: GoogleFonts.outfit(
            fontSize: 16,
            fontWeight: FontWeight.w400,
            height: 1.0,
            letterSpacing: 0,
            color: textColor,
          ),
        ),

        const SizedBox(width: 12),

        // Next button
        IconButton(
          onPressed: canGoNext ? onNext : null,
          icon: Icon(
            Icons.chevron_right,
            color: canGoNext ? textColor : textColor?.withValues(alpha: 0.3),
          ),
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints(),
        ),
      ],
    );
  }

  String _getDateRangeText() {
    switch (timeframe) {
      case Timeframe.oneDay:
        // Single date: "18 May"
        return DateFormat('d MMM').format(selectedDate);

      case Timeframe.sevenDays:
        // 7-day range ending on selectedDate
        final startDate = selectedDate.subtract(const Duration(days: 6));
        return '${DateFormat('d MMM').format(startDate)} - ${DateFormat('d MMM').format(selectedDate)}';

      case Timeframe.thirtyDays:
        // 30-day range ending on selectedDate
        final startDate = selectedDate.subtract(const Duration(days: 29));
        return '${DateFormat('d MMM').format(startDate)} - ${DateFormat('d MMM').format(selectedDate)}';

      case Timeframe.oneYear:
        // 1-year range ending on selectedDate
        final startDate = DateTime(selectedDate.year - 1, selectedDate.month, selectedDate.day);
        return '${DateFormat('d MMM yyyy').format(startDate)} - ${DateFormat('d MMM yyyy').format(selectedDate)}';
    }
  }
}
