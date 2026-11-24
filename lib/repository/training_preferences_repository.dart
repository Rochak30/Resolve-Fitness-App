// Handles local persistence for TrainingPreferences (US-1.6 & US-1.7).
// Mirrors the pattern used in ProfileRepository.

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/training_preferences.dart';

class TrainingPreferencesRepository {
  static const String _key = 'resolve_training_preferences';

  /// Returns null if nothing has been saved yet.
  Future<TrainingPreferences?> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_key);
    if (raw == null || raw.trim().isEmpty) return null;
    return TrainingPreferences.fromMap(
      json.decode(raw) as Map<String, dynamic>,
    );
  }

  /// Throws if saving fails.
  Future<void> save(TrainingPreferences preferences) async {
    final prefs = await SharedPreferences.getInstance();
    final success = await prefs.setString(
      _key,
      json.encode(preferences.toMap()),
    );
    if (!success) {
      throw Exception('Failed to save training preferences to local storage.');
    }
  }

  Future<void> clear() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key);
  }
}
