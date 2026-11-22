import 'package:flutter/material.dart';
import 'package:resolve/core/app_colors.dart';
import 'package:resolve/view/widgets/app_text_field.dart';

/// AppTextField for passcodes: lock icon + show/hide toggle (hidden by default).
class PasswordField extends StatefulWidget {
  final String hint;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final TextInputAction? textInputAction;
  final Iterable<String>? autofillHints;
  final String? errorText;

  const PasswordField({
    super.key,
    required this.hint,
    required this.controller,
    this.onChanged,
    this.textInputAction,
    this.autofillHints,
    this.errorText,
  });

  @override
  State<PasswordField> createState() => _PasswordFieldState();
}

class _PasswordFieldState extends State<PasswordField> {
  bool _obscure = true;

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      hint: widget.hint,
      controller: widget.controller,
      obscureText: _obscure,
      onChanged: widget.onChanged,
      textInputAction: widget.textInputAction,
      autofillHints: widget.autofillHints,
      errorText: widget.errorText,
      prefixIcon: const Icon(Icons.lock_outline, color: AppColors.grey),
      suffixIcon: IconButton(
        tooltip: _obscure ? 'Show passcode' : 'Hide passcode',
        icon: Icon(
          _obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined,
          color: AppColors.grey,
        ),
        onPressed: () => setState(() => _obscure = !_obscure),
      ),
    );
  }
}
