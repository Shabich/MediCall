import 'package:flutter/material.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

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
          if (label == 'Téléphone' && !RegExp(r'^\d+$').hasMatch(value)) {
            return 'Veuillez entrer un numéro valide';
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
          // Ajouté pour éviter le débordement
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Center(
                  child: CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage('lib/assets/woman.png'),
                  ),
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
                        onPressed: () {
                          if (_formKey.currentState?.validate() ?? false) {
                            Navigator.pushReplacementNamed(
                                context, '/medicaments');
                          }
                        },
                        child: const Text('S\'inscrire'),
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
