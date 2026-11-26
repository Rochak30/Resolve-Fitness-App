import 'package:flutter/material.dart';
import 'package:resolve/core/app_colors.dart';

// ---------- Bottom navigation bar ----------
// Home is the current page. The gap in the middle leaves room for the
// round scan button, which the Scaffold docks on top of the bar.
class DashboardBottomNav extends StatelessWidget {
  final VoidCallback onWorkoutTap;
  final VoidCallback onMealTap;
  final VoidCallback onProfileTap;

  const DashboardBottomNav({
    super.key,
    required this.onWorkoutTap,
    required this.onMealTap,
    required this.onProfileTap,
  });

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      color: Colors.white,
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Row(
        children: [
          const _NavItem(icon: Icons.home, label: 'Home', isSelected: true),
          _NavItem(
            icon: Icons.fitness_center,
            label: 'Workout',
            onTap: onWorkoutTap,
          ),
          const SizedBox(width: 72),
          _NavItem(icon: Icons.restaurant, label: 'Meal', onTap: onMealTap),
          _NavItem(
            icon: Icons.person_outline,
            label: 'Profile',
            onTap: onProfileTap,
          ),
        ],
      ),
    );
  }
}

// One icon + label in the bar.
class _NavItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final bool isSelected;
  final VoidCallback? onTap;

  const _NavItem({
    required this.icon,
    required this.label,
    this.isSelected = false,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final Color color = isSelected ? AppColors.green : AppColors.grey;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              label,
              style: TextStyle(
                color: color,
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------- Scan button ----------
// The round green button in the middle of the bar (for gym QR check-in).
class ScanButton extends StatelessWidget {
  final VoidCallback onPressed;

  const ScanButton({super.key, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: onPressed,
      tooltip: 'Scan QR code',
      backgroundColor: AppColors.green,
      foregroundColor: Colors.white,
      elevation: 4,
      shape: const CircleBorder(
        side: BorderSide(color: Colors.white, width: 4),
      ),
      child: const Icon(Icons.qr_code_scanner, size: 28),
    );
  }
}
