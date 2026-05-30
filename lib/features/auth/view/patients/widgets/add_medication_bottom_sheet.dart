import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/auth/view/medication_list/medication_repository.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/patient_form_field.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/prescribed_medications_card.dart';
import 'package:flutter/material.dart';

class AddMedicationBottomSheet extends StatefulWidget {
  final String patientId;
  final MedicationItem? initialMedication;

  const AddMedicationBottomSheet({
    super.key,
    required this.patientId,
    this.initialMedication,
  });

  @override
  State<AddMedicationBottomSheet> createState() => _AddMedicationBottomSheetState();
}

class _AddMedicationBottomSheetState extends State<AddMedicationBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _dosageController = TextEditingController();
  final _frequencyController = TextEditingController();
  final _notesController = TextEditingController();

  final _repo = MedicationRepository();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.initialMedication != null) {
      _nameController.text = widget.initialMedication!.name;
      _dosageController.text = widget.initialMedication!.dosage;
      _frequencyController.text = widget.initialMedication!.schedule;
      _notesController.text = widget.initialMedication!.notes ?? '';
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dosageController.dispose();
    _frequencyController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      if (widget.initialMedication != null) {
        await _repo.updateMedication(
          widget.initialMedication!.id,
          {
            'name': _nameController.text.trim(),
            'dosage': _dosageController.text.trim(),
            'frequency': _frequencyController.text.trim(),
            'notes': _notesController.text.trim(),
          },
        );
      } else {
        await _repo.addMedication(
          patientId: widget.patientId,
          name: _nameController.text.trim(),
          dosage: _dosageController.text.trim(),
          frequency: _frequencyController.text.trim(),
          notes: _notesController.text.trim(),
        );
      }

      // If it doesn't throw, it was successful.
      if (mounted) {
        Navigator.pop(context, true); // Return true to indicate success
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding medication: $e'),
            backgroundColor: Colors.red.shade400,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Handle indicator
              Center(
                child: Container(
                  width: 40,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.SkyBlue.withOpacity(0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.medication_outlined, color: AppColors.SkyBlue, size: 24),
                  ),
                  const SizedBox(width: 16),
                  Text(
                    widget.initialMedication != null ? 'Edit Medication' : 'Add Medication',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).colorScheme.onSurface,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              PatientFormField(
                controller: _nameController,
                label: 'Medication Name',
                hint: 'e.g. Hydrocortisone Cream',
                prefixIcon: Icons.medical_information_outlined,
              ),
              const SizedBox(height: 16),
              Row(
                children: [
                  Expanded(
                    child: PatientFormField(
                      controller: _dosageController,
                      label: 'Dosage',
                      hint: 'e.g. 1%',
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: PatientFormField(
                      controller: _frequencyController,
                      label: 'Frequency',
                      hint: 'e.g. Apply twice daily',
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              PatientFormField(
                controller: _notesController,
                label: 'Additional Notes',
                hint: 'e.g. Morning & Evening',
                required: false,
                maxLines: 3,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 54,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.SkyBlue,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : Text(
                          widget.initialMedication != null ? 'Save Changes' : 'Save Medication',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
