import 'package:flutter/material.dart';
import 'package:resolve/view/authentication/forgot_password_screen.dart';
import 'package:resolve/view/authentication/login_screen.dart';
import 'package:resolve/view/authentication/otp_verify_screen.dart';
import 'package:resolve/view/authentication/register_screen.dart';
import 'package:resolve/view/authentication/reset_password_screen.dart';
import 'package:resolve/view/onboarding/physical_details_screen.dart';
import 'package:resolve/view/onboarding/training_preferences_screen.dart';
import 'package:resolve/view/profile/edit_profile_screen.dart';
import 'package:resolve/view/profile/profile_screen.dart';
import 'package:resolve/view/settings/settings_screen.dart';

class AppRoutes {
  // ---------- Route names ----------
  static const String login = '/login';
  static const String register = '/register';
  static const String otpVerify = '/otp-verify';
  static const String forgotPassword = '/forgot-password';
  static const String resetPassword = '/reset-password';
<<<<<<< HEAD
  static const String physicalDetails = '/physical-details';
=======
>>>>>>> 0fba810a284cb06553f75bf99dd6df919cfea247
  static const String trainingPreferences = '/training-preferences';
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';
  static const String dashboard = '/dashboard';

  // ---------- Route table ----------
  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    otpVerify: (context) => const OtpVerifyScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    resetPassword: (context) => const ResetPasswordScreen(),
<<<<<<< HEAD
    physicalDetails: (context) => const PhysicalDetailsScreen(),
=======
>>>>>>> 0fba810a284cb06553f75bf99dd6df919cfea247
    trainingPreferences: (context) => const TrainingPreferencesScreen(),
    profile: (context) => const ProfileScreen(),
    editProfile: (context) => const EditProfileScreen(),
    settings: (context) => const SettingsScreen(),
    dashboard: (context) => const DashboardScreen(),
  };
}
