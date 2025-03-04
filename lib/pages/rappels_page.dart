import 'package:flutter/material.dart';
import '../layout.dart';

class ReminderListPage extends StatefulWidget {
  const ReminderListPage({super.key});

  @override
  _ReminderListPageState createState() => _ReminderListPageState();
}

class _ReminderListPageState extends State<ReminderListPage> {
  final List<Map<String, String>> _reminders = [
    {'name': 'Paracétamol', 'time': '8h'},
    {'name': 'Ibuprofène', 'time': '14h'},
  ];

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      child: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _reminders.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(
                      '${_reminders[index]['name']} - ${_reminders[index]['time']}'),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () => _showEditDialog(index),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete, color: Colors.red),
                        onPressed: () => _deleteReminder(index),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: ElevatedButton(
              onPressed: _showAddReminderBottomSheet,
              child: const Text('Ajouter un rappel'),
            ),
          ),
        ],
      ),
    );
  }

  void _showAddReminderBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.only(
              top: 30.0, bottom: 50.0, right: 10.0, left: 10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom du médicament',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Heure du rappel',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  ElevatedButton(
                    onPressed: _addReminder,
                    child: const Text('Ajouter'),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    child: const Text('Annuler'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.grey,
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  void _addReminder() {
    if (_nameController.text.isNotEmpty && _timeController.text.isNotEmpty) {
      setState(() {
        _reminders.add({
          'name': _nameController.text,
          'time': _timeController.text,
        });
      });
      _nameController.clear();
      _timeController.clear();
      Navigator.of(context).pop();
    }
  }

  void _showEditDialog(int index) {
    _nameController.text = _reminders[index]['name']!;
    _timeController.text = _reminders[index]['time']!;

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Modifier le rappel'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: _nameController,
                decoration: const InputDecoration(
                  labelText: 'Nom du médicament',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: _timeController,
                decoration: const InputDecoration(
                  labelText: 'Heure du rappel',
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                setState(() {
                  _reminders[index] = {
                    'name': _nameController.text,
                    'time': _timeController.text,
                  };
                });
                Navigator.of(context).pop();
              },
              child: const Text('Enregistrer'),
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

  void _deleteReminder(int index) {
    setState(() {
      _reminders.removeAt(index);
    });
  }
}
