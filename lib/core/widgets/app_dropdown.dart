import 'package:flutter/material.dart';

class AppDropdown<T> extends StatelessWidget {
  final String label;
  final T? value;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?>? onChanged;
  final String? hint;
  final String? errorText;
  final IconData? prefixIcon;

  const AppDropdown({
    super.key,
    required this.label,
    required this.items,
    this.value,
    this.onChanged,
    this.hint,
    this.errorText,
    this.prefixIcon,
  });

  @override
  Widget build(BuildContext context) {
    final cs = Theme.of(context).colorScheme;

    return DropdownButtonFormField<T>(
      initialValue: value,
      onChanged: onChanged,
      items: items,
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        errorText: errorText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
      ),
      borderRadius: BorderRadius.circular(12),
      dropdownColor: cs.surfaceContainerHigh,
      icon: const Icon(Icons.keyboard_arrow_down_rounded),
      isExpanded: true,
    );
  }
}

// ─── Segmented picker (replaces classic tab-row pattern) ────────────────────

class AppSegmentedPicker<T> extends StatelessWidget {
  final Map<T, Widget> segments;
  final Set<T> selected;
  final ValueChanged<Set<T>> onSelectionChanged;

  const AppSegmentedPicker({
    super.key,
    required this.segments,
    required this.selected,
    required this.onSelectionChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<T>(
      segments: segments.entries
          .map((e) => ButtonSegment<T>(value: e.key, label: e.value))
          .toList(),
      selected: selected,
      onSelectionChanged: onSelectionChanged,
      showSelectedIcon: false,
    );
  }
}
