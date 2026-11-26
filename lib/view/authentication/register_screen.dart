// Owner: Nirajan

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:resolve/core/app_routes.dart';
import 'package:resolve/view/authentication/auth_colors.dart';
import 'package:resolve/view/authentication/widgets/auth_header.dart';
import 'package:resolve/view/authentication/widgets/register_hero.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // ---------- Remote artwork used by the Stitch layout ----------
  static const String _heroImageUrl =
      'https://lh3.googleusercontent.com/aida-public/AB6AXuA5SUHXI1ZQXqU0A2C8aaOdaAv0e1zq0IcUjvC3j5fbXrUTB9L1yIAYmPcEC7hinFmAdUyES4MkID5nTnyRvSt263Qjq9smedxxh1RQOHaoL_ck0sK4B7_fAhHOTjmx92ax6I_4L07TPOqnmcmyNrMZlLNXM1MiEiESVfUvD4RmujJA_jiB2oHwI-BDrg58Qzc8bnpx5743rgP0HB9kOsjs0wZpiFQ0fAAdktW86Zo';
  static const String _avatarUrl =
      'https://lh3.googleusercontent.com/aida/AEtjO1VlZWq27cGajYFFiF9LphbpXxU23T2Ubfvwg5eX8AOdmKTGpfYeGUUXV9zWRKs4zllUWq09XSHZ_tLWxzzKbGGcAg6wAOFwQYi5WRH1DI9YfSGCN-tOzg0f-z8nMNIAFmSXEHVFgcR7zfWiskvaAQFOMjwfJmpmSSV4OLH1g4ZpFIHSezXTJZtx7lmeBX-0-6WGh3TMsvcOIUxGQxOctQrnkXx4fFXZRSL6zT10yYc';

  static const List<({IconData icon, String title, String subtitle})>
  _disciplines = [
    (
      icon: Icons.landscape_outlined,
      title: 'Running',
      subtitle: 'Trail & Elevation',
    ),
    (
      icon: Icons.sports_gymnastics,
      title: 'Calisthenics',
      subtitle: 'Bodyweight Power',
    ),
    (
      icon: Icons.fitness_center,
      title: 'Weight Training',
      subtitle: 'Barbell / Strength',
    ),
    (icon: Icons.bolt, title: 'HIIT', subtitle: 'Interval Sprints'),
  ];

  static const List<String> _levels = ['Beginner', 'Intermediate', 'Advanced'];

  // ---------- Form state ----------
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmController = TextEditingController();

  late final TapGestureRecognizer _termsRecognizer;

  bool _hidePassword = true;
  bool _acceptedTerms = true;
  int _disciplineIndex = 2;
  int _levelIndex = 1;

  @override
  void initState() {
    super.initState();
    _termsRecognizer = TapGestureRecognizer()
      ..onTap = () => _showComingSoon('Athlete terms');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmController.dispose();
    _termsRecognizer.dispose();
    super.dispose();
  }

  // ---------- Password strength ----------
  bool get _hasMinLength => _passwordController.text.length >= 8;
  bool get _hasNumber => RegExp(r'\d').hasMatch(_passwordController.text);
  bool get _hasSymbol =>
      RegExp(r'[^A-Za-z0-9]').hasMatch(_passwordController.text);

  int get _strengthScore =>
      [_hasMinLength, _hasNumber, _hasSymbol].where((met) => met).length;

  int get _strengthBars => switch (_strengthScore) {
    0 => 0,
    1 => 1,
    2 => 3,
    _ => 4,
  };

  String get _strengthLabel => switch (_strengthScore) {
    0 || 1 => 'WEAK',
    2 => 'MEDIUM',
    _ => 'STRONG',
  };

  bool get _passwordsMatch =>
      _confirmController.text.isNotEmpty &&
      _confirmController.text == _passwordController.text;

  // ---------- Actions ----------
  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    if (!_acceptedTerms) {
      _showMessage('Please accept the Athlete Terms & Conditions');
      return;
    }
    // Sprint 1 has no backend, so a valid form starts the athlete profile.
    Navigator.pushReplacementNamed(context, AppRoutes.trainingPreferences);
  }

  void _goToLogin() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop();
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.login);
    }
  }

  void _showComingSoon(String feature) {
    _showMessage('$feature is coming in a later sprint');
  }

  void _showMessage(String message) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message)));
  }

  Widget _buildDiscipline(int index) {
    final discipline = _disciplines[index];
    return _DisciplineCard(
      icon: discipline.icon,
      title: discipline.title,
      subtitle: discipline.subtitle,
      selected: _disciplineIndex == index,
      onTap: () {
        setState(() {
          _disciplineIndex = index;
        });
      },
    );
  }

  // ---------- Build ----------
  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: AuthColors.background,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: [
            AuthHeader(title: 'Create Account', avatarUrl: _avatarUrl),
            Expanded(
              child: SingleChildScrollView(
                keyboardDismissBehavior:
                    ScrollViewKeyboardDismissBehavior.onDrag,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const RegisterHero(imageUrl: _heroImageUrl),
                    Transform.translate(
                      offset: const Offset(0, -8),
                      child: Padding(
                        padding: EdgeInsets.fromLTRB(
                          16,
                          0,
                          16,
                          32 + bottomInset,
                        ),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // ---------- Full name ----------
                              const _FieldLabel(
                                title: 'Full Name',
                                trailing: _FieldTag('REQUIRED'),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _nameController,
                                textInputAction: TextInputAction.next,
                                textCapitalization: TextCapitalization.words,
                                style: _inputStyle,
                                cursorColor: AuthColors.primary,
                                decoration: _inputDecoration(
                                  hint: 'e.g. Aayush Shrestha',
                                  icon: Icons.person_outline,
                                ),
                                validator: (value) {
                                  if (value == null || value.trim().isEmpty) {
                                    return 'Please enter your full name';
                                  }
                                  if (value.trim().length < 2) {
                                    return 'Name is too short';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),

                              // ---------- Email ----------
                              const _FieldLabel(
                                title: 'Email Address',
                                trailing: _FieldTag('VERIFIED ID'),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _emailController,
                                keyboardType: TextInputType.emailAddress,
                                textInputAction: TextInputAction.next,
                                autocorrect: false,
                                style: _inputStyle,
                                cursorColor: AuthColors.primary,
                                decoration: _inputDecoration(
                                  hint: 'athlete@resolve.np',
                                  icon: Icons.mail_outline,
                                ),
                                validator: (value) {
                                  final email = value?.trim() ?? '';
                                  if (email.isEmpty) {
                                    return 'Please enter your email';
                                  }
                                  if (!RegExp(r'^[^@\s]+@[^@\s]+\.[^@\s]+$')
                                      .hasMatch(email)) {
                                    return 'Please enter a valid email';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 12),

                              // ---------- Password ----------
                              _FieldLabel(
                                title: 'Security Passcode',
                                trailing: _FieldTag(
                                  'STRENGTH: $_strengthLabel',
                                  color: AuthColors.primary,
                                  letterSpacing: 0,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _passwordController,
                                obscureText: _hidePassword,
                                enableSuggestions: false,
                                autocorrect: false,
                                textInputAction: TextInputAction.next,
                                style: _inputStyle,
                                cursorColor: AuthColors.primary,
                                onChanged: (_) => setState(() {}),
                                decoration: _inputDecoration(
                                  hint: '••••••••••••',
                                  icon: Icons.lock_outline,
                                  rightPadding: 4,
                                  suffixIcon: _VisibilityButton(
                                    hidden: _hidePassword,
                                    onPressed: () {
                                      setState(() {
                                        _hidePassword = !_hidePassword;
                                      });
                                    },
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please create a passcode';
                                  }
                                  if (!_hasMinLength ||
                                      !_hasNumber ||
                                      !_hasSymbol) {
                                    return 'Use 8+ characters with a number '
                                        'and a symbol';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 4),
                              _StrengthMeter(filled: _strengthBars),
                              const SizedBox(height: 4),
                              Row(
                                children: [
                                  _RequirementChip(
                                    label: '8+ chars',
                                    met: _hasMinLength,
                                  ),
                                  const SizedBox(width: 12),
                                  _RequirementChip(
                                    label: '1 number',
                                    met: _hasNumber,
                                  ),
                                  const SizedBox(width: 12),
                                  _RequirementChip(
                                    label: '1 symbol',
                                    met: _hasSymbol,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),

                              // ---------- Confirm passcode ----------
                              _FieldLabel(
                                title: 'Confirm Passcode',
                                trailing: _MatchTag(
                                  hasInput: _confirmController.text.isNotEmpty,
                                  matches: _passwordsMatch,
                                ),
                              ),
                              const SizedBox(height: 6),
                              TextFormField(
                                controller: _confirmController,
                                obscureText: true,
                                enableSuggestions: false,
                                autocorrect: false,
                                textInputAction: TextInputAction.done,
                                style: _inputStyle,
                                cursorColor: AuthColors.primary,
                                onChanged: (_) => setState(() {}),
                                onFieldSubmitted: (_) => _submit(),
                                decoration: _inputDecoration(
                                  hint: '••••••••••••',
                                  icon: Icons.lock_reset,
                                  rightPadding: 4,
                                  suffixIcon: Icon(
                                    Icons.done_all,
                                    size: 20,
                                    color: _passwordsMatch
                                        ? AuthColors.primary
                                        : AuthColors.onSurfaceVariant
                                              .withValues(alpha: 0.4),
                                  ),
                                ),
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please confirm your passcode';
                                  }
                                  if (value != _passwordController.text) {
                                    return 'Passcodes do not match';
                                  }
                                  return null;
                                },
                              ),
                              const SizedBox(height: 24),

                              // ---------- Primary discipline ----------
                              const Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    'PRIMARY DISCIPLINE',
                                    style: _sectionLabelStyle,
                                  ),
                                  _FieldTag('SPLIT OPTIMIZER'),
                                ],
                              ),
                              const SizedBox(height: 8),
                              LayoutBuilder(
                                builder: (context, constraints) {
                                  final cardWidth =
                                      (constraints.maxWidth - 10) / 2;
                                  return Column(
                                    children: [
                                      for (var row = 0; row < 2; row++)
                                        Padding(
                                          padding: EdgeInsets.only(
                                            top: row == 0 ? 0 : 10,
                                          ),
                                          child: IntrinsicHeight(
                                            child: Row(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.stretch,
                                              children: [
                                                for (
                                                  var col = 0;
                                                  col < 2;
                                                  col++
                                                ) ...[
                                                  if (col > 0)
                                                    const SizedBox(width: 10),
                                                  SizedBox(
                                                    width: cardWidth,
                                                    child: _buildDiscipline(
                                                      row * 2 + col,
                                                    ),
                                                  ),
                                                ],
                                              ],
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                              const SizedBox(height: 20),

                              // ---------- Experience level ----------
                              const Text(
                                'EXPERIENCE LEVEL',
                                style: _sectionLabelStyle,
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: AuthColors.border.withValues(
                                    alpha: 0.4,
                                  ),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(color: AuthColors.border),
                                ),
                                child: Row(
                                  children: [
                                    for (
                                      var i = 0;
                                      i < _levels.length;
                                      i++
                                    ) ...[
                                      if (i > 0) const SizedBox(width: 8),
                                      Expanded(
                                        child: _LevelButton(
                                          label: _levels[i],
                                          selected: _levelIndex == i,
                                          onTap: () {
                                            setState(() {
                                              _levelIndex = i;
                                            });
                                          },
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                              const SizedBox(height: 24),

                              // ---------- Terms ----------
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        _acceptedTerms = !_acceptedTerms;
                                      });
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.only(top: 2),
                                      child: AnimatedContainer(
                                        duration: const Duration(
                                          milliseconds: 150,
                                        ),
                                        width: 20,
                                        height: 20,
                                        decoration: BoxDecoration(
                                          color: _acceptedTerms
                                              ? AuthColors.primaryContainer
                                              : Colors.white,
                                          borderRadius: BorderRadius.circular(
                                            4,
                                          ),
                                          border: Border.all(
                                            color: _acceptedTerms
                                                ? AuthColors.primaryContainer
                                                : AuthColors.border,
                                            width: 2,
                                          ),
                                        ),
                                        child: _acceptedTerms
                                            ? const Icon(
                                                Icons.check,
                                                size: 16,
                                                color: AuthColors
                                                    .onPrimaryContainer,
                                              )
                                            : null,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: Text.rich(
                                      TextSpan(
                                        style: const TextStyle(
                                          fontSize: 12,
                                          height: 16 / 12,
                                          color: AuthColors.onSurfaceVariant,
                                        ),
                                        children: [
                                          const TextSpan(text: 'I accept the '),
                                          TextSpan(
                                            text:
                                                'Resolve Athlete Terms & '
                                                'Conditions',
                                            recognizer: _termsRecognizer,
                                            style: const TextStyle(
                                              color: AuthColors.onSurface,
                                              fontWeight: FontWeight.w600,
                                              decoration:
                                                  TextDecoration.underline,
                                              decorationColor:
                                                  AuthColors.primaryContainer,
                                              decorationThickness: 2,
                                            ),
                                          ),
                                          const TextSpan(
                                            text:
                                                ' and understand load cell '
                                                'calibration protocol.',
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 24),

                              // ---------- Submit ----------
                              _PrimaryButton(onPressed: _submit),
                              const SizedBox(height: 16),

                              // ---------- Divider ----------
                              const Row(
                                children: [
                                  Expanded(
                                    child: Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: AuthColors.border,
                                    ),
                                  ),
                                  Padding(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: 12,
                                    ),
                                    child: Text(
                                      'OR REGISTER WITH',
                                      style: TextStyle(
                                        fontSize: 10,
                                        height: 14 / 10,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: 1,
                                        color: AuthColors.onSurfaceVariant,
                                      ),
                                    ),
                                  ),
                                  Expanded(
                                    child: Divider(
                                      height: 1,
                                      thickness: 1,
                                      color: AuthColors.border,
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),

                              // ---------- Social ----------
                              Row(
                                children: [
                                  Expanded(
                                    child: _SocialButton(
                                      asset: 'assets/images/google_logo.png',
                                      label: 'Google',
                                      onTap: () =>
                                          _showComingSoon('Google sign-up'),
                                    ),
                                  ),
                                  const SizedBox(width: 12),
                                  Expanded(
                                    child: _SocialButton(
                                      asset: 'assets/images/apple_logo.png',
                                      label: 'Apple',
                                      onTap: () =>
                                          _showComingSoon('Apple sign-up'),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 20),

                              // ---------- Sign in ----------
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  const Text(
                                    'Already have an account?',
                                    style: TextStyle(
                                      fontSize: 14,
                                      height: 20 / 14,
                                      color: AuthColors.onSurfaceVariant,
                                    ),
                                  ),
                                  const SizedBox(width: 6),
                                  GestureDetector(
                                    onTap: _goToLogin,
                                    child: const Text(
                                      'Sign In',
                                      style: TextStyle(
                                        fontSize: 16,
                                        height: 22 / 16,
                                        fontWeight: FontWeight.w700,
                                        letterSpacing: -0.16,
                                        color: AuthColors.primary,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// =====================================================================
// Shared styles
// =====================================================================

const TextStyle _inputStyle = TextStyle(
  fontSize: 14,
  height: 20 / 14,
  color: AuthColors.onSurface,
);

const TextStyle _sectionLabelStyle = TextStyle(
  fontSize: 12,
  height: 16 / 12,
  fontWeight: FontWeight.w700,
  letterSpacing: 0.6,
  color: AuthColors.onSurfaceVariant,
);

InputDecoration _inputDecoration({
  required String hint,
  required IconData icon,
  Widget? suffixIcon,
  double rightPadding = 16,
}) {
  OutlineInputBorder border(Color color, [double width = 1]) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(8),
      borderSide: BorderSide(color: color, width: width),
    );
  }

  return InputDecoration(
    isDense: true,
    filled: true,
    fillColor: Colors.white,
    hintText: hint,
    hintStyle: TextStyle(
      fontSize: 14,
      height: 20 / 14,
      color: AuthColors.onSurfaceVariant.withValues(alpha: 0.5),
    ),
    prefixIcon: Icon(icon, size: 20, color: AuthColors.onSurfaceVariant),
    prefixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 48),
    suffixIcon: suffixIcon,
    suffixIconConstraints: const BoxConstraints(minWidth: 44, minHeight: 48),
    contentPadding: EdgeInsets.fromLTRB(0, 14, rightPadding, 14),
    border: border(AuthColors.border),
    enabledBorder: border(AuthColors.border),
    focusedBorder: border(AuthColors.primaryContainer, 2),
    errorBorder: border(AuthColors.error),
    focusedErrorBorder: border(AuthColors.error, 2),
    errorStyle: const TextStyle(
      fontSize: 11,
      height: 1.3,
      color: AuthColors.error,
    ),
  );
}

// =====================================================================
// Small building blocks
// =====================================================================

class _FieldLabel extends StatelessWidget {
  final String title;
  final Widget trailing;

  const _FieldLabel({required this.title, required this.trailing});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            title.toUpperCase(),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              fontSize: 12,
              height: 16 / 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: AuthColors.onSurfaceVariant,
            ),
          ),
        ),
        const SizedBox(width: 8),
        trailing,
      ],
    );
  }
}

class _FieldTag extends StatelessWidget {
  final String text;
  final Color? color;
  final double letterSpacing;

  const _FieldTag(this.text, {this.color, this.letterSpacing = 0.6});

  @override
  Widget build(BuildContext context) {
    return Text(
      text.toUpperCase(),
      style: TextStyle(
        fontSize: 10,
        height: 14 / 10,
        fontWeight: FontWeight.w700,
        letterSpacing: letterSpacing,
        color: color ?? AuthColors.onSurfaceVariant.withValues(alpha: 0.7),
      ),
    );
  }
}

class _MatchTag extends StatelessWidget {
  final bool hasInput;
  final bool matches;

  const _MatchTag({required this.hasInput, required this.matches});

  @override
  Widget build(BuildContext context) {
    if (!hasInput) return const _FieldTag('REQUIRED');
    if (!matches) {
      return const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.error_outline, size: 14, color: AuthColors.error),
          SizedBox(width: 2),
          _FieldTag('MISMATCH', color: AuthColors.error),
        ],
      );
    }
    return const Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.verified, size: 14, color: AuthColors.primary),
        SizedBox(width: 2),
        _FieldTag('MATCH', color: AuthColors.primary),
      ],
    );
  }
}

class _VisibilityButton extends StatelessWidget {
  final bool hidden;
  final VoidCallback onPressed;

  const _VisibilityButton({required this.hidden, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(minWidth: 36, minHeight: 36),
      tooltip: hidden ? 'Show passcode' : 'Hide passcode',
      onPressed: onPressed,
      icon: Icon(
        hidden ? Icons.visibility : Icons.visibility_off,
        size: 20,
        color: AuthColors.onSurfaceVariant,
      ),
    );
  }
}

class _StrengthMeter extends StatelessWidget {
  final int filled;

  const _StrengthMeter({required this.filled});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        for (var i = 0; i < 4; i++) ...[
          if (i > 0) const SizedBox(width: 6),
          Expanded(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              height: 6,
              decoration: BoxDecoration(
                color: i < filled
                    ? AuthColors.primaryContainer
                    : AuthColors.border.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(999),
              ),
            ),
          ),
        ],
      ],
    );
  }
}

class _RequirementChip extends StatelessWidget {
  final String label;
  final bool met;

  const _RequirementChip({required this.label, required this.met});

  @override
  Widget build(BuildContext context) {
    final color = met
        ? AuthColors.primary
        : AuthColors.onSurfaceVariant.withValues(alpha: 0.6);

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(
          met ? Icons.check_circle : Icons.radio_button_unchecked,
          size: 14,
          color: color,
        ),
        const SizedBox(width: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 10,
            height: 14 / 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.6,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _DisciplineCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final bool selected;
  final VoidCallback onTap;

  const _DisciplineCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: selected ? AuthColors.primaryContainer : AuthColors.border,
            width: selected ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: selected ? 0.08 : 0.05),
              blurRadius: selected ? 6 : 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (selected)
              Positioned(
                left: 0,
                top: 0,
                bottom: 0,
                child: Container(
                  width: 6,
                  decoration: const BoxDecoration(
                    color: AuthColors.primaryContainer,
                    borderRadius: BorderRadius.horizontal(
                      left: Radius.circular(6),
                    ),
                  ),
                ),
              ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: selected
                          ? AuthColors.primaryContainer
                          : AuthColors.background,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(
                      icon,
                      size: 22,
                      color: selected
                          ? AuthColors.onPrimaryContainer
                          : AuthColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 16,
                            height: 22 / 16,
                            letterSpacing: -0.16,
                            fontWeight: selected
                                ? FontWeight.w700
                                : FontWeight.w600,
                            color: AuthColors.onSurface,
                          ),
                        ),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 10,
                            height: 14 / 10,
                            letterSpacing: 0.6,
                            fontWeight: selected
                                ? FontWeight.w600
                                : FontWeight.w700,
                            color: selected
                                ? AuthColors.primary
                                : AuthColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LevelButton extends StatelessWidget {
  final String label;
  final bool selected;
  final VoidCallback onTap;

  const _LevelButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(vertical: 8),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: selected ? AuthColors.border : Colors.transparent,
          ),
          boxShadow: selected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 2,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 12,
            height: 16 / 12,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w600,
            color: selected
                ? AuthColors.onSurface
                : AuthColors.onSurfaceVariant,
          ),
        ),
      ),
    );
  }
}

class _PrimaryButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _PrimaryButton({required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: AuthColors.primaryContainer,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AuthColors.accentHover),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Center(
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  child: Text(
                    'CREATE ACCOUNT & START TRAINING',
                    style: const TextStyle(
                      fontSize: 16,
                      height: 22 / 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.4,
                      color: AuthColors.onPrimaryContainer,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward,
                size: 20,
                color: AuthColors.onPrimaryContainer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String asset;
  final String label;
  final VoidCallback onTap;

  const _SocialButton({
    required this.asset,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: AuthColors.border),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              blurRadius: 2,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              asset,
              width: 20,
              height: 20,
              errorBuilder: (context, error, stackTrace) => const Icon(
                Icons.account_circle,
                size: 20,
                color: AuthColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                height: 22 / 16,
                fontWeight: FontWeight.w600,
                letterSpacing: -0.16,
                color: AuthColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
