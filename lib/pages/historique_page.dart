import 'package:flutter/material.dart';
import 'package:medicall/utils/reminder_storage.dart';
import '../components/reminder_dialog.dart'; // Importez ReminderDialog ici
import '../models/reminder.dart'; // Assurez-vous que le modèle Reminder est également importé

import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class HistoriqueListPage extends StatefulWidget {
  const HistoriqueListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _HistoriqueListPageState createState() => _HistoriqueListPageState();
}

class _HistoriqueListPageState extends State<HistoriqueListPage> {
  final TextEditingController _idUserController = TextEditingController();

  List<dynamic> _historique = [];
  bool _isLoading = true;
  String _error = '';
  int _idUser = 0;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  // Fonction pour charger les données depuis SharedPreferences
  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _idUser = prefs.getInt('id_t_user') ??
          0; // Récupération en tant qu'entier avec valeur par défaut 0
      _idUserController.text = _idUser
          .toString(); // Convertir l'entier en String pour le champ texte
    });
    _fetchHistorique();
  }

  Future<void> _fetchHistorique() async {
    try {
      final response = await http.get(Uri.parse(
          'http://localhost:3000/api/commande/$_idUser')); // Utilisation de l'ID utilisateur dans l'URL
      if (response.statusCode == 200) {
        setState(() {
          _historique = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        setState(() {
          _error = 'Erreur: ${response.statusCode}';
          _isLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Échec de la connexion au serveur';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historique des Commandes"),
        centerTitle: false,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        automaticallyImplyLeading:
            false, // Empêche l'affichage de la flèche de retour
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: _historique.isEmpty
                      ? Center(child: const Text("Pas d'historique trouvé"))
                      : ListView.builder(
                          itemCount: _historique.length,
                          itemBuilder: (context, index) {
                            final historique = _historique[index];
                            return GestureDetector(
                              onTap: () {
                                _showProductsDialog(historique['produits']);
                              },
                              child: Card(
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16.0),
                                ),
                                elevation: 5,
                                // color: Colors.white,
                                margin: const EdgeInsets.symmetric(
                                    vertical: 8.0, horizontal: 12.0),
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16.0, vertical: 12.0),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            'Commande du ${historique['date_commande']?.substring(0, 10) ?? 'Date inconnue'}',
                                            style: const TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 8.0),
                                          Text(
                                            'Total: ${historique['total'] ?? 'Non spécifié'}€',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                          Text(
                                            'Statut: ${historique['statut'] ?? 'Non spécifié'}',
                                            style: const TextStyle(
                                                fontSize: 14,
                                                color: Colors.grey),
                                          ),
                                        ],
                                      ),
                                      const Icon(
                                        Icons.arrow_forward_ios,
                                        size: 20,
                                        color: Colors.grey,
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                ),
    );
  }

  // Fonction pour afficher un dialogue avec la liste des produits
  void _showProductsDialog(List<dynamic> produits) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Produits de la commande'),
          content: SizedBox(
            width: double.maxFinite,
            height: 250,
            child: ListView.builder(
              itemCount: produits.length,
              itemBuilder: (context, index) {
                final produit = produits[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: Stack(
                    children: [
                      ListTile(
                        leading: ClipRRect(
                          borderRadius: BorderRadius.circular(8.0),
                          child: produit['image_url'] != null
                              ? Image.network(produit['image_url'],
                                  width: 50, height: 50, fit: BoxFit.cover)
                              : const Icon(Icons.image, size: 50),
                        ),
                        title: Text(produit['nom_produit'] ?? 'Nom inconnu'),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Quantité: ${produit['quantite']}'),
                            Text(
                                'Prix: \$${produit['prix']?.toStringAsFixed(2) ?? 'Non spécifié'}'),
                            Text(
                                'Laboratoire: ${produit['laboratoire_fabriquant'] ?? 'Inconnu'}'),
                          ],
                        ),
                      ),
                      Positioned(
                        top: 1,
                        right: 0,
                        child: IconButton(
                          onPressed: () {
                            // Action pour ajouter un rappel
                            _addReminder(produit);
                          },
                          icon: const Icon(
                            Icons.notifications,
                            color: Color(0xFF4F4CD2), // Couleur de l'icône
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text('Fermer'),
            ),
          ],
        );
      },
    );
  }

  void _addReminder(dynamic produit) {
    print("Dialog d'ajout de rappel lancé");

    // Passe le nom du produit à ReminderDialog, ou une chaîne vide si le nom n'est pas disponible
    String produitName = produit['nom_produit'] ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return ReminderDialog(
          initialReminder: null,
          onSave: (reminder) async {
            // Ajouter le nouveau rappel à la liste existante
            List<Reminder> existingReminders =
                await ReminderStorage.loadReminders();
            existingReminders.add(reminder);

            // Sauvegarder la liste mise à jour dans SharedPreferences
            await ReminderStorage.saveReminders(existingReminders);

            // Afficher un message de confirmation
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('Rappel ajouté pour ${produit['nom_produit']}!'),
              ),
            );

            // Fermer le dialog après avoir ajouté le rappel
            Navigator.of(context).pop();
          },
          produitName: produitName, // Ajoute le nom du produit ici
        );
      },
    );
  }

  //
}
