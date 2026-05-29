import 'package:flutter/material.dart';

enum AppButtonVariant { filled, outlined, text, tonal, elevated }

enum AppButtonSize { small, medium, large }

class AppButton extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;
  final AppButtonVariant variant;
  final AppButtonSize size;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final bool isLoading;
  final bool fullWidth;

  const AppButton({
    super.key,
    required this.label,
    this.onPressed,
    this.variant = AppButtonVariant.filled,
    this.size = AppButtonSize.medium,
    this.prefixIcon,
    this.suffixIcon,
    this.isLoading = false,
    this.fullWidth = false,
  });

  EdgeInsets get _padding {
    switch (size) {
      case AppButtonSize.small:
        return const EdgeInsets.symmetric(horizontal: 16, vertical: 8);
      case AppButtonSize.medium:
        return const EdgeInsets.symmetric(horizontal: 24, vertical: 12);
      case AppButtonSize.large:
        return const EdgeInsets.symmetric(horizontal: 32, vertical: 16);
    }
  }

  double get _fontSize {
    switch (size) {
      case AppButtonSize.small:
        return 13;
      case AppButtonSize.medium:
        return 14;
      case AppButtonSize.large:
        return 16;
    }
  }

  Widget _buildChild(BuildContext context) {
    if (isLoading) {
      return SizedBox(
        width: 18,
        height: 18,
        child: CircularProgressIndicator(
          strokeWidth: 2,
          color: variant == AppButtonVariant.filled
              ? Theme.of(context).colorScheme.onPrimary
              : Theme.of(context).colorScheme.primary,
        ),
      );
    }
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (prefixIcon != null) ...[
          Icon(prefixIcon, size: _fontSize + 4),
          const SizedBox(width: 8),
        ],
        Text(label, style: TextStyle(fontSize: _fontSize, fontWeight: FontWeight.w600)),
        if (suffixIcon != null) ...[
          const SizedBox(width: 8),
          Icon(suffixIcon, size: _fontSize + 4),
        ],
      ],
    );
  }

  ButtonStyle _baseStyle(BuildContext context) {
    return ButtonStyle(
      padding: WidgetStateProperty.all(_padding),
      shape: WidgetStateProperty.all(
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Widget button;

    switch (variant) {
      case AppButtonVariant.filled:
        button = ElevatedButton(
          onPressed: isLoading ? null : onPressed,
          style: _baseStyle(context),
          child: _buildChild(context),
        );
        break;
      case AppButtonVariant.outlined:
        button = OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: _baseStyle(context),
          child: _buildChild(context),
        );
        break;
      case AppButtonVariant.text:
        button = TextButton(
          onPressed: isLoading ? null : onPressed,
          style: _baseStyle(context),
          child: _buildChild(context),
        );
        break;
      case AppButtonVariant.tonal:
        button = FilledButton.tonal(
          onPressed: isLoading ? null : onPressed,
          style: _baseStyle(context),
          child: _buildChild(context),
        );
        break;
      case AppButtonVariant.elevated:
        button = FilledButton(
          onPressed: isLoading ? null : onPressed,
          style: _baseStyle(context),
          child: _buildChild(context),
        );
        break;
    }

    return fullWidth ? SizedBox(width: double.infinity, child: button) : button;
  }
}
