import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AppLayout extends StatelessWidget {
  final Widget child;
  const AppLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Titre et bouton de menu burger
        title: const Text('MediCall'),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage('lib/assets/fondBurger.jpg'),
                  fit: BoxFit.cover,
                ),
              ),
              child: Align(
                alignment: Alignment.bottomLeft,
              ),
            ),
            ListTile(
              leading: const Icon(Icons.home),
              title: const Text('Accueil'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/home');
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
              leading: const Icon(Icons.notifications),
              title: const Text('Rappels'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/rappels');
              },
            ),
            ListTile(
              leading: const Icon(Icons.access_time),
              title: const Text("Historique d'achat"),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/historique');
              },
            ),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.person),
              title: const Text('Profil'),
              onTap: () {
                Navigator.of(context).pop();
                Navigator.pushReplacementNamed(context, '/profile');
              },
            ),
            ListTile(
              leading: const Icon(Icons.lock_outline),
              title: const Text('Se déconnecter'),
              onTap: () async {
                Navigator.of(context).pop();
                SharedPreferences preferences =
                    await SharedPreferences.getInstance();
                await preferences.clear();
                Navigator.pushReplacementNamed(context, '/');
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Contenu de la page (derrière le Drawer)
          Positioned.fill(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: child,
            ),
          ),
          // Le Drawer ne sera plus visible ici, il est contrôlé par le bouton burger de l'AppBar
        ],
      ),
    );
  }
}
