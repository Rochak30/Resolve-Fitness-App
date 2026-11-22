
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:resolve/core/app_colors.dart';
import 'package:resolve/view/authentication/auth_colors.dart';

class AuthHeader extends StatelessWidget {
  final String title;
  final String? subtitle;

  // Navigation header properties
  final bool showBranding;
  final VoidCallback? onBack;
  final String? avatarUrl;

  const AuthHeader({
    super.key,
    required this.title,
    this.subtitle,
    this.showBranding = true,
    this.onBack,
    this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    return showBranding
        ? _buildBrandingHeader()
        : _buildNavigationHeader(context);
  }

  // BRANDING HEADER
  Widget _buildBrandingHeader() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Wrap(
          crossAxisAlignment: WrapCrossAlignment.end,
          spacing: 8,
          children: [
            Text(
              'RESOLVE',
              style: TextStyle(
                fontSize: 44,
                fontWeight: FontWeight.w800,
                letterSpacing: -1.5,
                height: 1,
                color: AppColors.title,
              ),
            ),
            Padding(
              padding: EdgeInsets.only(bottom: 4),
              child: Text(
                'FITNESS APP NEPAL',
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  letterSpacing: 0.8,
                  color: AppColors.primary,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Text(
          title.toUpperCase(),
          style: const TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.w800,
            letterSpacing: -0.3,
            height: 1.1,
          ),
        ),
        if (subtitle != null) ...[
          const SizedBox(height: 8),
          Text(
            subtitle!,
            style: const TextStyle(
              fontSize: 15,
              height: 1.45,
              color: AppColors.grey,
            ),
          ),
        ],
      ],
    );
  }

  // NAVIGATION HEADER
  Widget _buildNavigationHeader(BuildContext context) {
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
              SizedBox(
                width: 44,
                height: 44,
                child: IconButton(
                  padding: EdgeInsets.zero,
                  tooltip: 'Go back',
                  onPressed:
                      onBack ?? () => Navigator.of(context).maybePop(),
                  icon: const Icon(
                    Icons.arrow_back,
                    size: 24,
                    color: AuthColors.onSurface,
                  ),
                ),
              ),
              const SizedBox(width: 4),
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
              _HeaderAvatar(url: avatarUrl),
            ],
          ),
        ),
      ),
    );
  }
}

// AVATAR
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
        child: url == null || url!.isEmpty
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
