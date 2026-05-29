import 'package:flutter/material.dart';
import 'app_avatar.dart';
import 'app_badge.dart';

class AppListTile extends StatelessWidget {
  final String title;
  final String? subtitle;
  final Widget? leading;
  final Widget? trailing;
  final VoidCallback? onTap;
  final bool showDivider;
  final Color? tileColor;

  const AppListTile({
    super.key,
    required this.title,
    this.subtitle,
    this.leading,
    this.trailing,
    this.onTap,
    this.showDivider = false,
    this.tileColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ListTile(
          title: Text(title,
              style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 15)),
          subtitle: subtitle != null
              ? Text(subtitle!,
                  style: TextStyle(
                      fontSize: 13,
                      color: Theme.of(context).colorScheme.onSurfaceVariant))
              : null,
          leading: leading,
          trailing: trailing ??
              (onTap != null
                  ? Icon(Icons.chevron_right,
                      color: Theme.of(context).colorScheme.onSurfaceVariant)
                  : null),
          onTap: onTap,
          tileColor: tileColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        if (showDivider)
          const Divider(height: 1, indent: 16, endIndent: 16),
      ],
    );
  }
}

// ─── Contact-style list tile ─────────────────────────────────────────────────

class AppContactTile extends StatelessWidget {
  final String name;
  final String detail;
  final String initials;
  final AppBadgeVariant? statusVariant;
  final String? statusLabel;
  final VoidCallback? onTap;

  const AppContactTile({
    super.key,
    required this.name,
    required this.detail,
    required this.initials,
    this.statusVariant,
    this.statusLabel,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return AppListTile(
      title: name,
      subtitle: detail,
      leading: AppAvatar(initials: initials, showOnlineIndicator: true),
      trailing: statusLabel != null
          ? AppBadge(
              label: statusLabel!,
              variant: statusVariant ?? AppBadgeVariant.neutral,
            )
          : null,
      onTap: onTap,
    );
  }
}
