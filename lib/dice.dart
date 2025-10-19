import 'package:flutter/material.dart';
import 'dart:math';
import 'dicepool.dart'; // <-- on importe tes classes métiers

// 🎨 --- Partie 2 : Interface Flutter (UI) ---

class DicePage extends StatefulWidget {
  const DicePage({super.key});

  @override
  State<DicePage> createState() => _DicePageState();
}

class _DicePageState extends State<DicePage> with TickerProviderStateMixin {
  int numberOfDice = 1;
  int diceSides = 6;
  List<int> results = [];
  double average = 0;

  late DicePool dice; // instance métier

  late AnimationController _rotateController;
  late Animation<double> _rotateAnimation;

  late AnimationController _buttonController;
  late Animation<double> _buttonAnimation;

  late AnimationController _shakeController;
  late Animation<double> _shakeAnimation;

  bool isRolling = false;

  @override
  void initState() {
    super.initState();

    // Initialisation obligatoire pour éviter les erreurs
    dice = DicePool6();

    // Rotation du logo
    _rotateController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _rotateAnimation = Tween<double>(begin: 0, end: 2 * pi).animate(
      CurvedAnimation(parent: _rotateController, curve: Curves.easeInOut),
    );

    // 🎛 Animation du bouton (scale)
    _buttonController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _buttonAnimation = Tween<double>(begin: 0.8, end: 1.2).animate(
      CurvedAnimation(parent: _buttonController, curve: Curves.easeInOut),
    );
    _buttonController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _buttonController.reverse();
      }
    });

    // 🌪 Tremblement du logo
    _shakeController = AnimationController(
      duration: const Duration(milliseconds: 700),
      vsync: this,
    );
    _shakeAnimation = Tween<double>(begin: -5, end: 5).animate(
      CurvedAnimation(parent: _shakeController, curve: Curves.elasticIn),
    );
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _buttonController.dispose();
    _shakeController.dispose();
    super.dispose();
  }

  void changeDiceType(int sides) {
    setState(() {
      diceSides = sides;
      // On change la classe métier en fonction du nombre de faces
      switch (sides) {
        case 6:
          dice = DicePool6();
          break;
        case 10:
          dice = DicePool10();
          break;
        case 20:
          dice = DicePool20();
          break;
        case 100:
          dice = DicePool100();
          break;
      }
      results.clear();
      average = 0;
    });
  }

  void updateDiceCount(int change) {
    setState(() {
      numberOfDice = (numberOfDice + change).clamp(1, 100);
      results.clear();
      average = 0;
    });
  }

  Future<void> rollDice() async {
    if (isRolling) return;
    setState(() => isRolling = true);

    // Lance les animations
    _rotateController.forward(from: 0);
    _shakeController.forward(from: 0);
    _buttonController.forward();

    // Attente de la durée de rotation
    await Future.delayed(const Duration(milliseconds: 700));

    // 🎲 On utilise maintenant la classe métier pour lancer les dés
    results = dice.rollMultiple(numberOfDice);

    average = results.isNotEmpty
        ? results.reduce((a, b) => a + b) / results.length
        : 0;

    setState(() => isRolling = false);
  }

  @override
  Widget build(BuildContext context) {
    Map<int, int> resultCount = {};
    for (var i = 1; i <= diceSides; i++) {
      resultCount[i] = results.where((r) => r == i).length;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Statistiques',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Zone logo avec fond vert
            Container(
              width: double.infinity,
              color: Colors.green, // même couleur que l'AppBar
              padding: const EdgeInsets.all(16),
              child: AnimatedBuilder(
                animation: Listenable.merge([_rotateController, _shakeController]),
                builder: (context, child) {
                  return Transform.translate(
                    offset: Offset(isRolling ? _shakeAnimation.value : 0, 0),
                    child: Transform.rotate(
                      angle: isRolling ? _rotateAnimation.value : 0,
                      child: Image.asset(
                        'assets/images/paradice_logo.png',
                        height: 180,
                      ),
                    ),
                  );
                },
              ),
            ),

            const SizedBox(height: 10),

            // Choix des dés
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var sides in [6, 10, 20, 100])
                  ElevatedButton(
                    onPressed: () => changeDiceType(sides),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: diceSides == sides ? Colors.green : Colors.white,
                      foregroundColor: diceSides == sides ? Colors.white : Colors.black,
                    ),
                    child: Text("D$sides"),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            // Ajustement du nombre de dés
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                for (var change in [-10, -1, 1, 10])
                  ElevatedButton(
                    onPressed: () => updateDiceCount(change),
                    child: Text(
                      change > 0 ? "+$change" : "$change",
                      style: const TextStyle(fontSize: 16),
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 10),

            Text(
              "Nombre de D$diceSides : $numberOfDice",
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            const Text(
              "Les résultats :",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 5),

            Wrap(
              spacing: 20,
              runSpacing: 4,
              children: resultCount.entries.map((entry) {
                return Text("Nombre de ${entry.key} : ${entry.value}");
              }).toList(),
            ),

            const SizedBox(height: 15),

            Text(
              "Moyenne obtenue : ${average.toStringAsFixed(2)}",
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),

      floatingActionButton: ScaleTransition(
        scale: _buttonAnimation,
        child: FloatingActionButton(
          onPressed: isRolling ? null : rollDice,
          backgroundColor: isRolling ? const Color.fromARGB(255, 245, 196, 196) : Colors.green,
          child: const Icon(Icons.casino),
        ),
      ),
    );
  }
}