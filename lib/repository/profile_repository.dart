// Handles local storage for the profile (US-1.4).
// Only this file knows about shared_preferences and JSON.

import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../model/user_profile.dart';

class ProfileRepository {
  static const String _profileKey = 'fitness_app_nepal_user_profile';

  /// Returns null if nothing has been saved yet.
  /// Throws on read or decode errors so the ViewModel can show them.
  Future<UserProfile?> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final jsonString = prefs.getString(_profileKey);

    if (jsonString == null || jsonString.trim().isEmpty) return null;

    return UserProfile.fromMap(json.decode(jsonString) as Map<String, dynamic>);
  }

  /// Throws if saving fails so the ViewModel can roll back.
  Future<void> saveProfile(UserProfile profile) async {
    final prefs = await SharedPreferences.getInstance();
    final success =
        await prefs.setString(_profileKey, json.encode(profile.toMap()));

    if (!success) {
      throw Exception('Failed to save profile to local storage.');
    }
  }

  Future<void> clearProfile() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_profileKey);
  }
}