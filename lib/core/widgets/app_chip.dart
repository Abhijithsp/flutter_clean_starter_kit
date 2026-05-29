import 'package:flutter/material.dart';

class AppChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback? onTap;
  final VoidCallback? onDeleted;
  final Color? color;

  const AppChip({
    super.key,
    required this.label,
    this.icon,
    this.selected = false,
    this.onTap,
    this.onDeleted,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    if (onDeleted != null) {
      return InputChip(
        label: Text(label),
        avatar: icon != null ? Icon(icon, size: 16) : null,
        selected: selected,
        onPressed: onTap,
        onDeleted: onDeleted,
        backgroundColor: color?.withValues(alpha: 0.1),
      );
    }

    if (selected) {
      return FilterChip(
        label: Text(label),
        avatar: icon != null ? Icon(icon, size: 16) : null,
        selected: selected,
        onSelected: onTap != null ? (_) => onTap!() : null,
        selectedColor: color ?? cs.primaryContainer,
        checkmarkColor: cs.onPrimaryContainer,
      );
    }

    return ActionChip(
      label: Text(label),
      avatar: icon != null ? Icon(icon, size: 16) : null,
      onPressed: onTap,
      backgroundColor: color?.withValues(alpha: 0.1),
    );
  }
}

// ─── Chip filter group ───────────────────────────────────────────────────────

class AppChipGroup extends StatefulWidget {
  final List<String> options;
  final bool multiSelect;
  final ValueChanged<List<String>>? onChanged;

  const AppChipGroup({
    super.key,
    required this.options,
    this.multiSelect = false,
    this.onChanged,
  });

  @override
  State<AppChipGroup> createState() => _AppChipGroupState();
}

class _AppChipGroupState extends State<AppChipGroup> {
  final Set<String> _selected = {};

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: widget.options.map((option) {
        final isSelected = _selected.contains(option);
        return FilterChip(
          label: Text(option),
          selected: isSelected,
          onSelected: (val) {
            setState(() {
              if (!widget.multiSelect) _selected.clear();
              if (val) {
                _selected.add(option);
              } else {
                _selected.remove(option);
              }
            });
            widget.onChanged?.call(_selected.toList());
          },
        );
      }).toList(),
    );
  }
}
