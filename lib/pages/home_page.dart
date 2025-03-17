import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 40.0, horizontal: 20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 80),
              const CircleAvatar(
                backgroundColor: Colors.transparent,
                radius: 80,
                backgroundImage: AssetImage('lib/assets/logo/logo512x512.png'),
              ),
              const SizedBox(height: 20),
              const Text(
                'Bienvenue sur MediCall',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4F4CD2),
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 10),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(fontSize: 16, color: Colors.black87),
                  children: [
                    TextSpan(text: 'MediCall est votre '),
                    TextSpan(
                      text: 'assistant santé personnel. ',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text:
                            'Recevez des rappels pour vos prises de médicaments et ne manquez plus aucune dose !'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Comment ça marche ?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF4F4CD2),
                ),
              ),
              const SizedBox(height: 15),
              Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: const [
                        Icon(Icons.notifications, color: Color(0xFF4F4CD2)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Recevez des rappels précis pour chaque médicament.',
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      children: const [
                        Icon(Icons.history, color: Color(0xFF4F4CD2)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            "Suivez l'historique des prises et recevez des alertes en cas d'oubli.",
                            style:
                                TextStyle(fontSize: 16, color: Colors.black87),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Divider(),
              const SizedBox(height: 20),
              RichText(
                textAlign: TextAlign.center,
                text: const TextSpan(
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Colors.black54,
                  ),
                  children: [
                    TextSpan(text: 'Prêt à gérer vos '),
                    TextSpan(
                      text: 'médicaments',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    TextSpan(
                        text:
                            ' efficacement ? Inscrivez-vous ou connectez-vous dès maintenant !'),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              GestureDetector(
                onTap: () {
                  // Navigation vers la page de connexion/inscription
                  Navigator.pushNamed(context, '/signup');
                },
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 40, vertical: 12),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF6874DA),
                        Color(0xFF6D64C5),
                      ],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Text(
                    'Commencer',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
