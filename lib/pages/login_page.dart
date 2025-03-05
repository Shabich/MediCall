import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage; // Variable pour stocker le message d'erreur

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Connexion')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Center(
                child: CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('lib/assets/boy.png'),
                ),
              ),
              const SizedBox(height: 20),
              if (_errorMessage != null)
                Text(
                  _errorMessage!,
                  style: const TextStyle(color: Colors.red, fontSize: 14),
                ),
              const SizedBox(height: 10),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Veuillez entrer un email';
                        }
                        if (!RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
                          return 'Veuillez entrer un email valide';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: _passwordController,
                      obscureText: true,
                      decoration: InputDecoration(
                        labelText: 'Mot de passe',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16.0),
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    ElevatedButton(
                      onPressed: () async {
                        if (_formKey.currentState?.validate() ?? false) {
                          final String email = _emailController.text;
                          final String password = _passwordController.text;
                          debugPrint(
                              'Adresse mail: $email, Mot de passe: $password');

                          final Map<String, String> body = {
                            "email": email,
                            "password": password,
                          };

                          try {
                            final response = await http.post(
                              Uri.parse(
                                  'http://localhost:3000/api/auth/signin'),
                              headers: {"Content-Type": "application/json"},
                              body: jsonEncode(body),
                            );

                            if (response.statusCode == 200) {
                              debugPrint('Connexion réussie: ${response.body}');
                              setState(() {
                                _errorMessage =
                                    null; // Réinitialiser le message d'erreur
                              });
                              Navigator.pushReplacementNamed(
                                  context, '/medicaments');
                            } else {
                              setState(() {
                                _passwordController
                                    .clear(); // Effacer le champ mot de passe
                                _errorMessage =
                                    "Le mot de passe ou l'adresse mail est erroné."; // Afficher le message d'erreur
                              });
                              debugPrint(
                                  'Erreur de connexion: ${response.body}');
                            }
                          } catch (e) {
                            setState(() {
                              _errorMessage =
                                  'Erreur réseau, veuillez réessayer';
                            });
                            debugPrint('Erreur réseau: $e');
                          }
                        }
                      },
                      child: const Text('Se connecter'),
                    ),
                    const SizedBox(height: 10),
                    TextButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/signup');
                      },
                      child: const Text('Créer un compte'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
