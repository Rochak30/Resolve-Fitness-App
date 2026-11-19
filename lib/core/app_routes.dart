import 'package:flutter/material.dart';
import 'package:resolve/view/authentication/forgot_password_screen.dart';
import 'package:resolve/view/authentication/login_screen.dart';
import 'package:resolve/view/authentication/otp_verify_screen.dart';
import 'package:resolve/view/authentication/register_screen.dart';
import 'package:resolve/view/authentication/reset_password_screen.dart';
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
  static const String profile = '/profile';
  static const String editProfile = '/edit-profile';
  static const String settings = '/settings';

  // ---------- Route table ----------
  static final Map<String, WidgetBuilder> routes = {
    login: (context) => const LoginScreen(),
    register: (context) => const RegisterScreen(),
    otpVerify: (context) => const OtpVerifyScreen(),
    forgotPassword: (context) => const ForgotPasswordScreen(),
    resetPassword: (context) => const ResetPasswordScreen(),
    profile: (context) => const ProfileScreen(),
    editProfile: (context) => const EditProfileScreen(),
    settings: (context) => const SettingsScreen(),
  };
}
