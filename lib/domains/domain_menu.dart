import 'package:flutter/material.dart';
import 'domain_module.dart';

class DomainMenu extends StatelessWidget {
  const DomainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: domainRouter,
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