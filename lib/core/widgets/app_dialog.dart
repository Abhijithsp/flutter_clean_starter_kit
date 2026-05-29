import 'package:flutter/material.dart';
import 'app_button.dart';

class AppDialog extends StatelessWidget {
  final String title;
  final String? message;
  final Widget? content;
  final String confirmLabel;
  final String? cancelLabel;
  final VoidCallback? onConfirm;
  final VoidCallback? onCancel;
  final IconData? icon;
  final Color? iconColor;

  const AppDialog({
    super.key,
    required this.title,
    this.message,
    this.content,
    this.confirmLabel = 'Confirm',
    this.cancelLabel,
    this.onConfirm,
    this.onCancel,
    this.icon,
    this.iconColor,
  });

  static Future<T?> show<T>(
    BuildContext context, {
    required String title,
    String? message,
    Widget? content,
    String confirmLabel = 'Confirm',
    String? cancelLabel,
    VoidCallback? onConfirm,
    VoidCallback? onCancel,
    IconData? icon,
    Color? iconColor,
  }) {
    return showDialog<T>(
      context: context,
      builder: (_) => AppDialog(
        title: title,
        message: message,
        content: content,
        confirmLabel: confirmLabel,
        cancelLabel: cancelLabel,
        onConfirm: onConfirm,
        onCancel: onCancel,
        icon: icon,
        iconColor: iconColor,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final accent = iconColor ?? cs.primary;
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      icon: icon != null
          ? Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: accent.withValues(alpha: 0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: accent, size: 28),
            )
          : null,
      title: Text(title,
          style: const TextStyle(fontWeight: FontWeight.w700),
          textAlign: TextAlign.center),
      content: content ??
          (message != null
              ? Text(message!,
                  textAlign: TextAlign.center,
                  style: TextStyle(color: cs.onSurfaceVariant))
              : null),
      actionsAlignment: MainAxisAlignment.center,
      actionsPadding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      actions: [
        if (cancelLabel != null)
          AppButton(
            label: cancelLabel!,
            variant: AppButtonVariant.outlined,
            onPressed: () {
              Navigator.of(context).pop();
              onCancel?.call();
            },
          ),
        AppButton(
          label: confirmLabel,
          variant: AppButtonVariant.filled,
          onPressed: () {
            Navigator.of(context).pop();
            onConfirm?.call();
          },
        ),
      ],
    );
  }
}
