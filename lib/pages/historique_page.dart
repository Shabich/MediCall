import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class HistoriqueListPage extends StatefulWidget {
  const HistoriqueListPage({super.key});

  @override
  _HistoriqueListPageState createState() => _HistoriqueListPageState();
}

class _HistoriqueListPageState extends State<HistoriqueListPage> {
  List<dynamic> _historique = [];
  bool _isLoading = true;
  String _error = '';

  @override
  void initState() {
    super.initState();
    _fetchHistorique();
  }

  Future<void> _fetchHistorique() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/api/produits'));
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
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _historique.isEmpty
                      ? Center(child: Text("Pas d'historique trouvé"))
                      : ListView.builder(
                          itemCount: _historique.length,
                          itemBuilder: (context, index) {
                            final historique = _historique[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              child: ListTile(
                                title: Text(
                                  historique['nom_produit'] ?? 'Nom inconnu',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        historique['description'] ??
                                            'Description non disponible',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                    Text(
                                        'Date: ${historique['date_prise'] ?? 'Non spécifié'}',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                    Text(
                                        'Dose: ${historique['dose'] ?? 'Non spécifié'}',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                    Text(
                                        'Statut: ${historique['statut'] ?? 'Non spécifié'}',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                ),
    );
  }
}
