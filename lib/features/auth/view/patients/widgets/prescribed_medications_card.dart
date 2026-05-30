import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

class MedicationItem {
  final String id;
  final String name;
  final String dosage;
  final String schedule;
  final String? notes;

  const MedicationItem({
    required this.id,
    required this.name,
    required this.dosage,
    required this.schedule,
    this.notes,
  });
}

class PrescribedMedicationsCard extends StatelessWidget {
  final List<MedicationItem> medications;
  final VoidCallback onAddMedication;
  final Function(MedicationItem) onEditMedication;
  final Function(MedicationItem) onDeleteMedication;

  const PrescribedMedicationsCard({
    super.key,
    required this.medications,
    required this.onAddMedication,
    required this.onEditMedication,
    required this.onDeleteMedication,
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
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(Icons.edit_outlined, color: AppColors.Gray3, size: 18),
                  const SizedBox(width: 8),
                  Text(
                    'Prescribed\nMedications',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: Theme.of(context).colorScheme.onSurface,
                      height: 1.4,
                    ),
                  ),
                ],
              ),
              // Add Medication Button
              SizedBox(
                height: 40,
                child: ElevatedButton.icon(
                  onPressed: onAddMedication,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.SkyBlue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    elevation: 0,
                  ),
                  icon: Icon(Icons.add, color: Theme.of(context).cardColor, size: 16),
                  label: const Text(
                    'Add\nMedication',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      height: 1.4,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          // Medications List
          ...medications.map((med) => _buildMedicationItem(context, med)),
        ],
      ),
    );
  }

  Widget _buildMedicationItem(BuildContext context, MedicationItem med) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  med.name,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Theme.of(context).colorScheme.onSurface,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  med.dosage,
                  style: TextStyle(fontSize: 13, color: AppColors.Gray),
                ),
                const SizedBox(height: 5),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.SkyBlue.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    med.schedule,
                    style: TextStyle(
                      fontSize: 12,
                      color: AppColors.SkyBlue,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.edit_outlined, color: AppColors.Gray3, size: 20),
            onPressed: () => onEditMedication(med),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
          const SizedBox(width: 16),
          IconButton(
            icon: Icon(Icons.delete_outline, color: Colors.red.shade300, size: 20),
            onPressed: () => onDeleteMedication(med),
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(),
          ),
        ],
      ),
    );
  }
}
