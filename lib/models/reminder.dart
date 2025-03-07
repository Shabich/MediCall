class Reminder {
  String name;
  String time;
  String recurrence;

  Reminder({required this.name, required this.time, required this.recurrence});

  String toStorageString() => '$name|$time|$recurrence';

  static Reminder fromStorageString(String storageString) {
    List<String> parts = storageString.split('|');
    return Reminder(name: parts[0], time: parts[1], recurrence: parts[2]);
  }
}
