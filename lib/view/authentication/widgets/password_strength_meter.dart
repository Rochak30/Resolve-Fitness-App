import 'package:flutter/material.dart';
import 'package:resolve/core/app_colors.dart';

/// The passcode rules in one place, so the UI and the submit button agree.
class PasswordRules {
  PasswordRules._();

  static bool hasMinLength(String p) => p.length >= 8;
  static bool hasNumber(String p) => RegExp(r'\d').hasMatch(p);
  static bool hasSymbol(String p) => RegExp(r'[^A-Za-z0-9\s]').hasMatch(p);

  /// All three requirements met.
  static bool isValid(String p) =>
      hasMinLength(p) && hasNumber(p) && hasSymbol(p);

  /// 0 (empty) to 4 (strong). The 4th point is for 12+ characters.
  static int score(String p) {
    if (p.isEmpty) return 0;
    var s = 0;
    if (hasMinLength(p)) s++;
    if (hasNumber(p)) s++;
    if (hasSymbol(p)) s++;
    if (p.length >= 12) s++;
    return s == 0 ? 1 : s;
  }

  static String label(String p) =>
      const ['', 'Weak', 'Fair', 'Good', 'Strong'][score(p)];

  static Color color(String p) => switch (score(p)) {
    1 => Colors.red.shade600,
    2 => Colors.orange.shade700,
    3 => Colors.lightGreen.shade700,
    4 => Colors.green.shade600,
    _ => AppColors.grey,
  };
}

/// 4-segment strength bar + the three requirement ticks.
class PasswordStrengthMeter extends StatelessWidget {
  final String password;

  const PasswordStrengthMeter({super.key, required this.password});

  @override
  Widget build(BuildContext context) {
    final score = PasswordRules.score(password);
    final color = PasswordRules.color(password);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ---------- Strength bar ----------
        Row(
          children: [
            for (var i = 0; i < 4; i++) ...[
              if (i > 0) const SizedBox(width: 8),
              Expanded(
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  height: 6,
                  decoration: BoxDecoration(
                    color: i < score ? color : const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(3),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 10),

        // ---------- Requirements ----------
        Wrap(
          spacing: 14,
          runSpacing: 6,
          children: [
            _RuleChip(label: '8+ chars', met: PasswordRules.hasMinLength(password)),
            _RuleChip(label: '1 number', met: PasswordRules.hasNumber(password)),
            _RuleChip(label: '1 symbol', met: PasswordRules.hasSymbol(password)),
          ],
        ),
      ],
    );
  }
}

class _RuleChip extends StatelessWidget {
  final String label;
  final bool met;

  const _RuleChip({required this.label, required this.met});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          met ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 16,
          color: met ? Colors.green.shade600 : AppColors.grey,
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w600,
            color: met ? Colors.black87 : AppColors.grey,
          ),
        ),
      ],
    );
  }
}
