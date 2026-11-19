import 'package:flutter/material.dart';
import 'package:resolve/core/app_routes.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // ---------- App settings ----------
      debugShowCheckedModeBanner: false,
      title: 'Resolve',

      // ---------- Theme ----------
      theme: ThemeData(
        appBarTheme: const AppBarTheme(backgroundColor: Colors.white),
      ),

      // ---------- Routes ----------
      initialRoute: AppRoutes.login,
      routes: AppRoutes.routes,
    );
  }
}
