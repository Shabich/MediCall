import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 20.0, horizontal: 16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('lib/assets/logo.png'),
                ),
              ),
              const SizedBox(height: 30),
              const Text(
                'Bienvenue sur MediCall',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              const Text(
                'MediCall est une application mobile dédiée aux clients de GSB, '
                'qui leur permet de recevoir des rappels personnalisés pour la prise '
                'de leurs médicaments directement sur leurs téléphones. Vous n\'oubliez '
                'plus jamais de prendre vos médicaments grâce à notre système de notifications !',
                style: TextStyle(fontSize: 16, color: Colors.black87),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 40),
              const Text(
                'Comment ça marche ?',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue,
                ),
              ),
              const SizedBox(height: 15),
              const Text(
                '1. Ajouter vos médicaments à l\'application.\n'
                '2. Recevoir des rappels à des heures précises pour chaque médicament.\n'
                '3. Suivre l\'historique des prises et être alerté en cas de dose manquée.',
                style: TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 20),
              const Text(
                'Vous êtes prêt à ne plus oublier vos médicaments !\n'
                'Inscrivez-vous ou connectez-vous pour commencer à utiliser MediCall.',
                style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
