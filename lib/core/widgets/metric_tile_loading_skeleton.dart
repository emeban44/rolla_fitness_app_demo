import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/core/widgets/loading_skeleton.dart';

/// Loading skeleton for a metric tile
/// Matches the actual metric tile structure with animated progress bar
class MetricTileLoadingSkeleton extends StatefulWidget {
  final Color color;

  const MetricTileLoadingSkeleton({
    super.key,
    required this.color,
  });

  @override
  State<MetricTileLoadingSkeleton> createState() => _MetricTileLoadingSkeletonState();
}

class _MetricTileLoadingSkeletonState extends State<MetricTileLoadingSkeleton> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    )..repeat();

    _animation = Tween<double>(begin: 0.0, end: 1.0).animate(
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
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              // Icon skeleton (matches emoji size)
              LoadingSkeleton(
                width: 24,
                height: 24,
                borderRadius: BorderRadius.circular(4),
              ),
              const SizedBox(width: 12),
              // Title skeleton
              Expanded(
                child: LoadingSkeleton(
                  width: 100,
                  height: 16,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
              // Value skeleton
              LoadingSkeleton(
                width: 50,
                height: 16,
                borderRadius: BorderRadius.circular(4),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Animated progress bar
          AnimatedBuilder(
            animation: _animation,
            builder: (context, child) {
              return ClipRRect(
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(4),
                  topRight: Radius.circular(4),
                ),
                child: SizedBox(
                  height: 6,
                  child: Stack(
                    children: [
                      // Background (gray)
                      Container(
                        color: Theme.of(context).brightness == Brightness.dark
                            ? Colors.white.withValues(alpha: 0.1)
                            : Colors.grey.withValues(alpha: 0.2),
                      ),
                      // Animated loading bar
                      FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: _animation.value,
                        child: Container(
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                widget.color.withValues(alpha: 0.3),
                                widget.color,
                                widget.color.withValues(alpha: 0.3),
                              ],
                              stops: const [0.0, 0.5, 1.0],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
