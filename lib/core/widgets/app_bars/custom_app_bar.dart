import 'package:flutter/material.dart';
import 'package:rolla_fitness_app_demo/core/widgets/theme_switcher/theme_switcher.dart';

/// Custom app bar with theme switcher
class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final String title;
  final Color? backgroundColor;
  final double? elevation;

  const CustomAppBar({
    super.key,
    required this.title,
    this.backgroundColor,
    this.elevation,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(title),
      backgroundColor: backgroundColor,
      elevation: elevation,
      actions: const [ThemeSwitcher()],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
