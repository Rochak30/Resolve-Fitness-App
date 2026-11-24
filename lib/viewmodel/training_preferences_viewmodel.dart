// ViewModel for US-1.6 (Training Preferences).
// Mirrors the patterns in ProfileViewModel.

import 'package:flutter/foundation.dart';

import '../model/training_preferences.dart';
import '../repository/training_preferences_repository.dart';

class TrainingPreferencesViewModel extends ChangeNotifier {
  final TrainingPreferencesRepository _repo;

  TrainingPreferencesViewModel({TrainingPreferencesRepository? repository})
      : _repo = repository ?? TrainingPreferencesRepository();

  // ── State ──────────────────────────────────────────────────────────────────

  TrainingPreferences? _preferences;
  bool _isLoading = false;
  bool _isSaving = false;
  String? _errorMessage;

  TrainingPreferences? get preferences => _preferences;
  bool get isLoading => _isLoading;
  bool get isSaving => _isSaving;
  String? get errorMessage => _errorMessage;

  // Convenience getters used by Dashboard and other modules.
  Set<TrainingType> get trainingTypes => _preferences?.trainingTypes ?? {};
  FitnessGoal? get fitnessGoal => _preferences?.fitnessGoal;

  // ── CRUD ───────────────────────────────────────────────────────────────────

  Future<void> load() async {
    if (_isLoading) return;
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _preferences = await _repo.load();
    } catch (e) {
      _errorMessage = _friendlyError('loading', e);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> save(TrainingPreferences preferences) async {
    if (_isSaving) return;
    final previous = _preferences;
    _preferences = preferences;
    _isSaving = true;
    _errorMessage = null;
    notifyListeners();
    try {
      await _repo.save(preferences);
    } catch (e) {
      _preferences = previous;
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

  // ── Helpers ────────────────────────────────────────────────────────────────

  String _friendlyError(String operation, Object e) {
    if (kDebugMode) {
      return 'An error occurred while $operation your preferences: $e';
    }
    return 'Something went wrong while $operation your preferences. Please try again.';
  }
}
