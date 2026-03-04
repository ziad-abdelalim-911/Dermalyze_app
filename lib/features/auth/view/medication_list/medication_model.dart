class MedicationModel {

  final String name;
  final String dose;
  final String frequency;
  final String duration;
  final String whenToTake;
  final String warning;
  final String startDate;
  final String endDate;
  final bool isCompleted;

  const MedicationModel({
    required this.name,
    required this.dose,
    required this.frequency,
    required this.duration,
    required this.whenToTake,
    required this.warning,
    required this.startDate,
    required this.endDate,
    required this.isCompleted,
  });

}
