// Reusable dropdown for the edit form (used for gender and fitness level).

import 'package:flutter/material.dart';

import '../profile_colors.dart';

class ProfileDropdown<T> extends StatelessWidget {
  final T? value;
  final String hint;
  final IconData icon;
  final List<DropdownMenuItem<T>> items;
  final ValueChanged<T?> onChanged;
  final String? Function(T?) validator;

  const ProfileDropdown({
    super.key,
    required this.value,
    required this.hint,
    required this.icon,
    required this.items,
    required this.onChanged,
    required this.validator,
  });

  OutlineInputBorder _border(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(10),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<T>(
      initialValue: value,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: ProfileColors.border, fontSize: 14),
        prefixIcon: Icon(icon, color: ProfileColors.mid, size: 20),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: _border(ProfileColors.border),
        enabledBorder: _border(ProfileColors.border),
        focusedBorder: _border(ProfileColors.accent, 1.8),
        errorBorder: _border(Colors.redAccent),
        focusedErrorBorder: _border(Colors.redAccent, 1.8),
      ),
      items: items,
      onChanged: onChanged,
      validator: validator,
    );
  }
}