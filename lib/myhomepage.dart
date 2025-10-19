import 'package:flutter/material.dart';
import 'package:flutter_paradice/dice.dart'; // Import de la page DicePage pour la navigation
import 'package:flutter_paradice/dicepool.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Accueil",
        style: TextStyle(color: Colors.white),), // Titre affiché dans la barre d'app
      ),

      // Drawer
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Text(
                'Menu',
                style: TextStyle(color: Colors.green, fontSize: 24),
              ),
            ),

            // Option 1 : accès aux statistiques
            ListTile(
              title: Text(
                'Accès aux statistiques',
                style: TextStyle(color: Colors.green),
              ),
              onTap: () {
                Navigator.pop(context); // Ferme le drawer
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DicePage()), // Navigue vers la page Statistiques
                );
              },
            ),

            // Option 2 : accès aux dés personnalisés
            ListTile(
              title: Text(
                'Accès aux dés personnalisés',
                style: TextStyle(color: Colors.green),
              ),
              onTap: () {
                Navigator.pop(context);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => DicePoolPage()), // Navigue vers la page des dés/statistiques
                );
                // ici tu peux ajouter la navigation vers une autre page
              },
            ),
          ],
        ),
      ),

      // Contenu principal
      body: Column(
        children: [
          // Partie supérieure : logo et fond (50% de l'écran)
          Container(
            height: screenHeight * 0.5,
            width: double.infinity,
            color: Colors.green,
            child: Center(
              child: Image.asset(
                'assets/images/paradice_logo.png', // Logo de l'application
                height: 180,
              ),
            ),
          ),

          // Partie inférieure : bouton (50% de l'écran)
          Expanded(
            child: Container(
              width: double.infinity,
              color: Colors.white,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => DicePage()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(
                        horizontal: 24, vertical: 16),
                  ),
                  child: const Text(
                    'Accès aux statistiques',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const DicePoolPage()),
                   );
                  },
                  style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green[700],
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 16),
                      ),
                    child: const Text(
                      'Accès aux dés personnalisés',
                      style: TextStyle(fontSize: 16),
               ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
