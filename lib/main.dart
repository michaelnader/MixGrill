import 'package:flutter/material.dart';
import 'home.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.transparent, // Ensure background is transparent
        pageTransitionsTheme: const PageTransitionsTheme(
          builders: {
            TargetPlatform.android: FadeUpwardsPageTransitionsBuilder(), // Smooth fade effect
            TargetPlatform.iOS: CupertinoPageTransitionsBuilder(), // iOS-like transition
          },
        ),
      ),
      home: const SplashScreen(), // Ensure this is the correct entry point
    );
  }
}
