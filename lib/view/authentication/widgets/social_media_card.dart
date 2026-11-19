import 'package:flutter/material.dart';

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
