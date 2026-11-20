// lib/view/profile/widgets/profile_empty_state.dart
//
// Shown on ProfileScreen when no profile has been saved yet.

import 'package:flutter/material.dart';

import '../profile_colors.dart';

class ProfileEmptyState extends StatelessWidget {
  final VoidCallback onCreateProfile;

  const ProfileEmptyState({super.key, required this.onCreateProfile});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.person_add_alt_1_rounded,
              size: 72,
              color: ProfileColors.accent,
            ),
            const SizedBox(height: 20),
            const Text(
              'No Profile Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: ProfileColors.dark,
              ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Set up your profile to get personalised BMI,\ncalorie and workout suggestions.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: ProfileColors.mid,
                height: 1.5,
              ),
            ),
            const SizedBox(height: 28),
            ElevatedButton.icon(
              onPressed: onCreateProfile,
              icon: const Icon(Icons.add),
              label: const Text('Create Profile'),
              style: ElevatedButton.styleFrom(
                backgroundColor: ProfileColors.accent,
                foregroundColor: ProfileColors.dark,
                padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
                textStyle: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
