import 'package:flutter/material.dart';
import 'package:resolve/view/authentication/auth_colors.dart';

/// 320px hero banner with the athlete image, altitude pill and brand block.
class RegisterHero extends StatelessWidget {
  static const double height = 320;

  final String imageUrl;

  const RegisterHero({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          // ---------- Background image ----------
          const ColoredBox(color: AuthColors.border),
          Transform.scale(
            scale: 1.05,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              alignment: Alignment.topCenter,
              filterQuality: FilterQuality.medium,
              errorBuilder: (context, error, stackTrace) =>
                  const _HeroFallback(),
            ),
          ),

          // ---------- Fade to background (top -> bottom) ----------
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Color(0x4DECEFF1),
                  Color(0xB3ECEFF1),
                  AuthColors.background,
                ],
              ),
            ),
          ),

          // ---------- Fade to background (bottom -> top) ----------
          const DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  AuthColors.background,
                  Color(0xD9ECEFF1),
                  Color(0x00ECEFF1),
                ],
              ),
            ),
          ),

          // ---------- Foreground content ----------
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const _AltitudePill(),
                    const Spacer(),
                    _VersionChip(),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ---------- RESOLVE wordmark ----------
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          const Text(
                            'RESOLVE',
                            style: TextStyle(
                              fontSize: 38,
                              height: 42 / 38,
                              fontWeight: FontWeight.w800,
                              letterSpacing: -1.14,
                              color: AuthColors.onSurface,
                            ),
                          ),
                          const SizedBox(width: 8),
                          const Padding(
                            padding: EdgeInsets.only(bottom: 6),
                            child: Text(
                              'FITNESS APP NEPAL',
                              style: TextStyle(
                                fontSize: 10,
                                height: 14 / 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1,
                                color: AuthColors.primary,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      'CREATE ATHLETE ACCOUNT',
                      style: TextStyle(
                        fontSize: 20,
                        height: 26 / 20,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.2,
                        color: AuthColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 4),
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxWidth: 320),
                      child: const Text(
                        'Begin your high-altitude strength & endurance journey '
                        'across urban basements and Himalayan ridges.',
                        style: TextStyle(
                          fontSize: 12,
                          height: 16 / 12,
                          color: AuthColors.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AltitudePill extends StatelessWidget {
  const _AltitudePill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AuthColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: const Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _LiveDot(),
          SizedBox(width: 8),
          Text(
            'KTM SPEED LAB • 1,400M',
            style: TextStyle(
              fontSize: 10,
              height: 14 / 10,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.5,
              color: AuthColors.primary,
            ),
          ),
        ],
      ),
    );
  }
}

class _VersionChip extends StatelessWidget {
  const _VersionChip();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.85),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: AuthColors.border),
      ),
      child: const Text(
        'V2.4 // NP',
        style: TextStyle(
          fontSize: 10,
          height: 14 / 10,
          fontWeight: FontWeight.w600,
          letterSpacing: 1,
          color: AuthColors.onSurfaceVariant,
        ),
      ),
    );
  }
}

/// Small pulsing "live" indicator used inside the altitude pill.
class _LiveDot extends StatefulWidget {
  const _LiveDot();

  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 8,
      height: 8,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          final t = Curves.easeOut.transform(_controller.value);
          return Stack(
            clipBehavior: Clip.none,
            alignment: Alignment.center,
            children: [
              Transform.scale(
                scale: 1 + t * 1.4,
                child: Opacity(opacity: 0.75 * (1 - t), child: const _Dot()),
              ),
              const _Dot(),
            ],
          );
        },
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 8,
      height: 8,
      decoration: const BoxDecoration(
        color: AuthColors.primary,
        shape: BoxShape.circle,
      ),
    );
  }
}

class _HeroFallback extends StatelessWidget {
  const _HeroFallback();

  @override
  Widget build(BuildContext context) {
    return const DecoratedBox(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF455A64), Color(0xFF90A4AE), Color(0xFFCFD8DC)],
        ),
      ),
    );
  }
}
