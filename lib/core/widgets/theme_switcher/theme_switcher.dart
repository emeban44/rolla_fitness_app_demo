import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rolla_fitness_app_demo/core/theme/theme_cubit.dart';

/// Reusable theme switcher action widget.
class ThemeSwitcher extends StatelessWidget {
  const ThemeSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextButton.icon(
      onPressed: context.read<ThemeCubit>().toggleTheme,
      icon: Icon(
        isDark ? Icons.light_mode : Icons.dark_mode,
        color: isDark ? Colors.white : Colors.black,
        size: 20,
      ),
      label: Text(
        isDark ? 'Light' : 'Dark',
        style: Theme.of(context).textTheme.bodyMedium,
      ),
    );
  }
}
