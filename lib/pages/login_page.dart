import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  String? _errorMessage; // Variable pour stocker le message d'erreur

  // Fonction pour enregistrer l'email dans SharedPreferences
  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      // Log: Affichage des données de l'utilisateur avant l'enregistrement
      debugPrint('Données utilisateur avant enregistrement: $userData');

      // Vérification et conversion de chaque donnée avant de la sauvegarder
      final idTUser = userData['id_t_user'];
      debugPrint('id_t_user: $idTUser, type: ${idTUser.runtimeType}');
      if (idTUser is String) {
        debugPrint('Conversion de id_t_user en int: $idTUser');
        await prefs.setInt(
            'id_t_user',
            int.tryParse(idTUser) ??
                0); // Si c'est une chaîne, essaie de la convertir en int
      } else if (idTUser is int) {
        await prefs.setInt('id_t_user',
            idTUser); // Si c'est déjà un int, sauvegarde directement
      }

      // Pour les autres champs, assure-toi qu'ils sont correctement typés
      final nom = userData['nom'];
      debugPrint('nom: $nom, type: ${nom.runtimeType}');
      await prefs.setString('nom', nom);

      final prenom = userData['prenom'];
      debugPrint('prenom: $prenom, type: ${prenom.runtimeType}');
      await prefs.setString('prenom', prenom);

      final adresseMail = userData['adresse_mail'];
      debugPrint(
          'adresse_mail: $adresseMail, type: ${adresseMail.runtimeType}');
      await prefs.setString('adresse_mail', adresseMail);

      final adresse = userData['adresse'];
      debugPrint('adresse: $adresse, type: ${adresse.runtimeType}');
      await prefs.setString('adresse', adresse);

      final numTel = userData['num_tel'];
      debugPrint('num_tel: $numTel, type: ${numTel.runtimeType}');
      await prefs.setString('num_tel', numTel);

      final dateNaissance = userData['date_naissance'];
      debugPrint(
          'date_naissance: $dateNaissance, type: ${dateNaissance.runtimeType}');
      await prefs.setString('date_naissance', dateNaissance);

      final password = userData['password'];
      debugPrint('password: $password, type: ${password.runtimeType}');
      await prefs.setString('password', password);

      // Vérification de type pour 'admin' et 'id_t_rappel'
      final admin = userData['admin'];
      debugPrint('admin: $admin, type: ${admin.runtimeType}');
      await prefs.setInt(
          'admin',
          admin is int
              ? admin
              : 0); // Si admin est un int, le sauvegarder, sinon utiliser 0.

      final idTRappel = userData['id_t_rappel'];
      debugPrint('id_t_rappel: $idTRappel, type: ${idTRappel.runtimeType}');
      await prefs.setInt('id_t_rappel',
          idTRappel is int ? idTRappel : 0); // Idem pour id_t_rappel.

      // Sauvegarde toutes les données comme une chaîne JSON
      String userDataJson = json.encode(userData);
      debugPrint('User Data JSON: $userDataJson'); // Vérifie le JSON sauvegardé
      await prefs.setString('user_data', userDataJson);

      debugPrint("Données de l'utilisateur enregistrées avec succès.");
    } catch (e) {
      debugPrint("Erreur lors de l'accès à SharedPreferences: $e");
    }
  }

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
                            //Premiere requete pour faire la verification avec le body
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

                              //Deuxieme requete pour récuperer les données du user
                              final dataUser = await http.post(
                                Uri.parse(
                                    'http://localhost:3000/api/users/info'),
                                headers: {"Content-Type": "application/json"},
                                body: jsonEncode({
                                  "adresse_mail": email,
                                  "password": password
                                }),
                              );

                              // Enregistrer les données utilisateur dans SharedPreferences après la connexion

                              var sentData = dataUser.body;
                              debugPrint('$sentData datause');
                              await _saveUserData(json.decode(dataUser
                                  .body)); // Décoder la réponse JSON en Map

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
