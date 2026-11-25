// Shared widgets for US-1.6 onboarding screen.
// Styled with ProfileColors + AppTextStyles — no new colours introduced.

import 'package:flutter/material.dart';

import 'package:resolve/core/app_colors.dart';
import 'package:resolve/core/app_text_styles.dart';
import 'package:resolve/view/profile/profile_colors.dart';

// ---------------------------------------------------------------------------
// OnboardingScaffold – common page wrapper (kept for isEditing re-entry mode)
// ---------------------------------------------------------------------------

class OnboardingScaffold extends StatelessWidget {
  final String title;
  final String subtitle;
  final int stepCurrent; // 1-based
  final int stepTotal;
  final List<Widget> children;
  final Widget bottom;
  final bool showBack;

  const OnboardingScaffold({
    super.key,
    required this.title,
    required this.subtitle,
    required this.stepCurrent,
    required this.stepTotal,
    required this.children,
    required this.bottom,
    this.showBack = true,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileColors.background,
      appBar: AppBar(
        backgroundColor: ProfileColors.dark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        automaticallyImplyLeading: showBack,
        title: _StepIndicator(current: stepCurrent, total: stepTotal),
      ),
      body: Column(
        children: [
          _OnboardingHeader(title: title, subtitle: subtitle),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 20, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: children,
              ),
            ),
          ),
          _BottomBar(child: bottom),
        ],
      ),
    );
  }
}

class _StepIndicator extends StatelessWidget {
  final int current;
  final int total;
  const _StepIndicator({required this.current, required this.total});

  @override
  Widget build(BuildContext context) {
    return Text(
      'Step $current of $total',
      style: AppTextStyles.labelMd.copyWith(color: Colors.white70),
    );
  }
}

class _OnboardingHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  const _OnboardingHeader({required this.title, required this.subtitle});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
      color: ProfileColors.dark,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.headlineSm.copyWith(color: Colors.white),
          ),
          const SizedBox(height: 6),
          Text(
            subtitle,
            style: AppTextStyles.bodyMd.copyWith(
              color: Colors.white.withAlpha(178),
            ),
          ),
        ],
      ),
    );
  }
}

class _BottomBar extends StatelessWidget {
  final Widget child;
  const _BottomBar({required this.child});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: ProfileColors.border),
        ),
      ),
      child: SafeArea(top: false, child: child),
    );
  }
}

// ---------------------------------------------------------------------------
// OnboardingSectionLabel – small-caps section heading
// ---------------------------------------------------------------------------

class OnboardingSectionLabel extends StatelessWidget {
  final String label;
  const OnboardingSectionLabel({super.key, required this.label});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.labelSm.copyWith(
          color: ProfileColors.mid,
          letterSpacing: 1.2,
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// SelectableChip – multi-select or single-select pill chip
// ---------------------------------------------------------------------------

class SelectableChip extends StatelessWidget {
  final String label;
  final IconData? icon;
  final bool selected;
  final VoidCallback onTap;

  const SelectableChip({
    super.key,
    required this.label,
    this.icon,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected ? ProfileColors.accent.withAlpha(40) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: selected ? ProfileColors.accent : ProfileColors.border,
            width: selected ? 2.0 : 1.5,
          ),
        ),
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                size: 20,
                color: selected ? ProfileColors.dark : ProfileColors.mid,
              ),
              const SizedBox(width: 10),
            ],
            Expanded(
              child: Text(
                label,
                style: AppTextStyles.labelMd.copyWith(
                  color: selected ? ProfileColors.dark : ProfileColors.mid,
                ),
              ),
            ),
            AnimatedSwitcher(
              duration: const Duration(milliseconds: 150),
              child: selected
                  ? Icon(
                      Icons.check_circle,
                      key: const ValueKey('checked'),
                      size: 20,
                      color: ProfileColors.accent,
                    )
                  : Icon(
                      Icons.radio_button_unchecked,
                      key: const ValueKey('unchecked'),
                      size: 20,
                      color: ProfileColors.border,
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// OnboardingContinueButton – the primary CTA at the bottom of each step
// ---------------------------------------------------------------------------

class OnboardingContinueButton extends StatelessWidget {
  final String label;
  final bool enabled;
  final bool isLoading;
  final VoidCallback? onPressed;

  const OnboardingContinueButton({
    super.key,
    this.label = 'Continue',
    required this.enabled,
    this.isLoading = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: (enabled && !isLoading) ? onPressed : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: ProfileColors.accent,
          disabledBackgroundColor: ProfileColors.accent.withAlpha(80),
          foregroundColor: ProfileColors.dark,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          elevation: 0,
        ),
        child: isLoading
            ? SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.5,
                  valueColor:
                      AlwaysStoppedAnimation<Color>(ProfileColors.dark),
                ),
              )
            : Text(
                label,
                style:
                    AppTextStyles.labelLg.copyWith(color: ProfileColors.dark),
              ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// OnboardingInfoNote – grey helper note
// ---------------------------------------------------------------------------

class OnboardingInfoNote extends StatelessWidget {
  final String text;
  const OnboardingInfoNote({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.fieldFill,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ProfileColors.border),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 16, color: ProfileColors.mid),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.bodySm.copyWith(color: ProfileColors.mid),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// OnboardingDropdownField – a tappable dropdown field card (visual only unless
// onChanged is wired).  Used in the 2×2 preference grid.
// ---------------------------------------------------------------------------

class OnboardingDropdownField<T> extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hint;
  final T? value;
  final List<T> items;
  final String Function(T) itemLabel;
  final ValueChanged<T?>? onChanged;

  const OnboardingDropdownField({
    super.key,
    required this.icon,
    required this.label,
    required this.hint,
    required this.items,
    required this.itemLabel,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(minHeight: 68),
      decoration: BoxDecoration(
        color: ProfileColors.background,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: ProfileColors.border),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              size: 18, color: ProfileColors.mid),
          borderRadius: BorderRadius.circular(10),
          dropdownColor: Colors.white,
          onChanged: onChanged,
          hint: _FieldContent(icon: icon, label: label, hint: hint),
          selectedItemBuilder: value == null
              ? null
              : (_) => items
                  .map(
                    (item) => _FieldContent(
                      icon: icon,
                      label: label,
                      hint: itemLabel(item),
                    ),
                  )
                  .toList(),
          items: items
              .map(
                (item) => DropdownMenuItem<T>(
                  value: item,
                  child: Text(
                    itemLabel(item),
                    style: AppTextStyles.labelMd
                        .copyWith(color: ProfileColors.dark),
                  ),
                ),
              )
              .toList(),
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        ),
      ),
    );
  }
}

class _FieldContent extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hint;
  const _FieldContent(
      {required this.icon, required this.label, required this.hint});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 16, color: ProfileColors.accent),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.labelMd.copyWith(
                  color: ProfileColors.dark,
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                hint,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: AppTextStyles.bodySm.copyWith(
                  color: ProfileColors.mid,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ---------------------------------------------------------------------------
// OnboardingPrefsCard – white rounded card with the 2×2 dropdown grid
// ---------------------------------------------------------------------------

class OnboardingPrefsCard extends StatelessWidget {
  final List<Widget> fields; // exactly 4 expected (2 rows × 2 cols)

  const OnboardingPrefsCard({super.key, required this.fields});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0),
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: ProfileColors.dark.withAlpha(20),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Card header
          Row(
            children: [
              Icon(Icons.person_outline_rounded,
                  size: 18, color: ProfileColors.accent),
              const SizedBox(width: 8),
              Text(
                'Your Gym Preferences',
                style: AppTextStyles.labelLg
                    .copyWith(color: ProfileColors.dark),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // 2×2 grid
          Row(
            children: [
              Expanded(child: fields[0]),
              const SizedBox(width: 12),
              Expanded(child: fields[1]),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: fields[2]),
              const SizedBox(width: 12),
              Expanded(child: fields[3]),
            ],
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// OnboardingPageDots – dot indicator + "Next" button row
// ---------------------------------------------------------------------------

class OnboardingPageDots extends StatelessWidget {
  /// Total number of pages.
  final int total;

  /// Index of the active page (0-based).
  final int current;

  /// Label shown next to the arrow button (defaults to "Next").
  final String nextLabel;

  /// Called when the arrow button is tapped.
  final VoidCallback? onNext;

  const OnboardingPageDots({
    super.key,
    required this.total,
    required this.current,
    this.nextLabel = 'Next',
    this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        // Dots
        Row(
          children: List.generate(total, (i) {
            final isActive = i == current;
            return AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              margin: const EdgeInsets.only(right: 6),
              height: 8,
              width: isActive ? 22 : 8,
              decoration: BoxDecoration(
                color: isActive ? ProfileColors.accent : ProfileColors.border,
                borderRadius: BorderRadius.circular(4),
              ),
            );
          }),
        ),
        const Spacer(),
        // "Next" label
        Text(
          nextLabel,
          style:
              AppTextStyles.labelLg.copyWith(color: ProfileColors.dark),
        ),
        const SizedBox(width: 10),
        // Arrow button
        GestureDetector(
          onTap: onNext,
          child: Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: ProfileColors.accent,
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.arrow_forward_rounded,
              color: ProfileColors.dark,
              size: 24,
            ),
          ),
        ),
      ],
    );
  }
}
