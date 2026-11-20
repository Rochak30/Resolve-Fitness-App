// Owner: Rochak

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:resolve/core/app_colors.dart';
import 'package:resolve/core/app_routes.dart';
import 'package:resolve/core/app_text_styles.dart';
import 'package:resolve/view/authentication/widgets/social_media_card.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen>
    with SingleTickerProviderStateMixin {
  // ---------- Controllers ----------
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  // ---------- State ----------
  bool _obscurePassword = true;
  bool _keepSession = true;

  // ---------- Animations ----------
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  // ---------- Tappable spans ----------
  late final TapGestureRecognizer _signUpRecognizer;

  static const String _heroImageUrl =
      'https://lh3.googleusercontent.com/aida/AEtjO1WKIFHU-NL0_dP8Z3GlRJ_QIPCF49GCuhGjXfS_MzX6IN3o8ShyUS_UKlua1KrzkJ7VsCYjME6pwiv-QFUKMdS0CIuABu1LzAODGwNLm4JTwBRmwewj3IIR_NyXoC1pKJctjujzOUYltE5YrkV-DaMgB8qjviiAjMaa93bhnOrCYN5W7Pm1LKgbUvm7cgPyPXGt6TlWRKY6P6VOksXd7gRVM5t1_StdHZWYlUUuHyQ';

  @override
  void initState() {
    super.initState();

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1, end: 0.45).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );

    _signUpRecognizer = TapGestureRecognizer()
      ..onTap = () => Navigator.pushNamed(context, AppRoutes.register);
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _pulseController.dispose();
    _signUpRecognizer.dispose();
    super.dispose();
  }

  // ---------------------------------------------------------------
  // Actions
  // ---------------------------------------------------------------
  void _handleSignIn() {
    FocusScope.of(context).unfocus();
    if (!(_formKey.currentState?.validate() ?? false)) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Signing in…'),
        backgroundColor: AppColors.tealDark,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _handleGuest() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Offline mode coming soon.'),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  // ---------------------------------------------------------------
  // Build
  // ---------------------------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildHeroCard(),
                const SizedBox(height: 24),
                _buildIntro(),
                const SizedBox(height: 24),
                _buildForm(),
                _buildDivider(),
                _buildSocialRow(),
                const SizedBox(height: 24),
                _buildFooterCard(),
                const SizedBox(height: 32),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ---------- Hero banner ----------
  Widget _buildHeroCard() {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: SizedBox(
        height: 208,
        child: Stack(
          fit: StackFit.expand,
          children: [
            // ---------- Photo ----------
            Image.network(
              _heroImageUrl,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              errorBuilder: (_, _, _) => const _HeroFallback(),
              loadingBuilder: (context, child, progress) =>
                  progress == null ? child : const _HeroFallback(),
            ),

            // ---------- Bottom fade to white ----------
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.white,
                    Colors.white.withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                  stops: const [0, 0.5, 1],
                ),
              ),
            ),

            // ---------- Left fade to white ----------
            DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),

            // ---------- Altitude badge ----------
            Positioned(
              top: 16,
              left: 16,
              right: 16,
              child: Align(
                alignment: Alignment.centerLeft,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 6,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.6),
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0x0D000000),
                        blurRadius: 2,
                        offset: Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      FadeTransition(
                        opacity: _pulseAnimation,
                        child: Container(
                          width: 8,
                          height: 8,
                          decoration: const BoxDecoration(
                            color: AppColors.tealDark,
                            shape: BoxShape.circle,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Flexible(
                        child: Text(
                          'KTM ALTITUDE LAB • 1,400M+',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: AppTextStyles.labelSm.copyWith(
                            color: AppColors.tealDark,
                            letterSpacing: 0.77, // tracking-wider
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // ---------- Brand mark ----------
            Positioned(
              left: 16,
              right: 16,
              bottom: 12,
              child: Text(
                'RESOLVE',
                style: AppTextStyles.headlineSm.copyWith(
                  color: AppColors.onSurface,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.18,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ---------- Intro copy ----------
  Widget _buildIntro() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.brandTeal.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  'SESSION SYNC',
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.tealDark,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Flexible(
                child: Text(
                  '• POKHARA • KTM',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTextStyles.labelSm.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            'Welcome Back, Athlete',
            style: AppTextStyles.headlineLg.copyWith(
              color: AppColors.onSurface,
              fontWeight: FontWeight.w800,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Sign in to sync your high-altitude pace, tactical lifting logs, '
            'and disciplined training streaks.',
            style: AppTextStyles.bodyMd.copyWith(
              color: AppColors.onSurfaceVariant,
              height: 1.625,
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Form ----------
  Widget _buildForm() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // ---------- Email ----------
        _FieldGroup(
          label: 'Account Email',
          child: _AuthTextField(
            controller: _emailController,
            hint: 'athlete@altitude.np',
            icon: Icons.alternate_email,
            keyboardType: TextInputType.emailAddress,
            textInputAction: TextInputAction.next,
            validator: (value) {
              final text = value?.trim() ?? '';
              if (text.isEmpty) return 'Enter your account email';
              final isEmail = RegExp(
                r'^[^@\s]+@[^@\s]+\.[^@\s]+$',
              ).hasMatch(text);
              return isEmail ? null : 'Enter a valid email address';
            },
          ),
        ),
        const SizedBox(height: 16),

        // ---------- Password ----------
        _FieldGroup(
          label: 'Security Passkey',
          trailing: GestureDetector(
            onTap: () =>
                Navigator.pushNamed(context, AppRoutes.forgotPassword),
            child: Text(
              'Forgot Key?',
              style: AppTextStyles.labelSm.copyWith(
                color: AppColors.tealDark,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          child: _AuthTextField(
            controller: _passwordController,
            hint: '••••••••••••',
            icon: Icons.lock_outline,
            obscureText: _obscurePassword,
            letterSpacing: _obscurePassword ? 1.5 : 0.3,
            textInputAction: TextInputAction.done,
            onSubmitted: (_) => _handleSignIn(),
            suffix: IconButton(
              onPressed: () =>
                  setState(() => _obscurePassword = !_obscurePassword),
              icon: Icon(
                _obscurePassword ? Icons.visibility : Icons.visibility_off,
                size: 20,
                color: AppColors.onSurfaceVariant,
              ),
              splashRadius: 20,
              padding: const EdgeInsets.only(left: 8, right: 14),
              constraints: const BoxConstraints(),
              tooltip: 'Toggle password view',
            ),
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Enter your security passkey';
              }
              if (value.length < 6) return 'Passkey must be 6+ characters';
              return null;
            },
          ),
        ),
        const SizedBox(height: 16),

        // ---------- Keep session ----------
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
          child: GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: () => setState(() => _keepSession = !_keepSession),
            child: Row(
              children: [
                SizedBox(
                  width: 18,
                  height: 18,
                  child: Checkbox(
                    value: _keepSession,
                    onChanged: (value) =>
                        setState(() => _keepSession = value ?? false),
                    materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    visualDensity: VisualDensity.compact,
                    side: const BorderSide(
                      color: AppColors.outlineVariant,
                      width: 1.5,
                    ),
                    activeColor: AppColors.tealDark,
                    checkColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Flexible(
                  child: Text(
                    'Keep instrument session active',
                    style: AppTextStyles.bodySm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 24),

        // ---------- Sign in ----------
        _PressableScale(
          child: SizedBox(
            height: 52,
            child: ElevatedButton(
              onPressed: _handleSignIn,
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.brandTeal,
                foregroundColor: AppColors.onBrandTeal,
                elevation: 1,
                shadowColor: Colors.black26,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                'SIGN IN',
                style: AppTextStyles.labelLg.copyWith(
                  color: AppColors.onBrandTeal,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.75, // tracking-wider
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  // ---------- "RESOLVE" divider ----------
  Widget _buildDivider() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 28),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Container(height: 1, color: AppColors.outlineVariant),
          Container(
            color: AppColors.background,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text(
              'RESOLVE',
              style: AppTextStyles.labelSm.copyWith(
                color: AppColors.onSurfaceVariant,
                fontWeight: FontWeight.w600,
                letterSpacing: 1.1, // tracking-widest
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ---------- Social providers ----------
  Widget _buildSocialRow() {
    return Row(
      children: [
        Expanded(
          child: SocialMediaCard(
            provider: SocialProvider.google,
            onPressed: () {},
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: SocialMediaCard(
            provider: SocialProvider.apple,
            onPressed: () {},
          ),
        ),
      ],
    );
  }

  // ---------- Footer card ----------
  Widget _buildFooterCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outlineVariant),
        boxShadow: const [
          BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Text.rich(
            TextSpan(
              children: [
                TextSpan(
                  text: 'New to high-altitude performance? ',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.onSurfaceVariant,
                  ),
                ),
                TextSpan(
                  text: 'Create Athlete Account',
                  style: AppTextStyles.bodySm.copyWith(
                    color: AppColors.tealDark,
                    fontWeight: FontWeight.w700,
                  ),
                  recognizer: _signUpRecognizer,
                ),
              ],
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 14),
          Container(height: 1, color: AppColors.outlineVariant),
          const SizedBox(height: 14),
          GestureDetector(
            onTap: _handleGuest,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(
                  Icons.sports_martial_arts,
                  size: 16,
                  color: AppColors.onSurfaceVariant,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    'Train as Guest (Offline Mode)',
                    style: AppTextStyles.labelSm.copyWith(
                      color: AppColors.onSurfaceVariant,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.77, // tracking-wider
                    ),
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

// ---------------------------------------------------------------
// Reusable pieces
// ---------------------------------------------------------------

/// Label + field stack (space-y-1.5 in the design).
class _FieldGroup extends StatelessWidget {
  final String label;
  final Widget child;
  final Widget? trailing;

  const _FieldGroup({
    required this.label,
    required this.child,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label.toUpperCase(),
                  style: AppTextStyles.labelMd.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.65, // tracking-wider
                  ),
                ),
              ),
              ?trailing,
            ],
          ),
        ),
        const SizedBox(height: 6),
        child,
      ],
    );
  }
}

/// Icon + input + optional suffix inside the design's outlined container.
class _AuthTextField extends StatefulWidget {
  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscureText;
  final Widget? suffix;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final double letterSpacing;
  final String? Function(String?)? validator;
  final ValueChanged<String>? onSubmitted;

  const _AuthTextField({
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscureText = false,
    this.suffix,
    this.keyboardType,
    this.textInputAction,
    this.letterSpacing = 0.3,
    this.validator,
    this.onSubmitted,
  });

  @override
  State<_AuthTextField> createState() => _AuthTextFieldState();
}

class _AuthTextFieldState extends State<_AuthTextField> {
  final FocusNode _focusNode = FocusNode();
  bool _focused = false;

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (_focused != _focusNode.hasFocus) {
        setState(() => _focused = _focusNode.hasFocus);
      }
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 150),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainer,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: _focused ? AppColors.brandTeal : AppColors.outlineVariant,
        ),
        boxShadow: [
          const BoxShadow(
            color: Color(0x0D000000),
            blurRadius: 2,
            offset: Offset(0, 1),
          ),
          if (_focused)
            BoxShadow(
              color: AppColors.brandTeal.withValues(alpha: 0.4),
              spreadRadius: 2,
              blurRadius: 0,
            ),
        ],
      ),
      child: Row(
        children: [
          // ---------- Leading icon ----------
          Padding(
            padding: const EdgeInsets.only(left: 14, right: 4),
            child: Icon(
              widget.icon,
              size: 20,
              color: AppColors.onSurfaceVariant,
            ),
          ),

          // ---------- Input ----------
          Expanded(
            child: TextFormField(
              controller: widget.controller,
              focusNode: _focusNode,
              obscureText: widget.obscureText,
              obscuringCharacter: '•',
              keyboardType: widget.keyboardType,
              textInputAction: widget.textInputAction,
              onFieldSubmitted: widget.onSubmitted,
              validator: widget.validator,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              cursorColor: AppColors.tealDark,
              style: AppTextStyles.labelLg.copyWith(
                color: AppColors.onSurface,
                letterSpacing: widget.letterSpacing,
              ),
              decoration: InputDecoration(
                isDense: true,
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                errorBorder: InputBorder.none,
                focusedErrorBorder: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                hintText: widget.hint,
                hintStyle: AppTextStyles.labelLg.copyWith(
                  color: AppColors.outline.withValues(alpha: 0.7),
                  letterSpacing: 0.3,
                ),
                errorStyle: AppTextStyles.bodySm.copyWith(
                  color: const Color(0xFFBA1A1A),
                ),
              ),
            ),
          ),

          // ---------- Suffix ----------
          ?widget.suffix,
        ],
      ),
    );
  }
}

/// Slight scale-down while pressed (active:scale-[0.98]).
class _PressableScale extends StatefulWidget {
  final Widget child;

  const _PressableScale({required this.child});

  @override
  State<_PressableScale> createState() => _PressableScaleState();
}

class _PressableScaleState extends State<_PressableScale> {
  bool _pressed = false;

  void _setPressed(bool value) {
    if (_pressed != value) setState(() => _pressed = value);
  }

  @override
  Widget build(BuildContext context) {
    return Listener(
      onPointerDown: (_) => _setPressed(true),
      onPointerUp: (_) => _setPressed(false),
      onPointerCancel: (_) => _setPressed(false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: widget.child,
      ),
    );
  }
}

/// Stand-in artwork while the hero photo loads (or if it can't).
class _HeroFallback extends StatelessWidget {
  const _HeroFallback();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomLeft,
          end: Alignment.topRight,
          colors: [Color(0xFFE4EDE9), Color(0xFFA9C4B9), Color(0xFF6E9C8E)],
        ),
      ),
      child: CustomPaint(painter: _MountainPainter()),
    );
  }
}

class _MountainPainter extends CustomPainter {
  const _MountainPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final far = Path()
      ..moveTo(0, size.height * 0.72)
      ..lineTo(size.width * 0.20, size.height * 0.44)
      ..lineTo(size.width * 0.36, size.height * 0.62)
      ..lineTo(size.width * 0.54, size.height * 0.34)
      ..lineTo(size.width * 0.76, size.height * 0.66)
      ..lineTo(size.width, size.height * 0.48)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    final near = Path()
      ..moveTo(0, size.height * 0.86)
      ..lineTo(size.width * 0.26, size.height * 0.60)
      ..lineTo(size.width * 0.46, size.height * 0.78)
      ..lineTo(size.width * 0.68, size.height * 0.56)
      ..lineTo(size.width, size.height * 0.82)
      ..lineTo(size.width, size.height)
      ..lineTo(0, size.height)
      ..close();

    canvas.drawPath(far, Paint()..color = const Color(0x1F004D40));
    canvas.drawPath(near, Paint()..color = const Color(0x2E004D40));
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
