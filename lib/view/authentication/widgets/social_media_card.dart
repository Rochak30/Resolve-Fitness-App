import 'package:flutter/material.dart';
import 'package:resolve/core/app_colors.dart';

class SocialMediaCard extends StatelessWidget {
  final String imagePath;
  final String label;

  const SocialMediaCard({
    super.key,
    required this.imagePath,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Card(
        // ---------- Look: white with a thin border ----------
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ---------- Logo ----------
            Image.asset(imagePath, width: 40, height: 40),
            const SizedBox(width: 10),

            // ---------- Label ----------
            Text(label, style: const TextStyle(fontSize: 20)),
          ],
        ),
      ),
    );
  }
}
