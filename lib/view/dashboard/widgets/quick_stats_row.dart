// Owner: Nirajan

import 'package:flutter/material.dart';
import 'package:resolve/core/app_colors.dart';
import 'package:resolve/view/dashboard/widgets/stat_card.dart';

// Quick access: today's steps, calories burned and heart rate, side by side.
// Sprint 1 has no backend, so the numbers are sample data.
class QuickStatsRow extends StatelessWidget {
  const QuickStatsRow({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        Expanded(
          child: StatCard(
            label: 'Steps',
            value: '6,359',
            progress: 0.64,
            barColor: AppColors.green,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: StatCard(
            label: 'Calories',
            value: '3,115',
            unit: 'kcal',
            progress: 0.78,
            barColor: AppColors.green,
          ),
        ),
        SizedBox(width: 8),
        Expanded(
          child: StatCard(
            label: 'Heart rate',
            value: '123',
            unit: 'bpm',
            progress: 0.5,
            barColor: AppColors.teal,
          ),
        ),
      ],
    );
  }
}
