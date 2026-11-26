// Owner: Nirajan

import 'package:flutter/material.dart';
import 'package:resolve/core/app_colors.dart';

// One small card: a label, a big number with its unit, and a progress bar.
// Used for Steps, Calories and Heart rate at the top of the dashboard.
class StatCard extends StatelessWidget {
  final String label;
  final String value;
  final String unit;
  final double progress;
  final Color barColor;

  const StatCard({
    super.key,
    required this.label,
    required this.value,
    this.unit = '',
    required this.progress,
    required this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- Label ----------
          Text(
            label,
            style: const TextStyle(color: AppColors.grey, fontSize: 12),
          ),
          const SizedBox(height: 6),

          // ---------- Value and unit ----------
          // FittedBox shrinks the text a little on narrow phones
          // instead of letting it wrap onto two lines.
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text.rich(
              TextSpan(
                text: value,
                style: const TextStyle(
                  color: AppColors.textDark,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
                children: [
                  if (unit.isNotEmpty)
                    TextSpan(
                      text: ' $unit',
                      style: const TextStyle(
                        color: AppColors.grey,
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),

          // ---------- Progress bar ----------
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 6,
              color: barColor,
              backgroundColor: AppColors.border,
            ),
          ),
        ],
      ),
    );
  }
}
