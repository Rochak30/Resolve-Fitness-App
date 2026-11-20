import 'package:flutter/material.dart';
import 'package:resolve/core/app_colors.dart';

/// RESOLVE wordmark + screen title + short description.
class AuthHeader extends StatelessWidget {
  final String title;
  final String subtitle;

  const AuthHeader({super.key, required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------- Wordmark ----------
        const Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 8,
          children: [
            Text(
              'RESOLVE',
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.5,
                height: 1,
                color: AppColors.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text(
                'FITNESS APP NEPAL',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),

        // ---------- Title ----------
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
            height: 1.1,
          ),
        ),
        const SizedBox(height: 8),

        // ---------- Subtitle ----------
        Text(
          subtitle,
          style: const TextStyle(
            fontSize: 15,
            height: 1.45,
            color: AppColors.grey,
          ),
        ),
      ],
    );
  }
}
