import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class MedicamentListPage extends StatefulWidget {
  const MedicamentListPage({super.key});

  @override
  _MedicamentListPageState createState() => _MedicamentListPageState();
}

class _MedicamentListPageState extends State<MedicamentListPage> {
  List<dynamic> _medicaments = [];
  List<dynamic> _categories = [];
  bool _isLoading = true;
  bool _isCategoriesLoading = true;
  String _error = '';
  String? _selectedCategory;

  @override
  void initState() {
    super.initState();
    _fetchMedicaments();
    _fetchCategories();
  }

  Future<void> _fetchMedicaments() async {
    try {
      final response =
          await http.get(Uri.parse('http://localhost:3000/api/produits'));
      if (response.statusCode == 200) {
        setState(() {
          _medicaments = json.decode(response.body);
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

  Future<void> _fetchCategories() async {
    try {
      final response = await http
          .get(Uri.parse('http://localhost:3000/api/produits/categorie'));
      if (response.statusCode == 200) {
        setState(() {
          _categories = json.decode(response.body);
          _isCategoriesLoading = false;
        });
      } else {
        setState(() {
          _error = 'Erreur: ${response.statusCode}';
          _isCategoriesLoading = false;
        });
      }
    } catch (e) {
      setState(() {
        _error = 'Échec de la connexion au serveur';
        _isCategoriesLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Historique d'achat"),
        centerTitle: false, // Désactive le centrage automatique du titre
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _error.isNotEmpty
              ? Center(child: Text(_error))
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // DropdownButton pour sélectionner une catégorie
                      _isCategoriesLoading
                          ? const Center(child: CircularProgressIndicator())
                          : DropdownButton<String>(
                              value: _selectedCategory,
                              hint: const Text('Choisir une catégorie'),
                              icon: const Icon(Icons.filter_list),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedCategory = newValue;
                                });
                              },
                              items: _categories
                                  .map<DropdownMenuItem<String>>((category) {
                                return DropdownMenuItem<String>(
                                  value: category['id_t_categorie'].toString(),
                                  child: Text(category['lib_court']),
                                );
                              }).toList(),
                            ),
                      const SizedBox(height: 10),
                      // Liste des médicaments
                      Expanded(
                        child: ListView.builder(
                          itemCount: _medicaments.length,
                          itemBuilder: (context, index) {
                            final medicament = _medicaments[index];
                            return Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12.0),
                              ),
                              elevation: 4,
                              margin: const EdgeInsets.symmetric(
                                  vertical: 8.0, horizontal: 12.0),
                              child: ListTile(
                                leading: SizedBox(
                                  width: 50,
                                  height: 50,
                                  child: ClipRRect(
                                    borderRadius: BorderRadius.circular(8.0),
                                    child: Image.network(
                                      medicament['image_url'] ?? '',
                                      fit: BoxFit.cover,
                                      errorBuilder: (context, error,
                                              stackTrace) =>
                                          const Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                ),
                                title: Text(
                                  medicament['nom_produit'] ?? 'Nom inconnu',
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                                subtitle: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        medicament['description'] ??
                                            'Description non disponible',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                    Text(
                                        'Forme: ${medicament['forme'] ?? 'Inconnue'}',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                    Text(
                                        'Dosage: ${medicament['dosage'] ?? 'Non spécifié'}',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                    Text(
                                        'Laboratoire: ${medicament['laboratoire_fabriquant'] ?? 'Non spécifié'}',
                                        style: const TextStyle(
                                            fontSize: 12, color: Colors.grey)),
                                  ],
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
    );
  }
}
