// lib/view/profile/widgets/profile_header.dart
//
// Displays the dark avatar card at the top of ProfileScreen:
// initials circle + name + gender.

import 'package:flutter/material.dart';

import '../profile_colors.dart';

class ProfileHeader extends StatelessWidget {
  final String name;
  final String gender;

  const ProfileHeader({
    super.key,
    required this.name,
    required this.gender,
  });

  @override
  Widget build(BuildContext context) {
    final initials = name.trim().isEmpty
        ? '?'
        : name.trim().split(RegExp(r'\s+')).map((w) => w[0]).take(2).join();

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 28, horizontal: 20),
      decoration: BoxDecoration(
        color: ProfileColors.dark,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 36,
            backgroundColor: ProfileColors.accent,
            child: Text(
              initials.toUpperCase(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: ProfileColors.dark,
              ),
            ),
          ),
          const SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: const TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  gender,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.white.withAlpha(178),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
