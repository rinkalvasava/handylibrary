import 'dart:io'; // For HttpOverrides and HttpClient
import 'package:flutter/material.dart';
import 'package:handy_library/splash_screen.dart';

void main() {
  // Override the HTTP client to accept all SSL certificates (development use only)
  HttpOverrides.global = MyHttpOverrides();

  runApp(const MyApp());
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) =>
              true; // Accepts all certificates
  }
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.system,
      debugShowCheckedModeBanner: false, // Disable the debug banner
      home: const SplashScreen(),
    );
  }
}
