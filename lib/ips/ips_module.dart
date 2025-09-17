// lib/ips/ips_module.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'screens/home_screen.dart';
import 'screens/result_screen.dart';
import 'screens/manage_apis_screen.dart';

final _router = GoRouter(
  routes: [
    GoRoute(path: '/', builder: (_, __) => const HomeScreen()),
    GoRoute(path: '/result', builder: (_, __) => const ResultScreen()),
    GoRoute(path: '/apis', builder: (_, __) => const ManageApisScreen()),
  ],
);

class IpsMenu extends StatelessWidget {
  const IpsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _router,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.light,
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorSchemeSeed: Colors.indigo,
        brightness: Brightness.dark,
      ),
    );
  }
}