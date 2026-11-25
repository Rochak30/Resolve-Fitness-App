// Owner: Aayusha
// Settings screen – lists shortcuts to edit Training Preferences (US-1.6)
// and Profile so users can change them after onboarding.

import 'package:flutter/material.dart';

import '../../core/app_colors.dart';
import '../../core/app_text_styles.dart';
import '../../core/app_routes.dart';
import '../onboarding/training_preferences_screen.dart';
import '../profile/profile_colors.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileColors.background,
      appBar: AppBar(
        backgroundColor: ProfileColors.dark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Settings',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        children: [
          _SectionLabel(label: 'Training'),
          _SettingsTile(
            icon: Icons.tune,
            title: 'Training Preferences',
            subtitle: 'Types, fitness level & goal',
            onTap: () => Navigator.of(context).push(
              MaterialPageRoute(
                builder: (_) => const TrainingPreferencesScreen(isEditing: true),
              ),
            ),
          ),
          const SizedBox(height: 24),

          _SectionLabel(label: 'Profile'),
          _SettingsTile(
            icon: Icons.person_outline,
            title: 'Edit Profile',
            subtitle: 'Name, age, height & body metrics',
            onTap: () => Navigator.of(context).pushNamed(AppRoutes.editProfile),
          ),
        ],
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  final String label;
  const _SectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.labelSm.copyWith(
          color: ProfileColors.mid,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

class _SettingsTile extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _SettingsTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: ProfileColors.border),
        ),
        child: Row(
          children: [
            Icon(icon, size: 22, color: ProfileColors.accent),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: AppTextStyles.labelMd
                        .copyWith(color: ProfileColors.dark),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: AppTextStyles.bodySm
                        .copyWith(color: ProfileColors.mid),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, size: 20, color: ProfileColors.border),
          ],
        ),
      ),
    );
  }
}
