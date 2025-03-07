import 'package:flutter/material.dart';
import '../models/reminder.dart';

class ReminderDialog extends StatefulWidget {
  final Reminder? initialReminder;
  final void Function(Reminder) onSave;
  final String produitName;
  const ReminderDialog({
    super.key,
    this.initialReminder,
    required this.onSave,
    required this.produitName, // Ajoute le nom du produit ici
  });

  @override
  _ReminderDialogState createState() => _ReminderDialogState();
}

class _ReminderDialogState extends State<ReminderDialog> {
  final TextEditingController _nameController = TextEditingController();
  TimeOfDay? _selectedTime;
  String _selectedRecurrence = "Tous les jours";

  @override
  void initState() {
    super.initState();
    if (widget.initialReminder != null) {
      _nameController.text = widget.initialReminder!.name;
      _selectedTime = _parseTime(widget.initialReminder!.time);
      _selectedRecurrence = widget.initialReminder!.recurrence;
    } else {
      // Si aucun rappel initial n'est fourni, utilise le nom du produit
      _nameController.text = widget.produitName;
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.initialReminder == null
          ? 'Ajouter un rappel'
          : 'Modifier le rappel'),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(
              labelText: 'Nom du médicament',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          const SizedBox(height: 10),
          DropdownButtonFormField<String>(
            value: _selectedRecurrence,
            onChanged: (String? newValue) {
              setState(() {
                _selectedRecurrence = newValue!;
              });
            },
            items: [
              "Tous les jours",
              "Tous les 2 jours",
              "Toutes les semaines",
              "Tous les mois",
            ]
                .map((String recurrence) => DropdownMenuItem(
                    value: recurrence, child: Text(recurrence)))
                .toList(),
            decoration: InputDecoration(
              labelText: 'Récurrence',
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(20)),
            ),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: _selectTime,
            child: Text(_selectedTime == null
                ? 'Choisir une heure'
                : _selectedTime!.format(context)),
          ),
        ],
      ),
      actions: [
        TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Annuler')),
        TextButton(
          onPressed: _saveReminder,
          child: Text(widget.initialReminder == null ? 'Ajouter' : 'Modifier'),
        ),
      ],
    );
  }

  Future<void> _selectTime() async {
    TimeOfDay? pickedTime = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (pickedTime != null) {
      setState(() {
        _selectedTime = pickedTime;
      });
    }
  }

  void _saveReminder() {
    if (_nameController.text.isNotEmpty && _selectedTime != null) {
      widget.onSave(Reminder(
        name: _nameController.text,
        time: _selectedTime!.format(context),
        recurrence: _selectedRecurrence,
      ));
      Navigator.of(context).pop();
    }
  }

  TimeOfDay _parseTime(String time) {
    final parts = time.split(":");
    int hour = int.parse(parts[0]);
    int minute = int.parse(parts[1].split(" ")[0]);
    bool isPM = time.contains("PM");

    if (isPM && hour < 12) hour += 12;
    if (!isPM && hour == 12) hour = 0;

    return TimeOfDay(hour: hour, minute: minute);
  }
}
