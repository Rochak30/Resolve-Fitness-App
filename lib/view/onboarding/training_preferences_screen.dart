// US-1.6 — Training Preferences onboarding screen.
// Redesigned to match the "Gym & Strength" slide layout.
// Logic: TrainingPreferencesViewModel (unchanged). isEditing mode kept intact.

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:resolve/core/app_routes.dart';
import 'package:resolve/model/training_preferences.dart';
import 'package:resolve/model/user_profile.dart';
import 'package:resolve/view/profile/profile_colors.dart';
import 'package:resolve/core/app_text_styles.dart';
import 'package:resolve/viewmodel/training_preferences_viewmodel.dart';
import 'package:resolve/view/onboarding/widgets/onboarding_widgets.dart';

class TrainingPreferencesScreen extends StatefulWidget {
  final bool isEditing;

  const TrainingPreferencesScreen({super.key, this.isEditing = false});

  @override
  State<TrainingPreferencesScreen> createState() =>
      _TrainingPreferencesScreenState();
}

class _TrainingPreferencesScreenState
    extends State<TrainingPreferencesScreen> {
  // ── Saved fields (US-1.6) ─────────────────────────────────────────────────
  final Set<TrainingType> _selectedTypes = {};
  FitnessLevel? _selectedLevel;
  FitnessGoal? _selectedGoal;

  // ── Visual-only local fields (not saved to model) ─────────────────────────
  String? _workoutFrequency;
  String? _focusArea;
  String? _sessionDuration;

  // ── PageView state ────────────────────────────────────────────────────────
  final PageController _pageController = PageController();
  int _currentPage = 0; // 0 = gym card slide, 1 = types + level + goal slide

  bool get _isValid =>
      _selectedTypes.isNotEmpty &&
          _selectedLevel != null &&
          _selectedGoal != null;

  // ── Frequency options (visual only) ───────────────────────────────────────
  static const List<String> _frequencies = [
    '1-2 times/week',
    '3-5 times/week',
    '6+ times/week',
    'Daily',
  ];

  static const List<String> _focusAreas = [
    'Strength, Muscle',
    'Cardio, Endurance',
    'Flexibility',
    'Weight Loss',
    'Overall Fitness',
  ];

  static const List<String> _durations = [
    '< 30 min',
    '30-45 min',
    '45-60 min',
    '60-90 min',
    '90+ min',
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) => _preFill());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _preFill() {
    final prefs = context.read<TrainingPreferencesViewModel>().preferences;
    if (prefs == null) return;
    setState(() {
      _selectedTypes
        ..clear()
        ..addAll(prefs.trainingTypes);
      _selectedLevel = prefs.fitnessLevel;
      _selectedGoal = prefs.fitnessGoal;
    });
  }

  void _toggleType(TrainingType type) {
    setState(() {
      if (_selectedTypes.contains(type)) {
        _selectedTypes.remove(type);
      } else {
        _selectedTypes.add(type);
      }
    });
  }

  Future<void> _onSave() async {
    if (!_isValid) return;
    final vm = context.read<TrainingPreferencesViewModel>();

    final updated = TrainingPreferences(
      trainingTypes: Set.from(_selectedTypes),
      fitnessLevel: _selectedLevel!,
      fitnessGoal: _selectedGoal!,
    );

    await vm.save(updated);
    if (!mounted) return;

    if (vm.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(vm.errorMessage!),
          backgroundColor: Colors.redAccent,
        ),
      );
      return;
    }

    if (widget.isEditing) {
      Navigator.of(context).pop();
    } else {
      Navigator.of(context).pushNamedAndRemoveUntil(
        AppRoutes.profile,
            (route) => false,
      );
    }
  }

  Future<void> _onSkip() async {
    // Save sensible defaults so the user is never left with empty prefs.
    final vm = context.read<TrainingPreferencesViewModel>();
    final defaults = TrainingPreferences(
      trainingTypes: {TrainingType.weightTraining},
      fitnessLevel: FitnessLevel.intermediate,
      fitnessGoal: FitnessGoal.overallFitness,
    );
    await vm.save(defaults);
    if (!mounted) return;
    Navigator.of(context).pushNamedAndRemoveUntil(
      AppRoutes.profile,
          (route) => false,
    );
  }

  void _goToPage(int page) {
    _pageController.animateToPage(
      page,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isSaving =
        context.watch<TrainingPreferencesViewModel>().isSaving;

    // isEditing mode: use the classic OnboardingScaffold (no layout change)
    if (widget.isEditing) {
      return OnboardingScaffold(
        title: 'Edit Training Preferences',
        subtitle: 'Update your training types, level and goal.',
        stepCurrent: 1,
        stepTotal: 1,
        showBack: true,
        bottom: OnboardingContinueButton(
          label: 'Save Changes',
          enabled: _isValid,
          isLoading: isSaving,
          onPressed: _onSave,
        ),
        children: [
          const OnboardingSectionLabel(label: 'Training Types'),
          const OnboardingInfoNote(
            text: 'Select all types that apply — the app will show relevant '
                'sections for each.',
          ),
          const SizedBox(height: 12),
          ..._buildTypeChips(),
          const SizedBox(height: 24),
          const OnboardingSectionLabel(label: 'Fitness Level'),
          ..._buildLevelChips(),
          const SizedBox(height: 24),
          const OnboardingSectionLabel(label: 'Main Goal'),
          ..._buildGoalChips(),
          const SizedBox(height: 8),
        ],
      );
    }

    // ── New onboarding layout (2-page PageView) ────────────────────────────
    return Scaffold(
      backgroundColor: ProfileColors.background,
      body: Stack(
        children: [
          // Faint decorative circles in the corners
          _DecorativeCircles(),

          // Main content
          SafeArea(
            child: Column(
              children: [
                // Top bar: Skip button
                _TopBar(onSkip: _onSkip),

                // Pages
                Expanded(
                  child: PageView(
                    controller: _pageController,
                    onPageChanged: (p) => setState(() => _currentPage = p),
                    physics: const NeverScrollableScrollPhysics(),
                    children: [
                      _buildGymCardPage(),
                      _buildTypesAndGoalPage(isSaving),
                    ],
                  ),
                ),

                // Bottom nav bar
                _BottomNavBar(
                  currentPage: _currentPage,
                  totalPages: 2,
                  isValid: _isValid,
                  isSaving: isSaving,
                  onNext: _currentPage == 0
                      ? () => _goToPage(1)
                      : (_isValid && !isSaving ? _onSave : null),
                  nextLabel:
                  _currentPage == 0 ? 'Next' : 'Continue to Gym Selection',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── Page 0: "Gym & Strength" card slide ───────────────────────────────────

  Widget _buildGymCardPage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenH = MediaQuery.of(context).size.height;
        final imgH = (screenH * 0.34).clamp(240.0, 400.0);

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // ── Hero image ──────────────────────────────────────────────
              Padding(
                // CHANGED: top 4 → 0 (less gap under the Skip bar)
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 0),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Image.asset(
                    'assets/images/gym.jpeg',
                    height: imgH,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (_, __, ___) => Container(
                      height: imgH,
                      decoration: BoxDecoration(
                        color: ProfileColors.accent.withAlpha(40),
                        borderRadius: BorderRadius.circular(24),
                      ),
                      child: Center(
                        child: Icon(Icons.fitness_center,
                            size: 72, color: ProfileColors.accent),
                      ),
                    ),
                  ),
                ),
              ),

              // ── White prefs card ────────────────────────────────────────
              const SizedBox(height: 20),
              Transform.translate(
                offset: const Offset(0, 0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: OnboardingPrefsCard(
                    fields: [
                      // Workout Frequency (visual only)
                      OnboardingDropdownField<String>(
                        icon: Icons.calendar_today_outlined,
                        label: 'Workout Frequency',
                        hint: 'e.g. 3-5x/week',
                        items: _frequencies,
                        itemLabel: (s) => s,
                        value: _workoutFrequency,
                        onChanged: (v) =>
                            setState(() => _workoutFrequency = v),
                      ),

                      // Intensity Level → connected to FitnessLevel
                      OnboardingDropdownField<FitnessLevel>(
                        icon: Icons.bar_chart_rounded,
                        label: 'Intensity Level',
                        // CHANGED: 'Select level' so it doesn't look chosen
                        hint: _selectedLevel?.label ?? 'Select level',
                        items: FitnessLevel.values,
                        itemLabel: (l) => l.label,
                        value: _selectedLevel,
                        onChanged: (v) =>
                            setState(() => _selectedLevel = v),
                      ),

                      // Focus Area (visual only)
                      OnboardingDropdownField<String>(
                        icon: Icons.track_changes_outlined,
                        label: 'Focus Area',
                        hint: 'e.g. Strength',
                        items: _focusAreas,
                        itemLabel: (s) => s,
                        value: _focusArea,
                        onChanged: (v) => setState(() => _focusArea = v),
                      ),

                      // Session Duration (visual only)
                      OnboardingDropdownField<String>(
                        icon: Icons.timer_outlined,
                        label: 'Session Duration',
                        hint: 'e.g. 45-60 min',
                        items: _durations,
                        itemLabel: (s) => s,
                        value: _sessionDuration,
                        onChanged: (v) =>
                            setState(() => _sessionDuration = v),
                      ),
                    ],
                  ),
                ),
              ),

              // ── Title / subtitle / description ──────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
                child: Column(
                  children: [
                    const SizedBox(height: 24),
                    Text(
                      'Gym & Strength',
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
                      'Build Strength, Build Confidence.',
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
                        'Tell us your workout preferences and get a personalized plan.',
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
          ),
        );
      },
    );
  }

  // ── Page 1: Training types + level + goal ─────────────────────────────────

  Widget _buildTypesAndGoalPage(bool isSaving) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(
            'Your Training Profile',
            style:
            AppTextStyles.headlineSm.copyWith(color: ProfileColors.dark),
          ),
          const SizedBox(height: 4),
          Text(
            'Select your training types, fitness level and main goal.',
            style: AppTextStyles.bodyMd.copyWith(color: ProfileColors.mid),
          ),
          const SizedBox(height: 20),

          // Training Types
          const OnboardingSectionLabel(label: 'Training Types'),
          const OnboardingInfoNote(
            text: 'Select all types that apply — the app will show relevant '
                'sections for each.',
          ),
          const SizedBox(height: 12),
          ..._buildTypeChips(),
          const SizedBox(height: 24),

          // CHANGED: Fitness Level is now here too, so the Continue button
          // can always be enabled from this page.
          const OnboardingSectionLabel(label: 'Fitness Level'),
          ..._buildLevelChips(),
          const SizedBox(height: 24),

          // Main Goal
          const OnboardingSectionLabel(label: 'Main Goal'),
          ..._buildGoalChips(),
          const SizedBox(height: 24),

          // Validation hint
          if (!_isValid)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: OnboardingInfoNote(
                text: _selectedTypes.isEmpty
                    ? 'Please select at least one training type.'
                    : _selectedLevel == null
                    ? 'Please select your fitness level.'
                    : 'Please select your main goal.',
              ),
            ),
        ],
      ),
    );
  }

  // ── Chip builders ─────────────────────────────────────────────────────────

  static const Map<TrainingType, IconData> _typeIcons = {
    TrainingType.weightTraining: Icons.fitness_center,
    TrainingType.calisthenics: Icons.self_improvement,
    TrainingType.running: Icons.directions_run,
    TrainingType.functionalHiit: Icons.flash_on,
  };

  List<Widget> _buildTypeChips() => TrainingType.values
      .map(
        (type) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SelectableChip(
        label: type.label,
        icon: _typeIcons[type],
        selected: _selectedTypes.contains(type),
        onTap: () => _toggleType(type),
      ),
    ),
  )
      .toList();

  static const Map<FitnessLevel, IconData> _levelIcons = {
    FitnessLevel.beginner: Icons.emoji_people,
    FitnessLevel.intermediate: Icons.trending_up,
    FitnessLevel.advanced: Icons.military_tech,
  };

  List<Widget> _buildLevelChips() => FitnessLevel.values
      .map(
        (level) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SelectableChip(
        label: level.label,
        icon: _levelIcons[level],
        selected: _selectedLevel == level,
        onTap: () => setState(() => _selectedLevel = level),
      ),
    ),
  )
      .toList();

  static const Map<FitnessGoal, IconData> _goalIcons = {
    FitnessGoal.loseWeight: Icons.monitor_weight_outlined,
    FitnessGoal.buildMuscle: Icons.fitness_center_outlined,
    FitnessGoal.improveEndurance: Icons.directions_bike_outlined,
    FitnessGoal.overallFitness: Icons.favorite_outline,
  };

  List<Widget> _buildGoalChips() => FitnessGoal.values
      .map(
        (goal) => Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: SelectableChip(
        label: goal.label,
        icon: _goalIcons[goal],
        selected: _selectedGoal == goal,
        onTap: () => setState(() => _selectedGoal = goal),
      ),
    ),
  )
      .toList();
}

// ── Private helper widgets ────────────────────────────────────────────────────

class _TopBar extends StatelessWidget {
  final VoidCallback onSkip;
  const _TopBar({required this.onSkip});

  @override
  Widget build(BuildContext context) {
    return Padding(
      // CHANGED: top 12 → 4 (less gap above the image)
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          TextButton(
            onPressed: onSkip,
            style: TextButton.styleFrom(
              foregroundColor: ProfileColors.dark,
              padding: EdgeInsets.zero,
              // CHANGED: shorter button + shrinkWrap tap target
              minimumSize: const Size(44, 28),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'Skip',
              style: AppTextStyles.labelMd
                  .copyWith(color: ProfileColors.dark),
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
        // Top-left
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
        // Top-right
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
        // Bottom-left
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
        // Bottom-right
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
  final int currentPage;
  final int totalPages;
  final bool isValid;
  final bool isSaving;
  final VoidCallback? onNext;
  final String nextLabel;

  const _BottomNavBar({
    required this.currentPage,
    required this.totalPages,
    required this.isValid,
    required this.isSaving,
    required this.onNext,
    required this.nextLabel,
  });

  @override
  Widget build(BuildContext context) {
    final bool isLastPage = currentPage == totalPages - 1;

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
        child: isLastPage
        // Last page: full-width "Continue to Gym Selection" button
            ? OnboardingContinueButton(
          label: nextLabel,
          enabled: isValid,
          isLoading: isSaving,
          onPressed: onNext,
        )
        // CHANGED: simple dots + Next bar (replaces OnboardingPageDots)
            : _NextBar(
          total: totalPages,
          current: currentPage,
          onNext: onNext,
        ),
      ),
    );
  }
}

/// Dots in the middle, "Next" + round arrow button on the right.
/// The whole "Next + arrow" area is one tap target.
class _NextBar extends StatelessWidget {
  final int total;
  final int current;
  final VoidCallback? onNext;

  const _NextBar({
    required this.total,
    required this.current,
    required this.onNext,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 52,
      child: Stack(
        alignment: Alignment.center,
        children: [
          // dots in the middle
          Row(
            mainAxisSize: MainAxisSize.min,
            children: List.generate(total, (i) {
              final active = i == current;
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 4),
                width: active ? 10 : 8,
                height: active ? 10 : 8,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: active ? ProfileColors.mid : ProfileColors.border,
                ),
              );
            }),
          ),
          // Next + round arrow on the right
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
    );
  }
}