import 'package:flutter/material.dart';
import 'package:resolve/core/app_colors.dart';

/// Small uppercase label above a field, with an optional hint on the right.
class FieldLabel extends StatelessWidget {
  final String label;
  final String? trailing;
  final Color trailingColor;

  const FieldLabel(
    this.label, {
    super.key,
    this.trailing,
    this.trailingColor = AppColors.grey,
  });

  @override
  Widget build(BuildContext context) {
    const style = TextStyle(
      fontSize: 12,
      fontWeight: FontWeight.w700,
      letterSpacing: 0.8,
    );

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label.toUpperCase(),
          style: style.copyWith(color: Colors.black87),
        ),
        if (trailing != null)
          Text(
            trailing!.toUpperCase(),
            style: style.copyWith(color: trailingColor),
          ),
      ],
    );
  }
}
