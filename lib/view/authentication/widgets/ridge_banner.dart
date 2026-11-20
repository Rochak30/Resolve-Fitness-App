import 'package:flutter/material.dart';
import 'package:resolve/core/app_colors.dart';

/// Mountain-ridge banner shown at the top of the auth screens.
/// Shows a back button automatically when there is a screen to go back to.
class RidgeBanner extends StatelessWidget {
  final String chipLabel;

  const RidgeBanner({super.key, this.chipLabel = 'KTM SPEED LAB • 1,400M'});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 150,
      child: Stack(
        children: [
          // ---------- Background + ridges ----------
          Positioned.fill(
            child: DecoratedBox(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.12),
                    Colors.white,
                  ],
                ),
              ),
              child: CustomPaint(painter: _RidgePainter()),
            ),
          ),

          // ---------- Back button + location chip ----------
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (Navigator.of(context).canPop())
                  IconButton(
                    tooltip: 'Back',
                    onPressed: () => Navigator.of(context).maybePop(),
                    style: IconButton.styleFrom(
                      backgroundColor: Colors.white,
                      fixedSize: const Size(44, 44),
                    ),
                    icon: const Icon(Icons.arrow_back, size: 20),
                  )
                else
                  const SizedBox(width: 44, height: 44),
                _LocationChip(label: chipLabel),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LocationChip extends StatelessWidget {
  final String label;

  const _LocationChip({required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 36,
      padding: const EdgeInsets.symmetric(horizontal: 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.9),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 8),
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.6,
              color: AppColors.title,
            ),
          ),
        ],
      ),
    );
  }
}

class _RidgePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // Back ridge
    final back = Path()
      ..moveTo(0, h * 0.80)
      ..lineTo(w * 0.18, h * 0.40)
      ..lineTo(w * 0.28, h * 0.60)
      ..lineTo(w * 0.50, h * 0.20)
      ..lineTo(w * 0.67, h * 0.63)
      ..lineTo(w * 0.82, h * 0.37)
      ..lineTo(w, h * 0.70)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
      back,
      Paint()..color = AppColors.primary.withValues(alpha: 0.18),
    );

    // Front ridge (fades into the page)
    final front = Path()
      ..moveTo(0, h * 0.93)
      ..lineTo(w * 0.23, h * 0.63)
      ..lineTo(w * 0.38, h * 0.83)
      ..lineTo(w * 0.59, h * 0.53)
      ..lineTo(w * 0.79, h * 0.87)
      ..lineTo(w, h * 0.67)
      ..lineTo(w, h)
      ..lineTo(0, h)
      ..close();
    canvas.drawPath(
      front,
      Paint()..color = Colors.white.withValues(alpha: 0.85),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
