import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _firstNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _addressController = TextEditingController();
  final _phoneController = TextEditingController();
  final _birthDateController = TextEditingController();
  final _passwordController = TextEditingController();

  Future<void> _saveUserData(Map<String, dynamic> userData) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      debugPrint('Données utilisateur avant enregistrement: $userData');

      if (userData.containsKey('id_t_user')) {
        final idTUser = userData['id_t_user'];
        await prefs.setInt('id_t_user',
            idTUser is int ? idTUser : int.tryParse(idTUser.toString()) ?? 0);
      }

      final List<String> keys = [
        'nom',
        'prenom',
        'adresse_mail',
        'adresse',
        'num_tel',
        'date_naissance',
        'password'
      ];
      for (var key in keys) {
        if (userData.containsKey(key)) {
          await prefs.setString(key, userData[key] ?? '');
        }
      }

      if (userData.containsKey('admin')) {
        await prefs.setInt(
            'admin', userData['admin'] is int ? userData['admin'] : 0);
      }

      if (userData.containsKey('id_t_rappel')) {
        await prefs.setInt('id_t_rappel',
            userData['id_t_rappel'] is int ? userData['id_t_rappel'] : 0);
      }

      await prefs.setString('user_data', json.encode(userData));
      debugPrint("Données utilisateur enregistrées avec succès.");
    } catch (e) {
      debugPrint("Erreur lors de l'accès à SharedPreferences: $e");
    }
  }

  Future<void> _signUp() async {
    if (_formKey.currentState?.validate() ?? false) {
      final url = Uri.parse(
          'http://localhost:3000/api/auth/signup'); // Modifier localhost si besoin
      final body = jsonEncode({
        'nom': _nameController.text,
        'prenom': _firstNameController.text,
        'email': _emailController.text,
        'adresse': _addressController.text,
        'num_tel': _phoneController.text,
        'date_naissance': _birthDateController.text,
        'password': _passwordController.text,
      });

      try {
        final response = await http.post(
          url,
          headers: {'Content-Type': 'application/json'},
          body: body,
        );

        if (response.statusCode == 201) {
          await _fetchUserInfo();
        } else {
          final responseData = json.decode(response.body);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
                content: Text(responseData['message'] ??
                    "Échec de l'inscription, réessayez.")),
          );
        }
      } catch (e) {
        debugPrint("Erreur réseau: $e");
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
              content: Text("Erreur de connexion. Vérifiez votre réseau.")),
        );
      }
    }
  }

  Future<void> _fetchUserInfo() async {
    final url = Uri.parse(
        'http://localhost:3000/api/users/info'); // Modifier localhost si besoin
    final body = jsonEncode({
      'adresse_mail': _emailController.text,
      'password': _passwordController.text,
    });

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: body,
      );

      if (response.statusCode == 200) {
        await _saveUserData(json.decode(response.body));
        Navigator.pushReplacementNamed(context, '/medicaments');
      } else {
        final responseData = json.decode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(responseData['message'] ??
                  "Impossible de récupérer les infos utilisateur.")),
        );
      }
    } catch (e) {
      debugPrint("Erreur réseau: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text("Erreur de connexion. Vérifiez votre réseau.")),
      );
    }
  }

  Widget _buildProfileField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextFormField(
        controller: controller,
        obscureText: isPassword,
        keyboardType:
            label == 'Email' ? TextInputType.emailAddress : TextInputType.text,
        decoration: InputDecoration(
          labelText: label,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(16.0)),
        ),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return 'Veuillez entrer $label';
          }
          if (label == 'Email' && !RegExp(r'\S+@\S+\.\S+').hasMatch(value)) {
            return 'Veuillez entrer un email valide';
          }
          return null;
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Inscription")),
      body: Center(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const CircleAvatar(
                  radius: 50,
                  backgroundImage: AssetImage('lib/assets/woman.png'),
                ),
                const SizedBox(height: 20),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      _buildProfileField('Nom', _nameController),
                      _buildProfileField('Prénom', _firstNameController),
                      _buildProfileField('Email', _emailController),
                      _buildProfileField('Adresse', _addressController),
                      _buildProfileField('Téléphone', _phoneController),
                      _buildProfileField(
                          'Date de naissance', _birthDateController),
                      _buildProfileField('Mot de passe', _passwordController,
                          isPassword: true),
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed: _signUp,
                        child: const Text("S'inscrire"),
                      ),
                      const SizedBox(height: 10),
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text('Déjà un compte ? Se connecter'),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
