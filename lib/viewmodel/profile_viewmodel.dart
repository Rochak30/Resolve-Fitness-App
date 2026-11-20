// Holds the profile state between the screens and ProfileRepository.
//
// Other modules can read profile data with:
//   context.watch<ProfileViewModel>().heightCm
//   context.watch<ProfileViewModel>().fitnessLevel
// Both are null if no profile has been saved yet.

import 'package:flutter/foundation.dart';

import '../model/user_profile.dart';
import '../repository/profile_repository.dart';

class ProfileViewModel extends ChangeNotifier {
  final ProfileRepository _repository;

  ProfileViewModel({ProfileRepository? repository})
      : _repository = repository ?? ProfileRepository();

  UserProfile? _profile;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  UserProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  double? get heightCm => _profile?.heightCm;
  FitnessLevel? get fitnessLevel => _profile?.fitnessLevel;

  Future<void> load() async {
    if (_isLoading) return;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      _profile = await _repository.loadProfile();
    } catch (e) {
      _errorMessage = _friendlyError('loading', e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Updates the UI immediately, then saves. Rolls back if saving fails.
  Future<void> save(UserProfile profile) async {
    if (_isSaving) return;

    final UserProfile? previousProfile = _profile;

    _profile = profile;
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _repository.saveProfile(profile);
    } catch (e) {
      _profile = previousProfile;
      _errorMessage = _friendlyError('saving', e);
    } finally {
      _isSaving = false;
      notifyListeners();
    }
  }

  void clearError() {
    if (_errorMessage == null) return;
    _errorMessage = null;
    notifyListeners();
  }

  String _friendlyError(String operation, Object e) {
    if (kDebugMode) {
      return 'An error occurred while $operation your profile: $e';
    }
    return 'Something went wrong while $operation your profile. '
        'Please try again.';
  }
}