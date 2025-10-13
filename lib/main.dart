import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter_paradice/splash_screen.dart';
import 'package:flutter_paradice/dice.dart';



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
      home: const SplashScreen(), // <-- le splash screen s'affiche d'abord
    );
  }
}

