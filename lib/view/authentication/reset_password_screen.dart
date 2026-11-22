import 'package:flutter/material.dart';
import 'package:resolve/core/app_routes.dart';
import 'package:resolve/view/authentication/widgets/auth_footer_link.dart';
import 'package:resolve/view/authentication/widgets/auth_scaffold.dart';
import 'package:resolve/view/authentication/widgets/field_label.dart';
import 'package:resolve/view/authentication/widgets/password_field.dart';
import 'package:resolve/view/authentication/widgets/password_strength_meter.dart';
import 'package:resolve/view/widgets/primary_button.dart';

/// Last step of the forgot-password flow (after the OTP is verified).
/// No "current passcode" field on purpose: the user forgot it, and the
/// verified code already proves they own the account.
class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  String get _password => _passwordController.text;
  String get _confirm => _confirmController.text;

  bool get _passwordsMatch => _confirm.isNotEmpty && _password == _confirm;
  bool get _canSubmit => PasswordRules.isValid(_password) && _passwordsMatch;

  @override
  void dispose() {
    _passwordController.dispose();
    _confirmController.dispose();
    super.dispose();
  }

  void _onChanged(String _) => setState(() {});

  void _submit() {
    // TODO(backend): send the new passcode to the reset-password API.

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Passcode updated. Sign in to continue.')),
    );
    _goToLogin();
  }

  void _goToLogin() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.login,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Set New Passcode',
      subtitle: 'Pick something strong. You’ll use it the next time you sign in.',
      children: [
        // ---------- New passcode ----------
        FieldLabel(
          'New passcode',
          trailing: _password.isEmpty
              ? null
              : 'Strength: ${PasswordRules.label(_password)}',
          trailingColor: PasswordRules.color(_password),
        ),
        const SizedBox(height: 8),
        PasswordField(
          hint: 'Enter new passcode',
          controller: _passwordController,
          onChanged: _onChanged,
          textInputAction: TextInputAction.next,
          autofillHints: const [AutofillHints.newPassword],
        ),
        const SizedBox(height: 12),
        PasswordStrengthMeter(password: _password),
        const SizedBox(height: 24),

        // ---------- Confirm passcode ----------
        FieldLabel(
          'Confirm passcode',
          trailing: _confirm.isEmpty
              ? null
              : (_passwordsMatch ? 'Match' : 'No match'),
          trailingColor: _passwordsMatch
              ? Colors.green.shade700
              : Colors.red.shade600,
        ),
        const SizedBox(height: 8),
        PasswordField(
          hint: 'Re-enter new passcode',
          controller: _confirmController,
          onChanged: _onChanged,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.newPassword],
        ),
      ],
      footer: [
        PrimaryButton(
          text: 'Update passcode',
          onPressed: _canSubmit ? _submit : null,
        ),
        const SizedBox(height: 16),
        AuthFooterLink(
          prompt: 'Changed your mind?',
          actionText: 'Back to Sign In',
          onTap: _goToLogin,
        ),
      ],
    );
  }
}
