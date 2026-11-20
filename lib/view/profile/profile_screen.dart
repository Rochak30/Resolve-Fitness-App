import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../model/user_profile.dart';
import '../../viewmodel/profile_viewmodel.dart';
import 'edit_profile_screen.dart';
import 'profile_colors.dart';
import 'widgets/profile_header.dart';
import 'widgets/profile_info_card.dart';
import 'widgets/profile_empty_state.dart';
import 'widgets/profile_error_state.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ProfileColors.background,
      appBar: AppBar(
        backgroundColor: ProfileColors.dark,
        foregroundColor: Colors.white,
        elevation: 0,
        centerTitle: true,
        title: const Text(
          'My Profile',
          style: TextStyle(fontWeight: FontWeight.w600, letterSpacing: 0.5),
        ),
      ),
      body: Consumer<ProfileViewModel>(
        builder: (context, vm, _) {
          if (vm.isLoading) return const _LoadingView();

          if (vm.errorMessage != null) {
            return ProfileErrorState(
              message: vm.errorMessage!,
              onRetry: () => context.read<ProfileViewModel>().load(),
            );
          }

          if (vm.profile == null) {
            return ProfileEmptyState(
              onCreateProfile: () => _openEditScreen(context),
            );
          }

          return _ProfileContent(
            profile: vm.profile!,
            onEdit: () => _openEditScreen(context),
          );
        },
      ),
    );
  }

  Future<void> _openEditScreen(BuildContext context) async {
    await Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const EditProfileScreen()),
    );
    if (!mounted) return;
    // ignore: use_build_context_synchronously
    context.read<ProfileViewModel>().load();
  }
}

class _LoadingView extends StatelessWidget {
  const _LoadingView();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(ProfileColors.accent),
          ),
          SizedBox(height: 16),
          Text(
            'Loading profile…',
            style: TextStyle(color: ProfileColors.mid, fontSize: 15),
          ),
        ],
      ),
    );
  }
}

class _ProfileContent extends StatelessWidget {
  final UserProfile profile;
  final VoidCallback onEdit;

  const _ProfileContent({required this.profile, required this.onEdit});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ProfileHeader(name: profile.name, gender: profile.gender),
          const SizedBox(height: 20),

          const ProfileSectionLabel(label: 'Personal Details'),
          const SizedBox(height: 10),
          ProfileInfoCard(
            children: [
              ProfileInfoRow(
                icon: Icons.cake_outlined,
                label: 'Age',
                value: '${profile.age} years',
              ),
              const ProfileCardDivider(),
              ProfileInfoRow(
                icon: Icons.wc_outlined,
                label: 'Gender',
                value: profile.gender,
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ProfileSectionLabel(label: 'Body Metrics'),
          const SizedBox(height: 10),
          ProfileInfoCard(
            children: [
              ProfileInfoRow(
                icon: Icons.straighten_outlined,
                label: 'Height',
                value: '${profile.heightCm.toStringAsFixed(1)} cm',
              ),
            ],
          ),
          const SizedBox(height: 20),

          const ProfileSectionLabel(label: 'Fitness Profile'),
          const SizedBox(height: 10),
          ProfileInfoCard(
            children: [
              ProfileInfoRow(
                icon: Icons.fitness_center_outlined,
                label: 'Fitness Level',
                value: profile.fitnessLevel.label,
              ),
            ],
          ),
          const SizedBox(height: 32),

          ElevatedButton.icon(
            onPressed: onEdit,
            icon: const Icon(Icons.edit_outlined),
            label: const Text('Edit Profile'),
            style: ElevatedButton.styleFrom(
              backgroundColor: ProfileColors.accent,
              foregroundColor: ProfileColors.dark,
              padding: const EdgeInsets.symmetric(vertical: 14),
              textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
              elevation: 0,
            ),
          ),
          const SizedBox(height: 16),
        ],
      ),
    );
  }
}