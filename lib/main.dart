import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:resolve/core/app_routes.dart';
import 'package:resolve/viewmodel/profile_viewmodel.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [ChangeNotifierProvider(create: (_) => ProfileViewModel())],
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
        initialRoute: AppRoutes.login,
        routes: AppRoutes.routes,
      ),
    );
  }
}
