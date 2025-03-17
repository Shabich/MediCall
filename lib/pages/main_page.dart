import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class MenuPage extends StatelessWidget {
  const MenuPage({super.key});

  void _showLegalDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Mentions légales"),
        content: const Text(
            "Cette application est développée par MediCall Team. Toutes les données sont protégées et respectent la réglementation en vigueur."),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Fermer"),
          ),
        ],
      ),
    );
  }

  // Modifiez cette fonction pour accepter `context` comme argument
  void _contactSupport(BuildContext context) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@medicall.com',
    );

    try {
      if (await canLaunchUrl(emailUri)) {
        await launchUrl(emailUri);
      } else {
        throw 'Impossible d\'ouvrir l\'application de messagerie.';
      }
    } catch (e) {
      // Afficher un message d'erreur si quelque chose échoue
      debugPrint('Erreur lors de l\'ouverture de l\'email: $e');
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erreur: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "MediCall est une application conçue pour vous aider à gérer vos prises de médicaments avec des rappels personnalisés et un suivi détaillé.",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const Divider(height: 30, thickness: 1),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.check_circle, color: Color(0xFF4F4CD2)),
                SizedBox(width: 10),
                Text(
                  "Service opérationnel",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
            const SizedBox(height: 10),
            Row(
              children: const [
                Icon(Icons.update, color: Color(0xFF4F4CD2)),
                SizedBox(width: 10),
                Text(
                  "Dernière mise à jour : 17 Mars 2025",
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                ),
              ],
            ),
            const Divider(height: 30, thickness: 1),
            const SizedBox(height: 10),
            const Text(
              "Version : 1.0.0",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const SizedBox(height: 10),
            const Text(
              "Développé par : MediCall Team",
              style: TextStyle(fontSize: 16, color: Colors.black87),
            ),
            const Spacer(),
            const Divider(height: 30, thickness: 1),
            ListTile(
              leading: const Icon(Icons.email, color: Color(0xFF4F4CD2)),
              title: const Text("Contacter le support"),
              onTap: () => _contactSupport(context), // Passez `context` ici
            ),
            ListTile(
              leading: const Icon(Icons.description, color: Color(0xFF4F4CD2)),
              title: const Text("Mentions légales"),
              onTap: () => _showLegalDialog(context),
            ),
          ],
        ),
      ),
    );
  }
}
