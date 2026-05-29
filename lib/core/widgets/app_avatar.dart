import 'package:flutter/material.dart';

class AppAvatar extends StatelessWidget {
  final String? imageUrl;
  final String? initials;
  final double size;
  final Color? backgroundColor;
  final VoidCallback? onTap;
  final bool showOnlineIndicator;

  const AppAvatar({
    super.key,
    this.imageUrl,
    this.initials,
    this.size = 40,
    this.backgroundColor,
    this.onTap,
    this.showOnlineIndicator = false,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final bg = backgroundColor ?? cs.primaryContainer;

    Widget avatar = CircleAvatar(
      radius: size / 2,
      backgroundColor: bg,
      backgroundImage: imageUrl != null ? NetworkImage(imageUrl!) : null,
      child: imageUrl == null
          ? Text(
              initials ?? '?',
              style: TextStyle(
                fontSize: size * 0.38,
                fontWeight: FontWeight.bold,
                color: cs.onPrimaryContainer,
              ),
            )
          : null,
    );

    if (showOnlineIndicator) {
      avatar = Stack(
        children: [
          avatar,
          Positioned(
            right: 0,
            bottom: 0,
            child: Container(
              width: size * 0.28,
              height: size * 0.28,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: cs.surface, width: 2),
              ),
            ),
          ),
        ],
      );
    }

    if (onTap != null) {
      return GestureDetector(onTap: onTap, child: avatar);
    }
    return avatar;
  }
}

// ─── Avatar Group ────────────────────────────────────────────────────────────

class AppAvatarGroup extends StatelessWidget {
  final List<String> initials;
  final double size;
  final int maxVisible;

  const AppAvatarGroup({
    super.key,
    required this.initials,
    this.size = 36,
    this.maxVisible = 4,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;
    final visible = initials.take(maxVisible).toList();
    final overflow = initials.length - maxVisible;

    return SizedBox(
      height: size,
      width: (visible.length + (overflow > 0 ? 1 : 0)) * (size * 0.7) + size * 0.3,
      child: Stack(
        children: [
          ...visible.asMap().entries.map((e) => Positioned(
                left: e.key * (size * 0.7),
                child: Container(
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: cs.surface, width: 2),
                  ),
                  child: AppAvatar(initials: e.value, size: size),
                ),
              )),
          if (overflow > 0)
            Positioned(
              left: visible.length * (size * 0.7),
              child: Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: cs.surface, width: 2),
                ),
                child: AppAvatar(
                  initials: '+$overflow',
                  size: size,
                  backgroundColor: cs.secondaryContainer,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
