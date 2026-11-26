// Owner: Nirajan

import 'package:flutter/material.dart';
import 'package:resolve/core/app_colors.dart';

// Weekly progress: one bar per day (Sunday first), today's bar in green,
// and the week's average at the top. Built with plain Containers, no package.
class WeeklyCaloriesChart extends StatelessWidget {
  final List<int> caloriesPerDay;
  final int todayIndex;

  const WeeklyCaloriesChart({
    super.key,
    required this.caloriesPerDay,
    required this.todayIndex,
  });

  static const List<String> _dayLetters = ['S', 'M', 'T', 'W', 'T', 'F', 'S'];
  static const double _maxBarHeight = 110;

  @override
  Widget build(BuildContext context) {
    // ---------- Highest day and average ----------
    int highest = 0;
    int total = 0;
    for (final int calories in caloriesPerDay) {
      if (calories > highest) {
        highest = calories;
      }
      total += calories;
    }
    final int average = caloriesPerDay.isEmpty
        ? 0
        : (total / caloriesPerDay.length).round();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------- Title and average ----------
        Row(
          children: [
            const Expanded(
              child: Text(
                'Calories, weekly activity',
                style: TextStyle(
                  color: AppColors.textDark,
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Text(
              'Avg $average cal',
              style: const TextStyle(
                color: AppColors.grey,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),

        // ---------- Bars ----------
        Container(
          padding: const EdgeInsets.fromLTRB(12, 20, 12, 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              for (int i = 0; i < caloriesPerDay.length; i++)
                Expanded(
                  child: _DayBar(
                    height: highest == 0
                        ? 0
                        : _maxBarHeight * caloriesPerDay[i] / highest,
                    dayLetter: _dayLetters[i % 7],
                    isToday: i == todayIndex,
                  ),
                ),
            ],
          ),
        ),
      ],
    );
  }
}

// One bar with its day letter underneath.
class _DayBar extends StatelessWidget {
  final double height;
  final String dayLetter;
  final bool isToday;

  const _DayBar({
    required this.height,
    required this.dayLetter,
    required this.isToday,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          height: height,
          margin: const EdgeInsets.symmetric(horizontal: 6),
          decoration: BoxDecoration(
            color: isToday ? AppColors.green : AppColors.border,
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          dayLetter,
          style: TextStyle(
            color: isToday ? AppColors.green : AppColors.grey,
            fontSize: 12,
            fontWeight: isToday ? FontWeight.w800 : FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
