import 'package:flutter/material.dart';

/// Animated loading skeleton for trend charts
/// Shows animated bars that shimmer to indicate loading
class ChartLoadingSkeleton extends StatefulWidget {
  final double height;

  const ChartLoadingSkeleton({
    super.key,
    this.height = 200,
  });

  @override
  State<ChartLoadingSkeleton> createState() => _ChartLoadingSkeletonState();
}

class _ChartLoadingSkeletonState extends State<ChartLoadingSkeleton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: -1.0, end: 2.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final baseColor = isDark ? const Color(0xFF374151) : const Color(0xFFE5E7EB);
    final highlightColor =
        isDark ? const Color(0xFF4B5563) : const Color(0xFFF3F4F6);

    return Container(
      height: widget.height,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: AnimatedBuilder(
        animation: _animation,
        builder: (context, child) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: List.generate(
              8,
              (index) {
                // Create varying heights for bars
                final heights = [0.6, 0.8, 0.5, 0.9, 0.7, 0.6, 0.8, 0.5];
                final barHeight = widget.height * heights[index % heights.length];

                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      height: barHeight,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(4),
                        gradient: LinearGradient(
                          begin: Alignment.centerLeft,
                          end: Alignment.centerRight,
                          colors: [baseColor, highlightColor, baseColor],
                          stops: [
                            _animation.value - 0.3,
                            _animation.value,
                            _animation.value + 0.3,
                          ].map((stop) => stop.clamp(0.0, 1.0)).toList(),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }
}
