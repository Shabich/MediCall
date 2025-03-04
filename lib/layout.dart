import 'package:flutter/material.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image:
                      AssetImage('lib/assets/fondBurger.jpg'), // Image locale
                  fit: BoxFit
                      .cover, // Ajuste l'image pour qu'elle couvre tout l'espace
                ),
              ),
              child: Align(
                alignment:
                    Alignment.bottomLeft, // Positionne le texte en bas à gauche
                child: Padding(
                  padding: const EdgeInsets.all(
                      16.0), // Ajouter un peu d'espace autour du texte
                ),
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Accueil'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Médicaments'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/medicaments');
              },
            ),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/profile');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.list),
              title: const Text('Rappels'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/rappels');
              },
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }
}
