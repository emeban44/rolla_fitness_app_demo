import 'package:flutter/material.dart';

/// Reusable grid widget for displaying score cards
class ScoresGrid extends StatelessWidget {
  final List<Widget> children;

  const ScoresGrid({
    super.key,
    required this.children,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      padding: const EdgeInsets.all(16),
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      childAspectRatio: 0.95,
      children: children,
    );
  }
}
