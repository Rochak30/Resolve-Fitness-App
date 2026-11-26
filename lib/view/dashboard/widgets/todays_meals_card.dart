import 'package:flutter/material.dart';
import 'package:resolve/core/app_colors.dart';
import 'package:resolve/model/meal.dart';
import 'package:resolve/view/dashboard/widgets/info_chip.dart';

// Today's calories against the goal, the macros, and the meals logged so far.
class TodaysMealsCard extends StatelessWidget {
  final int caloriesEaten;
  final int calorieGoal;
  final int proteinGrams;
  final int carbsGrams;
  final List<Meal> meals;
  final VoidCallback onLogMeal;

  const TodaysMealsCard({
    super.key,
    required this.caloriesEaten,
    required this.calorieGoal,
    required this.proteinGrams,
    required this.carbsGrams,
    required this.meals,
    required this.onLogMeal,
  });

  @override
  Widget build(BuildContext context) {
    // How full the progress bar is (0.0 to 1.0).
    final double progress = (caloriesEaten / calorieGoal).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ---------- Calories and macros ----------
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Calories Consumed',
                      style: TextStyle(color: AppColors.grey, fontSize: 13),
                    ),
                    const SizedBox(height: 4),
                    // FittedBox keeps "1,840 / 2,400 kcal" on one line
                    // by shrinking it a little on narrow phones.
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text.rich(
                        TextSpan(
                          text: _formatNumber(caloriesEaten),
                          style: const TextStyle(
                            color: AppColors.textDark,
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                          ),
                          children: [
                            TextSpan(
                              text: ' / ${_formatNumber(calorieGoal)} kcal',
                              style: const TextStyle(
                                color: AppColors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              InfoChip(text: '${proteinGrams}g Protein'),
              const SizedBox(width: 6),
              InfoChip(text: '${carbsGrams}g Carbs', isHighlighted: false),
            ],
          ),
          const SizedBox(height: 14),

          // ---------- Progress bar ----------
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              color: AppColors.green,
              backgroundColor: AppColors.border,
            ),
          ),
          const SizedBox(height: 8),

          // ---------- Meals ----------
          for (final meal in meals) _MealRow(meal: meal),
          const SizedBox(height: 8),

          // ---------- Log another meal ----------
          SizedBox(
            width: double.infinity,
            height: 46,
            child: OutlinedButton.icon(
              onPressed: onLogMeal,
              icon: const Icon(Icons.add, size: 18),
              label: const Text('Log Dinner / Evening Snack'),
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.textDark,
                side: const BorderSide(color: AppColors.border),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Helpers ----------
  // Adds commas: 1840 -> "1,840".
  String _formatNumber(int number) {
    final String digits = number.toString();
    String result = '';
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && (digits.length - i) % 3 == 0) {
        result += ',';
      }
      result += digits[i];
    }
    return result;
  }
}

// One logged meal: icon, name, foods and calories.
class _MealRow extends StatelessWidget {
  final Meal meal;

  const _MealRow({required this.meal});

  IconData _iconFor(String mealName) {
    switch (mealName) {
      case 'Breakfast':
        return Icons.free_breakfast_outlined;
      case 'Lunch':
        return Icons.lunch_dining_outlined;
      case 'Dinner':
        return Icons.dinner_dining_outlined;
      default:
        return Icons.restaurant_outlined;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: AppColors.mint,
              shape: BoxShape.circle,
            ),
            child: Icon(_iconFor(meal.name), color: AppColors.green, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  meal.name,
                  style: const TextStyle(
                    color: AppColors.textDark,
                    fontSize: 15,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                Text(
                  meal.foods,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(color: AppColors.grey, fontSize: 13),
                ),
              ],
            ),
          ),
          Text(
            '${meal.calories} kcal',
            style: const TextStyle(
              color: AppColors.textDark,
              fontSize: 15,
              fontWeight: FontWeight.w700,
            ),
          ),
        ],
      ),
    );
  }
}
