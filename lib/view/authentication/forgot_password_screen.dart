import 'package:flutter/material.dart';
import 'package:resolve/core/app_routes.dart';
import 'package:resolve/view/authentication/widgets/auth_footer_link.dart';
import 'package:resolve/view/authentication/widgets/auth_scaffold.dart';
import 'package:resolve/view/authentication/widgets/field_label.dart';
import 'package:resolve/view/authentication/widgets/info_note_card.dart';
import 'package:resolve/view/widgets/app_text_field.dart';
import 'package:resolve/view/widgets/primary_button.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  static final _emailPattern = RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$');

  final _emailController = TextEditingController();
  String? _emailError;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _sendCode() {
    final email = _emailController.text.trim();

    // Frontend check only: is it shaped like an email?
    if (!_emailPattern.hasMatch(email)) {
      setState(() => _emailError = 'Enter a valid email address');
      return;
    }

    // TODO(backend): ask the API to email a reset code to [email].

    // The OTP screen gets the email so it can show where the code was sent.
    // After a successful code check it should open AppRoutes.resetPassword.
    Navigator.pushNamed(context, AppRoutes.otpVerify, arguments: email);
  }

  @override
  Widget build(BuildContext context) {
    return AuthScaffold(
      title: 'Reset Access',
      subtitle:
          'Enter the email tied to your athlete account. '
          'We’ll send a 6-digit code to get you back on the ridge.',
      children: [
        const FieldLabel('Email address', trailing: 'Verified ID'),
        const SizedBox(height: 8),
        AppTextField(
          hint: 'athlete@resolve.np',
          controller: _emailController,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
          autofillHints: const [AutofillHints.email],
          prefixIcon: const Icon(Icons.mail_outline),
          errorText: _emailError,
          onChanged: (_) {
            if (_emailError != null) setState(() => _emailError = null);
          },
        ),
        const SizedBox(height: 16),
        const InfoNoteCard(
          icon: Icons.schedule,
          title: 'Code window',
          message: 'Codes expire in 10 minutes. Check spam if nothing lands.',
        ),
      ],
      footer: [
        PrimaryButton(text: 'Send reset code', onPressed: _sendCode),
        const SizedBox(height: 16),
        AuthFooterLink(
          prompt: 'Remembered it?',
          actionText: 'Sign In',
          onTap: () => Navigator.of(context).maybePop(),
        ),
      ],
    );
  }
}
