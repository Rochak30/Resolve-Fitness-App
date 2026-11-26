import 'package:flutter/material.dart';
import 'package:resolve/core/app_colors.dart';

// Top of the dashboard: avatar, welcome message and the notifications bell.
class DashboardHeader extends StatelessWidget {
  final String name;
  final VoidCallback onNotificationsTap;

  const DashboardHeader({
    super.key,
    required this.name,
    required this.onNotificationsTap,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // ---------- Avatar ----------
        Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: AppColors.mint,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
          child: const Icon(Icons.person_outline, color: AppColors.green),
        ),
        const SizedBox(width: 12),

        // ---------- Welcome text ----------
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Welcome back,',
                style: TextStyle(color: AppColors.grey, fontSize: 13),
              ),
              Text(
                name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ],
          ),
        ),

        // ---------- Notifications bell ----------
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.border),
          ),
          child: IconButton(
            onPressed: onNotificationsTap,
            icon: const Icon(
              Icons.notifications_none,
              color: AppColors.textDark,
            ),
            tooltip: 'Notifications',
          ),
        ),
      ],
    );
  }
}
