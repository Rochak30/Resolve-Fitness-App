import 'package:flutter/material.dart';
import 'package:resolve/core/app_colors.dart';

// A small rounded label, e.g. "Intermediate" or "95g Protein".
// Highlighted chips are mint with green text; plain ones are outlined grey.
class InfoChip extends StatelessWidget {
  final String text;
  final bool isHighlighted;

  const InfoChip({super.key, required this.text, this.isHighlighted = true});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: isHighlighted ? AppColors.mint : Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isHighlighted ? AppColors.mint : AppColors.border,
        ),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: isHighlighted ? AppColors.green : AppColors.grey,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
