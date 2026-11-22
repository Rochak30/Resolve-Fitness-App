import 'package:flutter/material.dart';
import 'package:resolve/core/app_colors.dart';

class AppTextField extends StatelessWidget {
  final String hint;
  final bool obscureText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final TextEditingController? controller;

  // ---------- Optional extras (existing usages are unaffected) ----------
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final ValueChanged<String>? onChanged;
  final Iterable<String>? autofillHints;
  final String? errorText;

  const AppTextField({
    super.key,
    required this.hint,
    this.obscureText = false,
    this.prefixIcon,
    this.suffixIcon,
    this.controller,
    this.keyboardType,
    this.textInputAction,
    this.onChanged,
    this.autofillHints,
    this.errorText,
  });

  @override
  Widget build(BuildContext context) {
    final errorBorder = OutlineInputBorder(
      borderRadius: BorderRadius.circular(15),
      borderSide: BorderSide(color: Colors.red.shade600),
    );

    return TextField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      onChanged: onChanged,
      autofillHints: autofillHints,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: AppColors.grey),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: errorText,

        // ---------- Look: filled, rounded, no border ----------
        filled: true,
        fillColor: AppColors.fieldFill,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
          borderSide: BorderSide.none,
        ),
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
      ),
    );
  }
}
