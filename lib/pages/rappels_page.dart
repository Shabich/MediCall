// ignore_for_file: unnecessary_brace_in_string_interps

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ReminderListPage extends StatefulWidget {
  const ReminderListPage({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ReminderListPageState createState() => _ReminderListPageState();
}

class _ReminderListPageState extends State<ReminderListPage> {
  final List<Map<String, String>> _reminders = [];
  final TextEditingController _nameController = TextEditingController();
  TimeOfDay? _selectedTime;

  @override
  void initState() {
    super.initState();
    _loadReminders();
    debugPrint("Initialisation de la page des rappels");
  }

  Future<void> _loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    List<String>? remindersJson = prefs.getStringList('reminders');
    if (remindersJson != null) {
      setState(() {
        _reminders.clear();
        _reminders.addAll(remindersJson.map((r) {
          List<String> parts = r.split('|');
          return {'name': parts[0], 'time': parts[1]};
        }));
      });
    }
  }

  Future<void> _saveReminders() async {
    final prefs = await SharedPreferences.getInstance();
    List<String> remindersJson =
        _reminders.map((r) => '${r['name']}|${r['time']}').toList();
    await prefs.setStringList('reminders', remindersJson);
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("Construction de l'interface utilisateur");
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _reminders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      '${_reminders[index]['name']} - ${_reminders[index]['time']}'),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete, color: Colors.red),
                    onPressed: () => _deleteReminder(index),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _showAddReminderDialog,
              child: const Text('Ajouter un rappel'),
            ),
          ),
        ],
      ),
    );
  }

  // Affichage de la boîte de dialogue pour ajouter un rappel
  void _showAddReminderDialog() {
    debugPrint("Affichage du dialogue pour ajouter un rappel");
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Ajouter un rappel'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Nom du médicament',
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20)),
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: _selectTime,
                child: Text(
                  _selectedTime == null
                      ? 'Choisir une heure'
                      : _selectedTime!.format(context),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: _addReminder,
              child: const Text('Ajouter'),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Annuler'),
            ),
          ],
        );
      },
    );
  }

  // Sélection de l'heure pour le rappel
  Future<void> _selectTime() async {
    debugPrint("Ouverture du sélecteur d'heure");
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
      debugPrint("Heure sélectionnée: ${_selectedTime!.format(context)}");
    } else {
      debugPrint("Aucune heure sélectionnée");
    }
  }

  void _addReminder() {
    if (_nameController.text.isNotEmpty && _selectedTime != null) {
      String formattedTime = _selectedTime!.format(context);
      debugPrint("Ajout du rappel: ${_nameController.text} à ${formattedTime}");

      setState(() {
        _reminders.add({'name': _nameController.text, 'time': formattedTime});
      });
      _saveReminders();

      _nameController.clear();
      _selectedTime = null;
      Navigator.of(context).pop();
    } else {
      debugPrint("Nom ou heure manquants lors de l'ajout du rappel");
    }
  }

  // Suppression d'un rappel
  void _deleteReminder(int index) {
    debugPrint("Suppression du rappel à l'index: $index");
    setState(() {
      _reminders.removeAt(index);
    });
    _saveReminders();
  }
}
