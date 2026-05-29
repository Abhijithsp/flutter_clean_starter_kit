import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTextField extends StatelessWidget {
  final String label;
  final String? hint;
  final String? helperText;
  final String? errorText;
  final TextEditingController? controller;
  final bool obscureText;
  final TextInputType keyboardType;
  final IconData? prefixIcon;
  final Widget? suffix;
  final int? maxLines;
  final int? maxLength;
  final bool readOnly;
  final VoidCallback? onTap;
  final ValueChanged<String>? onChanged;
  final List<TextInputFormatter>? inputFormatters;
  final bool autofocus;
  final TextInputAction textInputAction;
  final FocusNode? focusNode;
  final Color? focusedBorderColor;

  const AppTextField({
    super.key,
    required this.label,
    this.hint,
    this.helperText,
    this.errorText,
    this.controller,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.prefixIcon,
    this.suffix,
    this.maxLines = 1,
    this.maxLength,
    this.readOnly = false,
    this.onTap,
    this.onChanged,
    this.inputFormatters,
    this.autofocus = false,
    this.textInputAction = TextInputAction.next,
    this.focusNode,
    this.focusedBorderColor,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final activeColor = focusedBorderColor ?? Theme.of(context).primaryColor;

    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: maxLines != null && maxLines! > 1
          ? TextInputType.multiline
          : keyboardType,
      maxLines: obscureText ? 1 : maxLines,
      maxLength: maxLength,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      autofocus: autofocus,
      textInputAction: textInputAction,
      focusNode: focusNode,
      inputFormatters: inputFormatters,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: GoogleFonts.outfit(
          fontSize: 14,
          color: isDark ? Colors.white70 : Colors.grey.shade600,
        ),
        floatingLabelStyle: GoogleFonts.outfit(
          fontSize: 12,
          fontWeight: FontWeight.bold,
          color: activeColor,
        ),
        hintText: hint,
        hintStyle: GoogleFonts.outfit(
          fontSize: 13,
          color: isDark ? Colors.white30 : Colors.grey.shade400,
        ),
        helperText: helperText,
        errorText: errorText,
        prefixIcon: prefixIcon != null
            ? Icon(prefixIcon,
                size: 20, color: isDark ? Colors.white70 : Colors.grey.shade600)
            : null,
        suffixIcon: suffix,
        counterText: '',
        filled: true,
        fillColor: isDark
            ? Colors.black.withValues(alpha: 0.15)
            : Colors.white.withValues(alpha: 0.25),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.white30 : Colors.grey.shade400,
            width: 1.5,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: isDark ? Colors.white24 : Colors.grey.shade300,
            width: 1.5,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: BorderSide(
            color: activeColor,
            width: 2.0,
          ),
        ),
      ),
    );
  }
}

// ─── Password field with show/hide toggle ───────────────────────────────────

class AppPasswordField extends StatefulWidget {
  final String label;
  final TextEditingController? controller;
  final String? errorText;
  final ValueChanged<String>? onChanged;
  final Color? focusedBorderColor;

  const AppPasswordField({
    super.key,
    this.label = 'Password',
    this.controller,
    this.errorText,
    this.onChanged,
    this.focusedBorderColor,
  });

  @override
  State<AppPasswordField> createState() => _AppPasswordFieldState();
}

class _AppPasswordFieldState extends State<AppPasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: widget.label,
      controller: widget.controller,
      obscureText: _obscure,
      errorText: widget.errorText,
      onChanged: widget.onChanged,
      prefixIcon: Icons.lock_outline,
      focusedBorderColor: widget.focusedBorderColor,
      suffix: IconButton(
        icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
    );
  }
}

// ─── Search bar ─────────────────────────────────────────────────────────────

class AppSearchField extends StatelessWidget {
  final String hint;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onClear;

  const AppSearchField({
    super.key,
    this.hint = 'Search...',
    this.controller,
    this.onChanged,
    this.onClear,
  });

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      label: '',
      hint: hint,
      controller: controller,
      prefixIcon: Icons.search,
      keyboardType: TextInputType.text,
      textInputAction: TextInputAction.search,
      onChanged: onChanged,
      suffix: controller != null && (controller!.text.isNotEmpty)
          ? IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                controller!.clear();
                onClear?.call();
              },
            )
          : null,
    );
  }
}
