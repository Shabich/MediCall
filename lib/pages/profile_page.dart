import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Déclaration des contrôleurs pour chaque champ
  final TextEditingController _nameController =
      TextEditingController(text: 'Dupont');
  final TextEditingController _firstNameController =
      TextEditingController(text: 'Jean');
  final TextEditingController _emailController =
      TextEditingController(text: 'jean.dupont@example.com');
  final TextEditingController _addressController =
      TextEditingController(text: '12 rue des Lilas, Paris');
  final TextEditingController _phoneController =
      TextEditingController(text: '+33 6 12 34 56 78');
  final TextEditingController _birthDateController =
      TextEditingController(text: '15/06/1990');
  final TextEditingController _passwordController =
      TextEditingController(text: 'password');
  bool _isEditing = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Center(
              child: CircleAvatar(
                radius: 50,
                backgroundImage: AssetImage('lib/assets/boy.png'),
              ),
            ),
            const SizedBox(height: 20),
            // Nom
            _buildProfileField('Nom', _nameController),
            _buildProfileField('Prénom', _firstNameController),
            _buildProfileField('Email', _emailController),
            _buildProfileField('Adresse', _addressController),
            _buildProfileField('Téléphone', _phoneController),
            _buildProfileField('Date de naissance', _birthDateController),
            // Ajouter le champ mot de passe seulement en mode édition
            if (_isEditing)
              _buildProfileField('Mot de passe', _passwordController,
                  isPassword: true),
            const SizedBox(height: 20),

            // Bouton Modifier le profil
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _isEditing = !_isEditing;
                });
              },
              icon: const Icon(Icons.edit),
              label: Text(
                  _isEditing ? 'Sauvegarder le profil' : 'Modifier le profil'),
            ),
            const SizedBox(height: 20),

            // Bouton Déconnexion
            ElevatedButton.icon(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/');
              },
              icon: const Icon(Icons.logout, color: Colors.red),
              label: const Text(
                'Se déconnecter',
                style: TextStyle(color: Colors.red),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                side: const BorderSide(color: Colors.red),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Fonction pour afficher un champ de profil modifiable ou non
  Widget _buildProfileField(String label, TextEditingController controller,
      {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
                fontSize: 14, fontWeight: FontWeight.bold, color: Colors.grey),
          ),
          const SizedBox(height: 4),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(8),
            ),
            child: _isEditing
                ? TextField(
                    controller: controller,
                    obscureText:
                        isPassword, // Masquer le texte si c'est un mot de passe
                    decoration: const InputDecoration(border: InputBorder.none),
                  )
                : Text(
                    controller.text,
                    style: const TextStyle(fontSize: 16),
                  ),
          ),
        ],
      ),
    );
  }
}
