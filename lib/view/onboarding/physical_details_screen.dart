// US-1.5 — Physical Details onboarding screen.
// Matches the "Running" slide layout shown in the design mockup.
// Frontend only — no ViewModel wired yet.

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:resolve/core/app_routes.dart';
import 'package:resolve/core/app_text_styles.dart';
import 'package:resolve/view/profile/profile_colors.dart';


class PhysicalDetailsScreen extends StatefulWidget {
  final bool isEditing;

  const PhysicalDetailsScreen({super.key, this.isEditing = false});

  @override
  State<PhysicalDetailsScreen> createState() => _PhysicalDetailsScreenState();
}

class _PhysicalDetailsScreenState extends State<PhysicalDetailsScreen> {
  // ── Controllers ───────────────────────────────────────────────────────────
  final TextEditingController _heightCtrl = TextEditingController();
  final TextEditingController _weightCtrl = TextEditingController();
  final TextEditingController _goalWeightCtrl = TextEditingController();
  final TextEditingController _durationCtrl = TextEditingController();

  // ── Unit toggles ──────────────────────────────────────────────────────────
  bool _heightInCm = true; // cm vs ft
  bool _weightInKg = true; // kg vs lbs

  // ── Duration options ──────────────────────────────────────────────────────
  static const List<String> _durationOptions = [
    '4 weeks',
    '8 weeks',
    '12 weeks',
    '16 weeks',
    '6 months',
  ];
  String? _selectedDuration;

  bool get _isValid =>
      _heightCtrl.text.trim().isNotEmpty &&
      _weightCtrl.text.trim().isNotEmpty &&
      _goalWeightCtrl.text.trim().isNotEmpty &&
      _selectedDuration != null;

  @override
  void dispose() {
    _heightCtrl.dispose();
    _weightCtrl.dispose();
    _goalWeightCtrl.dispose();
    _durationCtrl.dispose();
    super.dispose();
  }

  void _onNext() {
    if (!_isValid) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all your physical details.'),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }
    Navigator.of(context).pushNamed(AppRoutes.trainingPreferences);
  }

  void _onSkip() {
    Navigator.of(context).pushNamed(AppRoutes.trainingPreferences);
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileColors.background,
      body: Stack(
        children: [
          // Faint decorative circles (same as Nilam's screen)
          _DecorativeCircles(),

          SafeArea(
            child: Column(
              children: [
                // Top bar: Skip
                _TopBar(onSkip: _onSkip),

                // Scrollable content
                Expanded(
                  child: SingleChildScrollView(
                    child: _buildMainPage(),
                  ),
                ),

                // Bottom nav bar: dots + Next
                _BottomNavBar(
                  isValid: _isValid,
                  onNext: _onNext,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Main page ─────────────────────────────────────────────────────────────

  Widget _buildMainPage() {
    final screenH = MediaQuery.of(context).size.height;
    final imgH = (screenH * 0.34).clamp(240.0, 400.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // ── Hero image ──────────────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Image.asset(
              'assets/images/runner.png',
              height: imgH,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, e, s) => Container(
                height: imgH,
                decoration: BoxDecoration(
                  color: ProfileColors.accent.withAlpha(40),
                  borderRadius: BorderRadius.circular(24),
                ),
                child: Center(
                  child: Icon(Icons.directions_run,
                      size: 72, color: ProfileColors.accent),
                ),
              ),
            ),
          ),
        ),

        // ── Physical details card ────────────────────────────────────────────
        const SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _PhysicalDetailsCard(
            heightCtrl: _heightCtrl,
            weightCtrl: _weightCtrl,
            goalWeightCtrl: _goalWeightCtrl,
            heightInCm: _heightInCm,
            weightInKg: _weightInKg,
            onHeightUnitToggle: () =>
                setState(() => _heightInCm = !_heightInCm),
            onWeightUnitToggle: () =>
                setState(() => _weightInKg = !_weightInKg),
            durationOptions: _durationOptions,
            selectedDuration: _selectedDuration,
            onDurationChanged: (v) => setState(() => _selectedDuration = v),
            onAnyChanged: () => setState(() {}),
          ),
        ),

        // ── Title / subtitle / description ───────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
          child: Column(
            children: [
              const SizedBox(height: 24),
              Text(
                'Running',
                textAlign: TextAlign.center,
                style: AppTextStyles.headlineLg.copyWith(
                  color: ProfileColors.dark,
                  fontSize: 30,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'Go Further, Feel Better.',
                textAlign: TextAlign.center,
                style: AppTextStyles.labelLg.copyWith(
                  color: ProfileColors.mid,
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: 280,
                child: Text(
                  'Track your runs, set your goal, and achieve a healthier you.',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.bodySm.copyWith(
                    color: ProfileColors.mid,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),
      ],
    );
  }
}

// ── Physical Details Card ─────────────────────────────────────────────────────

class _PhysicalDetailsCard extends StatelessWidget {
  final TextEditingController heightCtrl;
  final TextEditingController weightCtrl;
  final TextEditingController goalWeightCtrl;
  final bool heightInCm;
  final bool weightInKg;
  final VoidCallback onHeightUnitToggle;
  final VoidCallback onWeightUnitToggle;
  final List<String> durationOptions;
  final String? selectedDuration;
  final ValueChanged<String?> onDurationChanged;
  final VoidCallback onAnyChanged;

  const _PhysicalDetailsCard({
    required this.heightCtrl,
    required this.weightCtrl,
    required this.goalWeightCtrl,
    required this.heightInCm,
    required this.weightInKg,
    required this.onHeightUnitToggle,
    required this.onWeightUnitToggle,
    required this.durationOptions,
    required this.selectedDuration,
    required this.onDurationChanged,
    required this.onAnyChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
          // Card header — mirrors Nilam's "Your Gym Preferences" header
          Row(
            children: [
              Icon(Icons.person_outline_rounded,
                  size: 18, color: ProfileColors.accent),
              const SizedBox(width: 8),
              Text(
                'Your Physical Details',
                style:
                    AppTextStyles.labelLg.copyWith(color: ProfileColors.dark),
              ),
            ],
          ),
          const SizedBox(height: 14),

          // Row 1: Height | Weight
          Row(
            children: [
              Expanded(
                child: _DetailInputField(
                  icon: Icons.straighten_outlined,
                  label: 'Height',
                  hint: heightInCm ? '170 cm' : '5\'7"',
                  controller: heightCtrl,
                  keyboardType: TextInputType.number,
                  unit: heightInCm ? 'cm' : 'ft',
                  onUnitTap: onHeightUnitToggle,
                  onChanged: (_) => onAnyChanged(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DetailInputField(
                  icon: Icons.monitor_weight_outlined,
                  label: 'Weight',
                  hint: weightInKg ? '65 kg' : '143 lbs',
                  controller: weightCtrl,
                  keyboardType: TextInputType.number,
                  unit: weightInKg ? 'kg' : 'lbs',
                  onUnitTap: onWeightUnitToggle,
                  onChanged: (_) => onAnyChanged(),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Row 2: Goal Weight | Duration
          Row(
            children: [
              Expanded(
                child: _DetailInputField(
                  icon: Icons.track_changes_outlined,
                  label: 'Goal Weight',
                  hint: weightInKg ? '60 kg' : '132 lbs',
                  controller: goalWeightCtrl,
                  keyboardType: TextInputType.number,
                  unit: weightInKg ? 'kg' : 'lbs',
                  onChanged: (_) => onAnyChanged(),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _DurationDropdownField(
                  options: durationOptions,
                  value: selectedDuration,
                  onChanged: onDurationChanged,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ── Individual input field (matches OnboardingDropdownField visual style) ────

class _DetailInputField extends StatelessWidget {
  final IconData icon;
  final String label;
  final String hint;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final String unit;
  final VoidCallback? onUnitTap;
  final ValueChanged<String>? onChanged;

  const _DetailInputField({
    required this.icon,
    required this.label,
    required this.hint,
    required this.controller,
    required this.keyboardType,
    required this.unit,
    this.onUnitTap,
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
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: Row(
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
                TextField(
                  controller: controller,
                  keyboardType: keyboardType,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(
                        RegExp(r'[\d.]')),
                  ],
                  onChanged: onChanged,
                  style: AppTextStyles.bodySm.copyWith(
                    color: ProfileColors.mid,
                    fontSize: 11,
                  ),
                  decoration: InputDecoration(
                    hintText: hint,
                    hintStyle: AppTextStyles.bodySm.copyWith(
                      color: ProfileColors.mid,
                      fontSize: 11,
                    ),
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                    isCollapsed: true,
                  ),
                ),
              ],
            ),
          ),
          // Unit toggle badge (only if onUnitTap provided)
          if (onUnitTap != null)
            GestureDetector(
              onTap: onUnitTap,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: ProfileColors.accent.withAlpha(50),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  unit,
                  style: AppTextStyles.labelSm.copyWith(
                    color: ProfileColors.dark,
                    fontSize: 10,
                  ),
                ),
              ),
            )
          else
            // Non-tapable unit label (Goal Weight)
            Text(
              unit,
              style: AppTextStyles.labelSm.copyWith(
                color: ProfileColors.mid,
                fontSize: 10,
              ),
            ),
        ],
      ),
    );
  }
}

// ── Duration dropdown field (matches OnboardingDropdownField visual style) ───

class _DurationDropdownField extends StatelessWidget {
  final List<String> options;
  final String? value;
  final ValueChanged<String?> onChanged;

  const _DurationDropdownField({
    required this.options,
    required this.value,
    required this.onChanged,
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
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: Icon(Icons.keyboard_arrow_down_rounded,
              size: 18, color: ProfileColors.mid),
          borderRadius: BorderRadius.circular(10),
          dropdownColor: Colors.white,
          onChanged: onChanged,
          hint: _DurationFieldContent(hint: value ?? '8 weeks'),
          selectedItemBuilder: value == null
              ? null
              : (_) => options
                  .map(
                    (item) => _DurationFieldContent(hint: item),
                  )
                  .toList(),
          items: options
              .map(
                (item) => DropdownMenuItem<String>(
                  value: item,
                  child: Text(
                    item,
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

class _DurationFieldContent extends StatelessWidget {
  final String hint;
  const _DurationFieldContent({required this.hint});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(Icons.calendar_month_outlined,
            size: 16, color: ProfileColors.accent),
        const SizedBox(width: 6),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                'Duration',
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

// ── Private helper widgets ────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final VoidCallback onSkip;
  const _TopBar({required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              foregroundColor: ProfileColors.dark,
              padding: EdgeInsets.zero,
              minimumSize: const Size(44, 28),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Skip',
              style: AppTextStyles.labelMd.copyWith(color: ProfileColors.dark),
            ),
          ),
        ],
      ),
    );
  }
}

class _DecorativeCircles extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final circleColor = ProfileColors.accent.withAlpha(25);
    return Stack(
      children: [
        Positioned(
          top: -60,
          left: -60,
          child: Container(
            width: 180,
            height: 180,
            decoration:
                BoxDecoration(color: circleColor, shape: BoxShape.circle),
          ),
        ),
        Positioned(
          top: -40,
          right: -40,
          child: Container(
            width: 120,
            height: 120,
            decoration:
                BoxDecoration(color: circleColor, shape: BoxShape.circle),
          ),
        ),
        Positioned(
          bottom: -50,
          left: -50,
          child: Container(
            width: 140,
            height: 140,
            decoration:
                BoxDecoration(color: circleColor, shape: BoxShape.circle),
          ),
        ),
        Positioned(
          bottom: -70,
          right: -30,
          child: Container(
            width: size.width * 0.5,
            height: size.width * 0.5,
            decoration:
                BoxDecoration(color: circleColor, shape: BoxShape.circle),
          ),
        ),
      ],
    );
  }
}

class _BottomNavBar extends StatelessWidget {
  final bool isValid;
  final VoidCallback? onNext;

  const _BottomNavBar({
    required this.isValid,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 24),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(color: ProfileColors.border),
        ),
      ),
      child: SafeArea(
        top: false,
        child: SizedBox(
          height: 52,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Dot indicators — 2 dots (page 1 of 2 in the onboarding flow)
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(2, (i) {
                  final active = i == 0; // this is page 0
                  return Container(
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    width: active ? 10 : 8,
                    height: active ? 10 : 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: active
                          ? ProfileColors.mid
                          : ProfileColors.border,
                    ),
                  );
                }),
              ),

              // Next button on the right
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  behavior: HitTestBehavior.opaque,
                  onTap: onNext,
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        'Next',
                        style: AppTextStyles.bodySm.copyWith(
                          color: ProfileColors.dark,
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Container(
                        width: 50,
                        height: 50,
                        decoration: const BoxDecoration(
                          color: ProfileColors.mid,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.arrow_forward,
                            color: Colors.white, size: 22),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
