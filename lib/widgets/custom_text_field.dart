import 'package:flutter/material.dart';
import '../constants.dart';

class CustomTextField extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String? Function(String?)? validator;
  final bool obscureText;
  final TextInputType keyboardType;
  final String? hintText;
  final Widget? prefixIcon;
  final bool enabled;
  final bool mono;

  const CustomTextField({
    super.key,
    required this.controller,
    required this.label,
    this.validator,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.hintText,
    this.prefixIcon,
    this.enabled = true,
    this.mono = false,
  });

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  late bool _obscureText;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          widget.label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 15,
            height: 20 / 15,
          ),
        ),
        const SizedBox(height: AppSpacing.xs),
        TextFormField(
          controller: widget.controller,
          validator: widget.validator,
          obscureText: _obscureText,
          keyboardType: widget.keyboardType,
          enabled: widget.enabled,
          style: theme.textTheme.bodyLarge?.copyWith(
            color: AppColors.textPrimary,
            fontFamily: widget.mono ? AppFonts.mono : AppFonts.sans,
            fontWeight: widget.mono ? FontWeight.w600 : FontWeight.normal,
          ),
          decoration: InputDecoration(
            hintText: widget.hintText,
            hintStyle: theme.textTheme.bodyLarge?.copyWith(color: AppColors.textSecondary),
            prefixIcon: widget.prefixIcon,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _obscureText ? Icons.visibility_off : Icons.visibility,
                      color: AppColors.textSecondary,
                    ),
                    onPressed: () => setState(() => _obscureText = !_obscureText),
                  )
                : null,
            filled: true,
            fillColor: AppColors.surface,
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: AppColors.border, width: 1.5),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: AppColors.border, width: 1.5),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: AppColors.borderFocused, width: 2),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: AppColors.error, width: 1.5),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(AppRadius.md),
              borderSide: BorderSide(color: AppColors.error, width: 2),
            ),
            errorStyle: theme.textTheme.bodySmall?.copyWith(color: AppColors.error),
          ),
        ),
      ],
    );
  }
}