import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _birthDateController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
      TextEditingController();
  bool _isEditing = false;
  bool _passwordsMatch = true;
  String? _oldEmail; // Stocker l'ancienne adresse e-mail

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _nameController.text = prefs.getString('nom') ?? '';
      _firstNameController.text = prefs.getString('prenom') ?? '';
      _emailController.text = prefs.getString('adresse_mail') ?? '';
      _oldEmail = _emailController.text; // Sauvegarde de l'ancien email
      _addressController.text = prefs.getString('adresse') ?? '';
      _phoneController.text = prefs.getString('num_tel') ?? '';
      _birthDateController.text =
          prefs.getString('date_naissance')?.substring(0, 10) ?? '';
    });
    debugPrint("Données utilisateur chargées: $_oldEmail");
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      setState(() {
        _birthDateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _saveProfile(String currentPassword) async {
    if (_newPasswordController.text.isNotEmpty && !_passwordsMatch) {
      debugPrint("Erreur: les mots de passe ne correspondent pas");

      return;
    }

    final prefs = await SharedPreferences.getInstance();
    int? userId = prefs.getInt('id_t_user');
    if (userId == null) {
      debugPrint("Erreur: ID utilisateur introuvable dans SharedPreferences");
      return;
    }

    final body = jsonEncode({
      'nom': _nameController.text,
      'prenom': _firstNameController.text,
      'ancienne_adresse_mail': _oldEmail,
      'adresse_mail': _emailController.text,
      'adresse': _addressController.text,
      'num_tel': _phoneController.text,
      'date_naissance': _birthDateController.text,
      'current_password': currentPassword,
      'new_password': _newPasswordController.text.isNotEmpty
          ? _newPasswordController.text
          : null,
    });

    debugPrint("Envoi des données au serveur: $body id: $userId");

    final response = await http.put(
      Uri.parse('http://localhost:3000/api/users/$userId'),
      headers: {'Content-Type': 'application/json'},
      body: body,
    );

    debugPrint("Réponse du serveur: ${response.statusCode} - ${response.body}");

    if (response.statusCode == 200) {
      setState(() => _isEditing = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Profil mis à jour avec succès!')),
      );
    } else {
      setState(() {
        _showPasswordDialog(error: true);
      });
    }
  }

  void _showPasswordDialog({bool error = false}) {
    TextEditingController passwordController = TextEditingController();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Vérification du mot de passe'),
        content: TextField(
          controller: passwordController,
          obscureText: true,
          decoration: InputDecoration(
            labelText: 'Mot de passe actuel',
            errorText: error ? 'Mot de passe incorrect' : null,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Annuler'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              debugPrint("Mot de passe saisi: ${passwordController.text}");

              _saveProfile(passwordController.text);
            },
            child: const Text('Confirmer'),
          ),
        ],
      ),
    );
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
            _buildProfileField('Nom', _nameController),
            _buildProfileField('Prénom', _firstNameController),
            _buildProfileField('Email', _emailController),
            _buildProfileField('Adresse', _addressController),
            _buildProfileField('Téléphone', _phoneController),
            _buildDatePickerField('Date de naissance', _birthDateController),
            if (_isEditing) ...[
              _buildPasswordField(
                  'Nouveau mot de passe', _newPasswordController),
              _buildPasswordField('Confirmer le nouveau mot de passe',
                  _confirmNewPasswordController),
            ],
            const SizedBox(height: 20),
            ElevatedButton.icon(
              onPressed: () {
                if (_isEditing) {
                  _showPasswordDialog();
                } else {
                  setState(() => _isEditing = true);
                }
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

  Widget _buildDatePickerField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          const SizedBox(height: 4),
          TextField(
            controller: controller,
            readOnly: true,
            onTap: () => _selectDate(context),
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
              suffixIcon: const Icon(Icons.calendar_today),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          TextField(
            controller: controller,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPasswordField(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label,
              style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                  color: Colors.grey)),
          TextField(
            controller: controller,
            obscureText: true,
            onChanged: (value) {
              setState(() {
                _passwordsMatch = _newPasswordController.text ==
                    _confirmNewPasswordController.text;
              });
            },
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
              contentPadding:
                  const EdgeInsets.symmetric(vertical: 10.0, horizontal: 12.0),
              errorText: (!_passwordsMatch &&
                      controller == _confirmNewPasswordController)
                  ? 'Les mots de passe ne correspondent pas'
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}
