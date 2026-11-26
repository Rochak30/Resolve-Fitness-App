import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resolve/core/app_routes.dart';
import 'package:resolve/viewmodel/profile_viewmodel.dart';
import 'package:resolve/viewmodel/training_preferences_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => ProfileViewModel()),
        ChangeNotifierProvider(create: (_) => TrainingPreferencesViewModel()),
      ],
      
      child: MaterialApp(
        // ---------- App settings ----------
        debugShowCheckedModeBanner: false,
        title: 'Resolve',

        // ---------- Theme ----------
        theme: ThemeData(
          fontFamily: 'PlusJakartaSans',
          appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
        ),

        // ---------- Routes ----------
        initialRoute: AppRoutes.trainingPreferences,
        routes: AppRoutes.routes,
      ),
    );
  }
}
