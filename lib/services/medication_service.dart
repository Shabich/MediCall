import '../models/medication.dart';

class MedicationService {
  final List<Medication> _medications = [];

  void addMedication(Medication medication) {
    _medications.add(medication);
  }

  List<Medication> getMedications() {
    return _medications;
  }
}
