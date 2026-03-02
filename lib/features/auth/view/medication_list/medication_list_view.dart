import 'package:dermalyze/features/auth/view/medication_list/medication_model.dart';
import 'package:dermalyze/features/auth/view/medication_list/widgets/medication_reminders_card.dart';
import 'package:flutter/material.dart';

import 'widgets/medication_card.dart';

class MedicationListView extends StatefulWidget {
  const MedicationListView({super.key});

  @override
  State<MedicationListView> createState() => _MedicationListViewState();
}

class _MedicationListViewState extends State<MedicationListView> {
  @override
  Widget build(BuildContext context) {
    final activeMedications = [
      MedicationModel(
        name: "Hydrocortisone Cream 1%",
        dose: "Apply thin layer",
        frequency: "Twice daily",
        duration: "14 days",
        whenToTake: "Morning & Evening",
        warning:
            "Apply to affected areas after cleansing. Avoid face and open wounds.",
        startDate: "Jan 10, 2026",
        endDate: "Jan 24, 2026",
        isCompleted: false,
      ),

      MedicationModel(
        name: "Cetirizine 10mg",
        dose: "1 tablet",
        frequency: "Once daily",
        duration: "30 days",
        whenToTake: "Before bedtime",
        warning: "Take with water. May cause drowsiness.",
        startDate: "Jan 10, 2026",
        endDate: "Feb 9, 2026",
        isCompleted: false,
      ),
    ];

    final completedMedications = [
      MedicationModel(
        name: "Prednisone 5mg",
        dose: "2 tablets",
        frequency: "",
        duration: "",
        whenToTake: "",
        warning: "",
        startDate: "",
        endDate: "",
        isCompleted: true,
      ),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF3F6F6),

      body: ListView(
        children: [
          const SizedBox(height: 16),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Active Medications",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),

          ...activeMedications.map((e) => MedicationCard(medication: e)),

          const SizedBox(height: 16),

          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Completed",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),

          ...completedMedications.map((e) => MedicationCard(medication: e)),

          const ImportantRemindersCard(),
        ],
      ),
    );
  }
}
