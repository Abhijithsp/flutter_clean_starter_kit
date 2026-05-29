import 'package:flutter/material.dart';

enum AppSnackbarVariant { success, error, warning, info }

class AppSnackbar {
  // ─── Primary method (uses BuildContext — must NOT be called after await) ──
  static void show(
    BuildContext context, {
    required String message,
    AppSnackbarVariant variant = AppSnackbarVariant.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
  }) {
    final messenger = ScaffoldMessenger.of(context);
    final cs = Theme.of(context).colorScheme;
    _showWithState(
      messenger,
      cs: cs,
      message: message,
      variant: variant,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  // ─── Async-safe method: capture messenger + cs before await, then call this ─
  static void showWithMessenger(
    ScaffoldMessengerState messenger, {
    required String message,
    AppSnackbarVariant variant = AppSnackbarVariant.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
    ColorScheme? cs,
  }) {
    _showWithState(
      messenger,
      cs: cs,
      message: message,
      variant: variant,
      actionLabel: actionLabel,
      onAction: onAction,
      duration: duration,
    );
  }

  static void _showWithState(
    ScaffoldMessengerState messenger, {
    required String message,
    AppSnackbarVariant variant = AppSnackbarVariant.info,
    String? actionLabel,
    VoidCallback? onAction,
    Duration duration = const Duration(seconds: 3),
    ColorScheme? cs,
  }) {
    Color bgColor;
    Color fgColor;
    IconData icon;

    switch (variant) {
      case AppSnackbarVariant.success:
        bgColor = Colors.green.shade700;
        fgColor = Colors.white;
        icon = Icons.check_circle_outline;
        break;
      case AppSnackbarVariant.error:
        bgColor = cs?.error ?? Colors.red.shade700;
        fgColor = cs?.onError ?? Colors.white;
        icon = Icons.error_outline;
        break;
      case AppSnackbarVariant.warning:
        bgColor = Colors.orange.shade700;
        fgColor = Colors.white;
        icon = Icons.warning_amber_outlined;
        break;
      case AppSnackbarVariant.info:
        bgColor = cs?.inverseSurface ?? Colors.grey.shade800;
        fgColor = cs?.onInverseSurface ?? Colors.white;
        icon = Icons.info_outline;
        break;
    }

    messenger.showSnackBar(
      SnackBar(
        duration: duration,
        backgroundColor: bgColor,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        margin: const EdgeInsets.all(16),
        content: Row(
          children: [
            Icon(icon, color: fgColor, size: 20),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                message,
                style: TextStyle(color: fgColor, fontWeight: FontWeight.w500),
              ),
            ),
          ],
        ),
        action: actionLabel != null
            ? SnackBarAction(
                label: actionLabel,
                textColor: fgColor,
                onPressed: onAction ?? () {},
              )
            : null,
      ),
    );
  }
}
