// Owner: Rochak (layout, workout, meals) and Nirajan (quick access, weekly progress)

import 'package:flutter/material.dart';
import 'package:resolve/core/app_colors.dart';
import 'package:resolve/view/dashboard/widgets/dashboard_header.dart';
import 'package:resolve/view/dashboard/widgets/section_header.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
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
                name: 'Michael Bernando',
                onNotificationsTap: () => _showComingSoon('Notifications'),
              ),
              const SizedBox(height: 20),

              // ---------- Quick access (Nirajan) ----------
              // Steps, calories and heart rate cards go here.

              // ---------- Weekly progress (Nirajan) ----------
              // Gym attendance and the weekly calories chart go here.

              // ---------- Today's workout ----------
              SectionHeader(
                title: 'Personalized workout plan',
                actionText: 'View all',
                onActionTap: () => _showComingSoon('Workout plans'),
              ),
              const SizedBox(height: 24),

              // ---------- Today's meals ----------
              SectionHeader(
                title: "Today's Meals",
                actionText: '+ Log meal',
                onActionTap: () => _showComingSoon('Meal logging'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
