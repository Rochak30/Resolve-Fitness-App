// Owner: Rochak (layout, workout, meals) and Nirajan (quick access, weekly progress)

import 'package:flutter/material.dart';
import 'package:resolve/core/app_colors.dart';
import 'package:resolve/core/app_routes.dart';
import 'package:resolve/model/meal.dart';
import 'package:resolve/view/dashboard/widgets/dashboard_bottom_nav.dart';
import 'package:resolve/view/dashboard/widgets/dashboard_header.dart';
import 'package:resolve/view/dashboard/widgets/gym_attendance_row.dart';
import 'package:resolve/view/dashboard/widgets/quick_stats_row.dart';
import 'package:resolve/view/dashboard/widgets/section_header.dart';
import 'package:resolve/view/dashboard/widgets/todays_meals_card.dart';
import 'package:resolve/view/dashboard/widgets/weekly_calories_chart.dart';
import 'package:resolve/view/dashboard/widgets/workout_plan_card.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  // ---------- Hardcoded data (Sprint 1 has no backend) ----------
  final List<Meal> _meals = const [
    Meal(name: 'Breakfast', foods: 'Oats, Berries & Whey', calories: 420),
    Meal(name: 'Lunch', foods: 'Grilled Chicken & Brown Rice', calories: 680),
  ];

  // ---------- Actions ----------
  void _showComingSoon(String feature) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('$feature is coming in a later sprint')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------- Header ----------
              DashboardHeader(
                name: 'Resolve User',
                onNotificationsTap: () => _showComingSoon('Notifications'),
              ),
              const SizedBox(height: 20),

              // ---------- Quick access (Nirajan) ----------
              const QuickStatsRow(),
              const SizedBox(height: 24),

              // ---------- Weekly progress (Nirajan) ----------
              const GymAttendanceRow(isCheckedIn: false),
              const SizedBox(height: 24),
              const WeeklyCaloriesChart(
                caloriesPerDay: [85, 120, 105, 125, 100, 150, 70],
                todayIndex: 5,
              ),
              const SizedBox(height: 24),

              // ---------- Today's workout ----------
              SectionHeader(
                title: 'Personalized workout plan',
                actionText: 'View all',
                onActionTap: () => _showComingSoon('Workout plans'),
              ),
              const SizedBox(height: 15),
              WorkoutPlanCard(
                imagePath: 'assets/images/chest_workout_2.png',
                title: 'Chest workout',
                details: '5–8 min · Strength training',
                level: 'Intermediate',
                onStart: () => _showComingSoon('Workouts'),
              ),
              const SizedBox(height: 40),

              // ---------- Today's meals ----------
              SectionHeader(
                title: "Today's Meals",
                actionText: '+ Log meal',
                onActionTap: () => _showComingSoon('Meal logging'),
              ),
              const SizedBox(height: 12),
              TodaysMealsCard(
                caloriesEaten: 1840,
                calorieGoal: 2400,
                proteinGrams: 95,
                carbsGrams: 180,
                meals: _meals,
                onLogMeal: () => _showComingSoon('Meal logging'),
              ),
            ],
          ),
        ),
      ),

      // ---------- Bottom navigation ----------
      floatingActionButton: ScanButton(
        onPressed: () => _showComingSoon('QR check-in'),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      bottomNavigationBar: DashboardBottomNav(
        onWorkoutTap: () => _showComingSoon('Workouts'),
        onMealTap: () => _showComingSoon('Meals'),
        onProfileTap: () => Navigator.pushNamed(context, AppRoutes.profile),
      ),
    );
  }
}
