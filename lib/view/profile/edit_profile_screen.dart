import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import '../../model/user_profile.dart';
import '../../viewmodel/profile_viewmodel.dart';
import 'profile_colors.dart';
import 'widgets/profile_dropdown.dart';
import 'widgets/save_button.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  // ── Form infrastructure ────────────────────────────────────────────────
  final _formKey = GlobalKey<FormState>();

  // ── Controllers ────────────────────────────────────────────────────────
  final _nameController   = TextEditingController();
  final _ageController    = TextEditingController();
  final _heightController = TextEditingController();

  // ── Dropdown state ─────────────────────────────────────────────────────
  String?       _selectedGender;
  FitnessLevel? _selectedFitnessLevel;

  static const List<String> _genderOptions = ['Male', 'Female', 'Other'];

  // ── Pre-fill flag ──────────────────────────────────────────────────────
  bool _prefilled = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_prefilled) {
      _preFill();
      _prefilled = true;
    }
  }

  void _preFill() {
    final profile = context.read<ProfileViewModel>().profile;
    if (profile == null) return;
    _nameController.text   = profile.name;
    _ageController.text    = profile.age.toString();
    _heightController.text = profile.heightCm.toStringAsFixed(1);
    _selectedGender        = profile.gender;
    _selectedFitnessLevel  = profile.fitnessLevel;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _ageController.dispose();
    _heightController.dispose();
    super.dispose();
  }

  // ── Save handler ───────────────────────────────────────────────────────

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final newProfile = UserProfile(
      name:         _nameController.text.trim(),
      age:          int.parse(_ageController.text.trim()),
      gender:       _selectedGender!,
      heightCm:     double.parse(_heightController.text.trim()),
      fitnessLevel: _selectedFitnessLevel!,
    );

    final vm = context.read<ProfileViewModel>();
    await vm.save(newProfile);

    if (!mounted) return;

    if (vm.errorMessage == null) {
      // ── SUCCESS ─────────────────────────────────────────────────────
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Row(
            children: [
              Icon(Icons.check_circle_outline, color: Colors.white),
              SizedBox(width: 10),
              Text('Profile saved successfully!'),
            ],
          ),
          backgroundColor: ProfileColors.dark,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 2),
        ),
      );
      Navigator.of(context).pop();
    } else {
      // ── FAILURE – do NOT navigate back ──────────────────────────────
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Icon(Icons.error_outline, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(child: Text(vm.errorMessage!)),
            ],
          ),
          backgroundColor: Colors.redAccent,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          margin: const EdgeInsets.all(16),
          duration: const Duration(seconds: 4),
        ),
      );
    }
  }

  // ── Build ──────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    final isSaving = context.watch<ProfileViewModel>().isSaving;

    return Scaffold(
      backgroundColor: ProfileColors.background,
      appBar: AppBar(
        backgroundColor: ProfileColors.dark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'Edit Profile',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
      ),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const _FormSectionLabel(label: 'Personal Details'),
                  const SizedBox(height: 12),
                  _FormCard(
                    children: [
                      const _FieldLabel(text: 'Full Name'),
                      const SizedBox(height: 6),
                      _buildNameField(),
                      const SizedBox(height: 18),
                      const _FieldLabel(text: 'Age'),
                      const SizedBox(height: 6),
                      _buildAgeField(),
                      const SizedBox(height: 18),
                      const _FieldLabel(text: 'Gender'),
                      const SizedBox(height: 6),
                      _buildGenderDropdown(),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const _FormSectionLabel(label: 'Body Metrics'),
                  const SizedBox(height: 12),
                  _FormCard(
                    children: [
                      const _FieldLabel(text: 'Height (cm)'),
                      const SizedBox(height: 6),
                      _buildHeightField(),
                    ],
                  ),
                  const SizedBox(height: 20),

                  const _FormSectionLabel(label: 'Fitness Profile'),
                  const SizedBox(height: 12),
                  _FormCard(
                    children: [
                      const _FieldLabel(text: 'Fitness Level'),
                      const SizedBox(height: 6),
                      _buildFitnessLevelDropdown(),
                    ],
                  ),
                  const SizedBox(height: 32),

                  SaveButton(isSaving: isSaving, onPressed: _submit),
                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),

          // Full-screen overlay while saving
          if (isSaving)
            Container(
              color: Colors.black.withAlpha(50),
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(ProfileColors.accent),
                ),
              ),
            ),
        ],
      ),
    );
  }

  // ── Field builders ─────────────────────────────────────────────────────

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      textCapitalization: TextCapitalization.words,
      decoration: _inputDecoration(hint: 'e.g. Anuja Sharma', icon: Icons.person_outline),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Name is required.';
        if (value.trim().length < 2) return 'Name must be at least 2 characters.';
        return null;
      },
    );
  }

  Widget _buildAgeField() {
    return TextFormField(
      controller: _ageController,
      keyboardType: TextInputType.number,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      decoration: _inputDecoration(hint: 'e.g. 22', icon: Icons.cake_outlined),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Age is required.';
        final age = int.tryParse(value.trim());
        if (age == null) return 'Enter a valid whole number.';
        if (age < 10)  return 'Age must be at least 10.';
        if (age > 100) return 'Age must be 100 or below.';
        return null;
      },
    );
  }

  Widget _buildGenderDropdown() {
    return ProfileDropdown<String>(
      value: _selectedGender,
      hint: 'Select gender',
      icon: Icons.wc_outlined,
      items: _genderOptions
          .map((g) => DropdownMenuItem(value: g, child: Text(g)))
          .toList(),
      onChanged: (value) => setState(() => _selectedGender = value),
      validator: (value) =>
      (value == null || value.isEmpty) ? 'Please select a gender.' : null,
    );
  }

  Widget _buildHeightField() {
    return TextFormField(
      controller: _heightController,
      keyboardType: const TextInputType.numberWithOptions(decimal: true),
      inputFormatters: [FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*'))],
      decoration: _inputDecoration(
        hint: 'e.g. 165.0',
        icon: Icons.straighten_outlined,
        suffix: 'cm',
      ),
      validator: (value) {
        if (value == null || value.trim().isEmpty) return 'Height is required.';
        final h = double.tryParse(value.trim());
        if (h == null) return 'Enter a valid number (e.g. 165.0).';
        if (h < 100)   return 'Height must be at least 100 cm.';
        if (h > 250)   return 'Height must be 250 cm or below.';
        return null;
      },
    );
  }

  Widget _buildFitnessLevelDropdown() {
    return ProfileDropdown<FitnessLevel>(
      value: _selectedFitnessLevel,
      hint: 'Select fitness level',
      icon: Icons.fitness_center_outlined,
      items: FitnessLevel.values
          .map((l) => DropdownMenuItem(value: l, child: Text(l.label)))
          .toList(),
      onChanged: (value) => setState(() => _selectedFitnessLevel = value),
      validator: (value) =>
      value == null ? 'Please select a fitness level.' : null,
    );
  }

  InputDecoration _inputDecoration({
    required String hint,
    required IconData icon,
    String? suffix,
  }) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: ProfileColors.border, fontSize: 14),
      prefixIcon: Icon(icon, color: ProfileColors.mid, size: 20),
      suffixText: suffix,
      suffixStyle: const TextStyle(color: ProfileColors.mid, fontSize: 14),
      filled: true,
      fillColor: Colors.white,
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: ProfileColors.border),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: ProfileColors.border),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: ProfileColors.accent, width: 1.8),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: const BorderSide(color: Colors.redAccent, width: 1.8),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Private layout helpers (scoped to this screen only)
// ---------------------------------------------------------------------------

class _FormSectionLabel extends StatelessWidget {
  final String label;
  const _FormSectionLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 11,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
        color: ProfileColors.mid,
      ),
    );
  }
}

class _FieldLabel extends StatelessWidget {
  final String text;
  const _FieldLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: ProfileColors.dark,
      ),
    );
  }
}

class _FormCard extends StatelessWidget {
  final List<Widget> children;
  const _FormCard({required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: ProfileColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }
}
