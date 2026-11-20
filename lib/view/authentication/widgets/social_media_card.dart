import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:resolve/core/app_colors.dart';
import 'package:resolve/core/app_text_styles.dart';

enum SocialProvider { google, apple }

/// Social sign-in button matching the Stitch design
/// (48px tall, white surface, hairline outline, 8px radius).
class SocialMediaCard extends StatefulWidget {
  final SocialProvider provider;
  final VoidCallback? onPressed;

  const SocialMediaCard({
    super.key,
    required this.provider,
    this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 70,
      child: Card(
        // ---------- Look: white with a thin border ----------
        color: Colors.white,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: AppColors.border),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // ---------- Logo ----------
            Image.asset(imagePath, width: 40, height: 40),
            const SizedBox(width: 10),

class _SocialMediaCardState extends State<SocialMediaCard> {
  bool _pressed = false;

  static const String _googleSvg = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
  <path fill="#263238" d="M12.24 10.285V13.4h6.887C18.2 16.14 15.645 18 12.24 18c-3.315 0-6-2.685-6-6s2.685-6 6-6c1.47 0 2.81.53 3.85 1.41l2.36-2.36C16.99 3.59 14.77 2.7 12.24 2.7 7.08 2.7 2.9 6.88 2.9 12.04s4.18 9.34 9.34 9.34c5.38 0 8.94-3.79 8.94-9.1 0-.62-.06-1.22-.17-1.995H12.24z"/>
</svg>
''';

  static const String _appleSvg = '''
<svg viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
  <path fill="#263238" d="M18.71 19.5c-.83 1.24-1.71 2.45-3.05 2.47-1.34.03-1.77-.79-3.29-.79-1.53 0-2 .77-3.27.82-1.31.05-2.3-1.32-3.14-2.53C4.25 17 2.94 12.45 4.7 9.39c.87-1.52 2.43-2.48 4.12-2.51 1.28-.02 2.5.87 3.29.87.78 0 2.26-1.07 3.81-.91.65.03 2.47.26 3.64 1.98-.09.06-2.17 1.28-2.15 3.81.03 3.02 2.65 4.03 2.68 4.04-.03.07-.42 1.44-1.38 2.83M15.97 6.37c.62-.75 1.04-1.8.93-2.85-.9.04-1.99.6-2.63 1.35-.57.65-1.07 1.72-.94 2.73.99.08 2.02-.48 2.64-1.23z"/>
</svg>
''';

  @override
  Widget build(BuildContext context) {
    final isGoogle = widget.provider == SocialProvider.google;

    return Listener(
      onPointerDown: (_) => setState(() => _pressed = true),
      onPointerUp: (_) => setState(() => _pressed = false),
      onPointerCancel: (_) => setState(() => _pressed = false),
      child: AnimatedScale(
        scale: _pressed ? 0.98 : 1,
        duration: const Duration(milliseconds: 120),
        child: Material(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(8),
          child: InkWell(
            onTap: widget.onPressed,
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: AppColors.outlineVariant),
                boxShadow: const [
                  BoxShadow(
                    color: Color(0x0D000000),
                    blurRadius: 2,
                    offset: Offset(0, 1),
                  ),
                ],
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.string(
                    isGoogle ? _googleSvg : _appleSvg,
                    width: 16,
                    height: 16,
                  ),
                  const SizedBox(width: 10),
                  Text(
                    isGoogle ? 'Google' : 'Apple',
                    style: AppTextStyles.labelMd.copyWith(
                      color: AppColors.onSurface,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.26, // tracking-tight
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
