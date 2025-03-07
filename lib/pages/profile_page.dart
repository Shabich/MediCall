import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  // Déclaration des contrôleurs pour chaque champ
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isEditing = false;

  @override
  void initState() {
    super.initState();
    _loadUserData(); // Charger les données de l'utilisateur dès le démarrage
  }

  // Fonction pour charger les données depuis SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();

    setState(() {
      _nameController.text = prefs.getString('nom') ?? ''; // Nom
      _firstNameController.text = prefs.getString('prenom') ?? ''; // Prénom
      _emailController.text = prefs.getString('adresse_mail') ?? ''; // Email
      _addressController.text = prefs.getString('adresse') ?? ''; // Adresse
      _phoneController.text = prefs.getString('num_tel') ?? ''; // Téléphone
      _birthDateController.text =
          prefs.getString('date_naissance') ?? ''; // Date de naissance
    });
  }

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
