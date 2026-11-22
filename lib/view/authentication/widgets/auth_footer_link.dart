import 'package:flutter/material.dart';
import 'package:resolve/core/app_colors.dart';

/// "Remembered it? Sign In" style line under the main button.
class AuthFooterLink extends StatelessWidget {
  final String prompt;
  final String actionText;
  final VoidCallback onTap;

  const AuthFooterLink({
    super.key,
    required this.prompt,
    required this.actionText,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          prompt,
          style: const TextStyle(fontSize: 15, color: AppColors.grey),
        ),
        TextButton(
          onPressed: onTap,
          child: Text(
            actionText,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.primary,
            ),
          ),
        ),
      ],
    );
  }
}
