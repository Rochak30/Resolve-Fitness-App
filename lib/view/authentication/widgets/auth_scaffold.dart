import 'package:flutter/material.dart';
import 'package:resolve/view/authentication/widgets/auth_header.dart';
import 'package:resolve/view/authentication/widgets/ridge_banner.dart';

/// Shared page layout for the auth screens:
/// banner -> header -> [children] -> (space) -> [footer] pinned to the bottom.
/// Scrolls when the keyboard is open or the screen is small.
class AuthScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final List<Widget> children;
  final List<Widget> footer;

  const AuthScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.children,
    required this.footer,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) => SingleChildScrollView(
            keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const RidgeBanner(),

                    // ---------- Header + form ----------
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          AuthHeader(title: title, subtitle: subtitle),
                          const SizedBox(height: 24),
                          ...children,
                        ],
                      ),
                    ),

                    const Spacer(),

                    // ---------- Button + links ----------
                    Padding(
                      padding: const EdgeInsets.fromLTRB(20, 24, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: footer,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
