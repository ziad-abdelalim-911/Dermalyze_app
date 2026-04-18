import 'package:flutter/material.dart';
import 'patient_form_field.dart';

class MedicalInfoCard extends StatelessWidget {
  final TextEditingController diagnosisController;
  final TextEditingController medicalHistoryController;

  const MedicalInfoCard({
    super.key,
    required this.diagnosisController,
    required this.medicalHistoryController,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.blueGrey.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.assignment_outlined, color: Color(0xFF3AABB0), size: 20),
              const SizedBox(width: 8),
              Text(
                'Medical Information',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Theme.of(context).brightness == Brightness.dark 
                      ? Colors.white 
                      : const Color(0xFF1A2E3B),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          PatientFormField(
            controller: diagnosisController,
            label: 'Initial Diagnosis',
            hint: 'e.g., Atopic Dermatitis',
          ),
          const SizedBox(height: 14),
          PatientFormField(
            controller: medicalHistoryController,
            label: 'Medical History',
            hint: 'Previous conditions, allergies, medications...',
            required: false,
            maxLines: 4,
          ),
        ],
      ),
    );
  }
}
