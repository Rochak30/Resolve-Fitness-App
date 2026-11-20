import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:resolve/view/authentication/auth_colors.dart';

/// Fixed, blurred header used by the authentication screens.
class AuthHeader extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;
  final String? avatarUrl;

  const AuthHeader({
    super.key,
    required this.title,
    this.onBack,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 24, sigmaY: 24),
        child: Container(
          height: 64,
          padding: const EdgeInsets.only(left: 8, right: 16),
          decoration: BoxDecoration(
            color: AuthColors.background.withValues(alpha: 0.9),
            border: Border(
              bottom: BorderSide(
                color: AuthColors.border.withValues(alpha: 0.6),
              ),
            ),
          ),
          child: Row(
            children: [
              // ---------- Back ----------
              SizedBox(
                width: 44,
                height: 44,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  tooltip: 'Go back',
                  onPressed: onBack ?? () => Navigator.of(context).maybePop(),
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 24,
                    color: AuthColors.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 4),

              // ---------- Title ----------
              Expanded(
                child: Text(
                  title.toUpperCase(),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 22 / 16,
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.16,
                    color: AuthColors.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 8),

              // ---------- Avatar ----------
              _HeaderAvatar(url: avatarUrl),
            ],
          ),
        ),
      ),
    );
  }
}

class _HeaderAvatar extends StatelessWidget {
  final String? url;

  const _HeaderAvatar({this.url});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(
          color: AuthColors.primaryContainer.withValues(alpha: 0.6),
          width: 2,
        ),
      ),
      child: ClipOval(
        child: url == null
            ? const _AvatarFallback()
            : Image.network(
                url!,
                fit: BoxFit.cover,
                filterQuality: FilterQuality.medium,
                errorBuilder: (context, error, stackTrace) =>
                    const _AvatarFallback(),
              ),
      ),
    );
  }
}

class _AvatarFallback extends StatelessWidget {
  const _AvatarFallback();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: AuthColors.border,
      alignment: Alignment.center,
      child: const Icon(
        Icons.person,
        size: 20,
        color: AuthColors.onSurfaceVariant,
      ),
    );
  }
}
