enum FitnessLevel {
  beginner,
  intermediate,
  advanced;

  static FitnessLevel fromString(String? value) {
    if (value == null) return FitnessLevel.beginner;
    return FitnessLevel.values.firstWhere(
      (e) => e.name == value.toLowerCase().trim(),
      orElse: () => FitnessLevel.beginner,
    );
  }

  String get label {
    switch (this) {
      case FitnessLevel.beginner:
        return 'Beginner';
      case FitnessLevel.intermediate:
        return 'Intermediate';
      case FitnessLevel.advanced:
        return 'Advanced';
    }
  }
}

class UserProfile {
  final String name;
  final int age;
  final String gender;
  final double heightCm;
  final FitnessLevel fitnessLevel;

  const UserProfile({
    required this.name,
    required this.age,
    required this.gender,
    required this.heightCm,
    required this.fitnessLevel,
  });

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'age': age,
      'gender': gender,
      'heightCm': heightCm,
      'fitnessLevel': fitnessLevel.name,
    };
  }

  factory UserProfile.fromMap(Map<String, dynamic> map) {
    return UserProfile(
      name: (map['name'] as String?)?.trim().isNotEmpty == true
          ? (map['name'] as String).trim()
          : 'Unknown',
      age: _parseInt(map['age'], defaultValue: 18),
      gender: (map['gender'] as String?)?.isNotEmpty == true
          ? map['gender'] as String
          : 'Other',
      heightCm: _parseDouble(map['heightCm'], defaultValue: 170.0),
      fitnessLevel: FitnessLevel.fromString(map['fitnessLevel'] as String?),
    );
  }

  UserProfile copyWith({
    String? name,
    int? age,
    String? gender,
    double? heightCm,
    FitnessLevel? fitnessLevel,
  }) {
    return UserProfile(
      name: name ?? this.name,
      age: age ?? this.age,
      gender: gender ?? this.gender,
      heightCm: heightCm ?? this.heightCm,
      fitnessLevel: fitnessLevel ?? this.fitnessLevel,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is UserProfile &&
        other.name == name &&
        other.age == age &&
        other.gender == gender &&
        other.heightCm == heightCm &&
        other.fitnessLevel == fitnessLevel;
  }

  @override
  int get hashCode => Object.hash(name, age, gender, heightCm, fitnessLevel);

  static int _parseInt(dynamic value, {required int defaultValue}) {
    if (value == null) return defaultValue;
    if (value is int) return value;
    if (value is double) return value.round();
    return int.tryParse(value.toString()) ?? defaultValue;
  }

  static double _parseDouble(dynamic value, {required double defaultValue}) {
    if (value == null) return defaultValue;
    if (value is double) return value;
    if (value is int) return value.toDouble();
    return double.tryParse(value.toString()) ?? defaultValue;
  }
} 