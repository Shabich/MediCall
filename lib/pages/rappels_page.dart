import 'package:flutter/material.dart';
import '../models/reminder.dart';
import '../components/reminder_dialog.dart';
import '../utils/reminder_storage.dart';

class ReminderPage extends StatefulWidget {
  @override
  _ReminderPageState createState() => _ReminderPageState();
}

class _ReminderPageState extends State<ReminderPage> {
  List<Reminder> _reminders = [];

  @override
  void initState() {
    super.initState();
    _loadReminders();
  }

  // Charger les rappels depuis SharedPreferences
  Future<void> _loadReminders() async {
    List<Reminder> loadedReminders = await ReminderStorage.loadReminders();
    setState(() {
      _reminders = loadedReminders;
    });
  }

  void _addReminder() {
    showDialog(
      context: context,
      builder: (context) => ReminderDialog(
        onSave: (reminder) async {
          setState(() {
            _reminders.add(reminder);
          });
          // Sauvegarder la nouvelle liste de rappels dans SharedPreferences
          await ReminderStorage.saveReminders(_reminders);
        },
        produitName: '',
      ),
    );
  }

  void _editReminder(int index) {
    showDialog(
      context: context,
      builder: (context) => ReminderDialog(
        initialReminder: _reminders[index],
        onSave: (updatedReminder) async {
          setState(() {
            _reminders[index] = updatedReminder;
          });
          // Sauvegarder la liste mise à jour dans SharedPreferences
          await ReminderStorage.saveReminders(_reminders);
        },
        produitName: '',
      ),
    );
  }

  void _deleteReminder(int index) async {
    setState(() {
      _reminders.removeAt(index);
    });
    // Sauvegarder la liste mise à jour après suppression dans SharedPreferences
    await ReminderStorage.saveReminders(_reminders);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Rappels")),
      body: ListView.builder(
        itemCount: _reminders.length,
        itemBuilder: (context, index) {
          final reminder = _reminders[index];
          return ListTile(
            title: Text("${reminder.name} - ${reminder.time}"),
            subtitle: Text("Récurrence: ${reminder.recurrence}"),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: Icon(Icons.edit, color: Colors.blue),
                  onPressed: () => _editReminder(index),
                ),
                IconButton(
                  icon: Icon(Icons.delete, color: Colors.red),
                  onPressed: () => _deleteReminder(index),
                ),
              ],
            ),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addReminder,
        child: Icon(Icons.add),
      ),
    );
  }
}
