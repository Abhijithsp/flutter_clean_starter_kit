import 'package:flutter/material.dart';

enum AppBadgeVariant { primary, success, warning, error, info, neutral }

class AppBadge extends StatelessWidget {
  final String label;
  final AppBadgeVariant variant;
  final IconData? icon;

  const AppBadge({
    super.key,
    required this.label,
    this.variant = AppBadgeVariant.primary,
    this.icon,
  });

  Color _bgColor(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    switch (variant) {
      case AppBadgeVariant.primary:
        return cs.primaryContainer;
      case AppBadgeVariant.success:
        return Colors.green.shade100;
      case AppBadgeVariant.warning:
        return Colors.orange.shade100;
      case AppBadgeVariant.error:
        return cs.errorContainer;
      case AppBadgeVariant.info:
        return Colors.blue.shade100;
      case AppBadgeVariant.neutral:
        return cs.surfaceContainerHighest;
    }
  }

  Color _fgColor(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    switch (variant) {
      case AppBadgeVariant.primary:
        return cs.onPrimaryContainer;
      case AppBadgeVariant.success:
        return Colors.green.shade800;
      case AppBadgeVariant.warning:
        return Colors.orange.shade800;
      case AppBadgeVariant.error:
        return cs.onErrorContainer;
      case AppBadgeVariant.info:
        return Colors.blue.shade800;
      case AppBadgeVariant.neutral:
        return cs.onSurfaceVariant;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: _bgColor(context),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: _fgColor(context)),
            const SizedBox(width: 4),
          ],
          Text(
            label,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: _fgColor(context),
            ),
          ),
        ],
      ),
    );
  }
}
