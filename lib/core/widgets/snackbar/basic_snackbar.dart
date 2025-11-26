import 'package:flutter/material.dart';

/// Factory function that returns a custom SnackBar using [_BasicSnackbarContent].
SnackBar basicSnackbar({
  required BuildContext context,
  required String title,
  Widget? leading,
  SnackbarVariant variant = SnackbarVariant.error,
}) {
  final effectiveLeading = leading ?? variant.icon(context);
  return SnackBar(
    elevation: 0.0,
    duration: const Duration(seconds: 2),
    backgroundColor: Colors.transparent,
    padding: const EdgeInsets.all(16),
    content: _BasicSnackbarContent(
      leading: effectiveLeading,
      title: title,
    ),
  );
}

enum SnackbarVariant {
  success,
  error;

  Widget icon(BuildContext context) {
    switch (this) {
      case SnackbarVariant.success:
        return Icon(Icons.check);
      case SnackbarVariant.error:
        return Icon(Icons.info_outline);
    }
  }
}

/// The content widget shown inside the custom SnackBar.
class _BasicSnackbarContent extends StatelessWidget {
  const _BasicSnackbarContent({
    required this.leading,
    required this.title,
  });

  final Widget leading;
  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.circular(16),
        boxShadow: const [
          BoxShadow(
            color: Colors.black12,
            spreadRadius: 1.0,
            blurRadius: 10.0,
            offset: Offset(0.0, 1.0),
          ),
        ],
      ),
      child: Row(
        children: [
          leading,
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),
        ],
      ),
    );
  }
}
