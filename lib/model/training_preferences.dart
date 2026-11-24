// Model for US-1.6: Training Preferences.
// Stored locally via shared_preferences, consistent with UserProfile pattern.

import 'user_profile.dart';

/// Training types the user can select (multi-select).
enum TrainingType {
  weightTraining,
  calisthenics,
  running,
  functionalHiit;

  String get label {
    switch (this) {
      case TrainingType.weightTraining:
        return 'Weight Training';
      case TrainingType.calisthenics:
        return 'Calisthenics';
      case TrainingType.running:
        return 'Running';
      case TrainingType.functionalHiit:
        return 'Functional / HIIT';
    }
  }

  static TrainingType? fromString(String? value) {
    if (value == null) return null;
    try {
      return TrainingType.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return null;
    }
  }
}

/// Main fitness goal (single-select).
enum FitnessGoal {
  loseWeight,
  buildMuscle,
  improveEndurance,
  overallFitness;

  String get label {
    switch (this) {
      case FitnessGoal.loseWeight:
        return 'Lose Weight';
      case FitnessGoal.buildMuscle:
        return 'Build Muscle';
      case FitnessGoal.improveEndurance:
        return 'Improve Endurance';
      case FitnessGoal.overallFitness:
        return 'Overall Fitness';
    }
  }

  static FitnessGoal fromString(String? value) {
    if (value == null) return FitnessGoal.overallFitness;
    try {
      return FitnessGoal.values.firstWhere((e) => e.name == value);
    } catch (_) {
      return FitnessGoal.overallFitness;
    }
  }
}

/// Root model that holds all US-1.6 data.
class TrainingPreferences {
  final Set<TrainingType> trainingTypes;
  final FitnessLevel fitnessLevel;
  final FitnessGoal fitnessGoal;

  const TrainingPreferences({
    required this.trainingTypes,
    required this.fitnessLevel,
    required this.fitnessGoal,
  });

  bool hasType(TrainingType type) => trainingTypes.contains(type);

  Map<String, dynamic> toMap() => {
        'trainingTypes': trainingTypes.map((e) => e.name).toList(),
        'fitnessLevel': fitnessLevel.name,
        'fitnessGoal': fitnessGoal.name,
      };

  factory TrainingPreferences.fromMap(Map<String, dynamic> map) {
    final rawTypes = (map['trainingTypes'] as List<dynamic>?) ?? [];
    return TrainingPreferences(
      trainingTypes: rawTypes
          .map((e) => TrainingType.fromString(e as String?))
          .whereType<TrainingType>()
          .toSet(),
      fitnessLevel: FitnessLevel.fromString(map['fitnessLevel'] as String?),
      fitnessGoal: FitnessGoal.fromString(map['fitnessGoal'] as String?),
    );
  }

  TrainingPreferences copyWith({
    Set<TrainingType>? trainingTypes,
    FitnessLevel? fitnessLevel,
    FitnessGoal? fitnessGoal,
  }) {
    return TrainingPreferences(
      trainingTypes: trainingTypes ?? this.trainingTypes,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
      fitnessGoal: fitnessGoal ?? this.fitnessGoal,
    );
  }
}
