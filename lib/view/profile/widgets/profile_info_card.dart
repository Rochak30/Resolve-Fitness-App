// lib/view/profile/widgets/profile_info_card.dart
//
// A white rounded card that holds one or more labelled info rows.
// Reused for Personal Details, Body Metrics and Fitness Profile sections.

import 'package:flutter/material.dart';

import '../profile_colors.dart';

// ---------------------------------------------------------------------------
// ProfileInfoCard – container
// ---------------------------------------------------------------------------

class ProfileInfoCard extends StatelessWidget {
  final List<Widget> children;

  const ProfileInfoCard({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ProfileColors.border),
      ),
      child: Column(children: children),
    );
  }
}

// ---------------------------------------------------------------------------
// ProfileInfoRow – a single icon + label + value row inside the card
// ---------------------------------------------------------------------------

class ProfileInfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const ProfileInfoRow({
    super.key,
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, size: 20, color: ProfileColors.accent),
          const SizedBox(width: 12),
          Text(
            label,
            style: const TextStyle(fontSize: 14, color: ProfileColors.mid),
          ),
          const Spacer(),
          Text(
            value,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w600,
              color: ProfileColors.dark,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// ProfileCardDivider – thin divider between rows inside a card
// ---------------------------------------------------------------------------

class ProfileCardDivider extends StatelessWidget {
  const ProfileCardDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return const Divider(
      height: 1,
      indent: 48,
      endIndent: 16,
      color: ProfileColors.border,
    );
  }
}

// ---------------------------------------------------------------------------
// ProfileSectionLabel – small-caps section heading above a card
// ---------------------------------------------------------------------------

class ProfileSectionLabel extends StatelessWidget {
  final String label;

  const ProfileSectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: ProfileColors.mid,
      ),
    );
  }
}
