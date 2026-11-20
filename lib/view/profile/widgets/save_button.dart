// lib/view/profile/widgets/save_button.dart
//
// The Save Changes button used in EditProfileScreen.
// Shows a spinner while saving and disables itself to prevent
// multiple concurrent submissions.

import 'package:flutter/material.dart';

import '../profile_colors.dart';

class SaveButton extends StatelessWidget {
  final bool isSaving;
  final VoidCallback? onPressed;

  const SaveButton({
    super.key,
    required this.isSaving,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: isSaving ? null : onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: ProfileColors.accent,
        foregroundColor: ProfileColors.dark,
        disabledBackgroundColor: ProfileColors.border,
        disabledForegroundColor: ProfileColors.mid,
        padding: const EdgeInsets.symmetric(vertical: 15),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        elevation: 0,
      ),
      child: isSaving
          ? const SizedBox(
              height: 20,
              width: 20,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                valueColor: AlwaysStoppedAnimation<Color>(ProfileColors.mid),
              ),
            )
          : const Text('Save Changes'),
    );
  }
}
