import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:resolve/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    // Profile storage is mocked so the profile screen can load in tests.
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('App opens on the login screen', (WidgetTester tester) async {
    // ---------- Build the app ----------
    await tester.pumpWidget(const MyApp());

    // ---------- Check the first screen ----------
    expect(find.text('Welcome Back, Athlete'), findsOneWidget);
    expect(find.text('SIGN IN'), findsOneWidget);
  });

  testWidgets('Sign in with empty fields shows errors', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // ---------- Tap sign in without typing ----------
    await tester.ensureVisible(find.text('SIGN IN'));
    await tester.tap(find.text('SIGN IN'));
    await tester.pump();

    expect(find.text('Please enter your email'), findsOneWidget);
    expect(find.text('Please enter your passkey'), findsOneWidget);
  });

  testWidgets('Valid sign in opens the profile screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());

    // ---------- Fill in the form ----------
    await tester.enterText(find.byType(TextFormField).at(0), 'ram@resolve.np');
    await tester.enterText(find.byType(TextFormField).at(1), 'secret123');

    await tester.ensureVisible(find.text('SIGN IN'));
    await tester.tap(find.text('SIGN IN'));
    await tester.pumpAndSettle();

    expect(find.text('My Profile'), findsWidgets);
  });
}
