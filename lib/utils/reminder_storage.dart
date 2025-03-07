import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/reminder.dart';

class ReminderStorage {
  static const String _reminderKey = 'reminders';

  // Sauvegarder la liste des rappels dans SharedPreferences
  static Future<void> saveReminders(List<Reminder> reminders) async {
    final prefs = await SharedPreferences.getInstance();
    final List<String> remindersJson = reminders.map((reminder) {
      return json.encode({
        'name': reminder.name,
        'time': reminder.time,
        'recurrence': reminder.recurrence,
      });
    }).toList();
    await prefs.setStringList(_reminderKey, remindersJson);
  }

  // Charger les rappels depuis SharedPreferences
  static Future<List<Reminder>> loadReminders() async {
    final prefs = await SharedPreferences.getInstance();
    final List<String>? remindersJson = prefs.getStringList(_reminderKey);

    if (remindersJson == null) {
      return [];
    }

    return remindersJson.map((reminderJson) {
      final data = json.decode(reminderJson);
      return Reminder(
        name: data['name'],
        time: data['time'],
        recurrence: data['recurrence'],
      );
    }).toList();
  }
}
