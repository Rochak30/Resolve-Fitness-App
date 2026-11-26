// Owner: Nirajan

import 'package:flutter/material.dart';
import 'package:resolve/core/app_colors.dart';

// Shows whether the user has checked in at the gym today.
class GymAttendanceRow extends StatelessWidget {
  final bool isCheckedIn;

  const GymAttendanceRow({super.key, required this.isCheckedIn});

  @override
  Widget build(BuildContext context) {
    final Color statusColor = isCheckedIn ? AppColors.green : AppColors.grey;

    return Row(
      children: [
        // ---------- Title ----------
        const Expanded(
          child: Text(
            'Gym attendance',
            style: TextStyle(
              color: AppColors.textDark,
              fontSize: 16,
              fontWeight: FontWeight.w700,
            ),
          ),
        ),

        // ---------- Status ----------
        Icon(
          isCheckedIn ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 16,
          color: statusColor,
        ),
        const SizedBox(width: 4),
        Text(
          isCheckedIn ? 'Checked in' : 'Not checked in',
          style: TextStyle(
            color: statusColor,
            fontSize: 13,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
