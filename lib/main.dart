import 'package:flutter/material.dart';
import 'package:flutter_paradice/splash_screen.dart'; // Import de l'écran de lancement



void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Para'Dice",
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.green),
        useMaterial3: true,
      ),
      home: const SplashScreen(), // L'écran affiché au lancement de l'application
    );
  }
}

