import 'dart:math';
import 'package:flutter/material.dart';

// ---------------------- CLASSES DE DÉS ----------------------
abstract class DicePool {
  final int sides;
  final Random _random = Random();

  DicePool(this.sides);

  int roll() => _random.nextInt(sides) + 1;

  List<int> rollMultiple(int count) {
    return List.generate(count, (_) => roll());
  }
}

class DicePool6 extends DicePool {
  DicePool6() : super(6);
}

class DicePool10 extends DicePool {
  DicePool10() : super(10);
}

class DicePool20 extends DicePool {
  DicePool20() : super(20);
}

class DicePool100 extends DicePool {
  DicePool100() : super(100);
}

// ---------------------- PAGE FLUTTER ----------------------
class DicePoolPage extends StatefulWidget {
  const DicePoolPage({super.key});

  @override
  State<DicePoolPage> createState() => _DicePoolPageState();
}

class _DicePoolPageState extends State<DicePoolPage> {
  List<DicePool> _dicePool = [];
  List<int> _results = [];
  final TextEditingController _faceCountController = TextEditingController();
  final TextEditingController _diceCountController = TextEditingController();
  final FocusNode _faceCountFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _diceCountController.text = "1";
  }

  @override
  void dispose() {
    _faceCountController.dispose();
    _diceCountController.dispose();
    _faceCountFocusNode.dispose();
    super.dispose();
  }

  void _rollDice() {
    setState(() {
      _results = [];
      for (var dice in _dicePool) {
        int diceCount = int.tryParse(_diceCountController.text) ?? 1;
        _results.addAll(dice.rollMultiple(diceCount));
      }
    });
  }

  void _addStandardDice(DicePool dice) {
    setState(() {
      _dicePool.add(dice);
    });
  }

  void _addCustomDice() {
    final faceCount = int.tryParse(_faceCountController.text);
    if (faceCount != null && faceCount > 0) {
      setState(() {
        _dicePool.add(_CustomDicePool(faceCount));
        // On ne vide PAS le contrôleur pour garder la valeur
        // Mais on peut remettre le focus pour permettre une nouvelle saisie
        _faceCountFocusNode.requestFocus();
      });
    }
  }

  void _clearPool() {
    setState(() {
      _dicePool.clear();
      _results.clear();
    });
  }

  // Calculer le total des dés dans le pool
  int get _totalDiceCount {
    int diceCount = int.tryParse(_diceCountController.text) ?? 1;
    return _dicePool.length * diceCount;
  }

  // Calculer la moyenne globale
  double get _overallAverage {
    if (_results.isEmpty) return 0.0;
    return _results.reduce((a, b) => a + b) / _results.length;
  }

  // Obtenir la liste des faces uniques
  String get _uniqueFaces {
    if (_dicePool.isEmpty) return "";
    Set<int> uniqueFaces = {};
    for (var dice in _dicePool) {
      uniqueFaces.add(dice.sides);
    }
    return uniqueFaces.map((face) => 'D$face').join(', ');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Personnalisé',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.green,
      ),
      body: Column(
        children: [
          // Zone logo avec fond vert
          Container(
            width: double.infinity,
            color: Colors.green,
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Image.asset(
                    'assets/images/paradice_logo.png',
                    height: 120,
                  ),
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: TextField(
                          controller: _faceCountController,
                          focusNode: _faceCountFocusNode,
                          decoration: const InputDecoration(
                            contentPadding: EdgeInsets.all(10.0),
                            labelText: 'Nombre de faces',
                            filled: true,
                            fillColor: Colors.white,
                            border: OutlineInputBorder(),
                          ),
                          keyboardType: TextInputType.number,
                          // Le texte ne s'effacera plus automatiquement
                        ),
                      ),
                      const SizedBox(width: 10),
                      ElevatedButton(
                        onPressed: _addCustomDice,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.green,
                          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        ),
                        child: const Text('Ajouter le dé'),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),


          // Affichage du pool actuel
          if (_dicePool.isNotEmpty)
            Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Pool de dés:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    children: _dicePool.asMap().entries.map((entry) {
                      return Chip(
                        label: Text('D${entry.value.sides}'),
                        backgroundColor: Colors.green[100],
                        deleteIcon: const Icon(Icons.close, size: 16),
                        onDeleted: () {
                          setState(() {
                            _dicePool.removeAt(entry.key);
                            _results.clear();
                          });
                        },
                      );
                    }).toList(),
                  ),
                ],
              ),
            ),

          // Choix du type de dé - Maintenant on peut sélectionner plusieurs dés
          Container(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                const Text(
                  'Ajouter des dés standards:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ElevatedButton(
                      onPressed: () => _addStandardDice(DicePool6()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('D6'),
                    ),
                    ElevatedButton(
                      onPressed: () => _addStandardDice(DicePool10()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('D10'),
                    ),
                    ElevatedButton(
                      onPressed: () => _addStandardDice(DicePool20()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('D20'),
                    ),
                    ElevatedButton(
                      onPressed: () => _addStandardDice(DicePool100()),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                      child: const Text('D100'),
                    ),
                  ],
                ),
            
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Boutons Vider / Lancer
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                onPressed: _clearPool,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
                child: const Text('Vider le pool des dés'),
              ),
              ElevatedButton(
                onPressed: _rollDice,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                ),
                child: const Text('Lancer les dés'),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Affichage des résultats
          Expanded(
            child: _results.isEmpty
                ? const Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Les résultats :",
                          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 20),
                        // Tableau vide
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 16.0),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Text(
                                  'Nb faces',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Nb dés',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Résultat',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Expanded(
                                child: Text(
                                  'Moyenne',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                : Column(
                    children: [
                      const SizedBox(height: 20),
                      const Text(
                        "Les résultats :",
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 20),
                      // En-tête du tableau
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                'Nb faces',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Nb dés',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Résultat',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                'Moyenne',
                                style: TextStyle(fontWeight: FontWeight.bold),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Ligne des résultats
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 10),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Text(
                                _uniqueFaces,
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                '$_totalDiceCount',
                                textAlign: TextAlign.center,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                _results.join(', '),
                                textAlign: TextAlign.center,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            Expanded(
                              child: Text(
                                _overallAverage.toStringAsFixed(2),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Affichage détaillé des résultats
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Détail des lancers:',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 10),
                              Expanded(
                                child: ListView.builder(
                                  itemCount: _results.length,
                                  itemBuilder: (context, index) {
                                    return ListTile(
                                      leading: CircleAvatar(
                                        backgroundColor: Colors.green[100],
                                        child: Text(_results[index].toString()),
                                      ),
                                      title: Text('Lancer ${index + 1}'),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
          ),
        ],
      ),
    );
  }
}

// Classe pour les dés personnalisés
class _CustomDicePool extends DicePool {
  _CustomDicePool(int sides) : super(sides);
}