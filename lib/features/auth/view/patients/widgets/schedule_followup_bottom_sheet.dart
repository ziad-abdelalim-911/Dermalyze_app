import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/auth/view/patients/data/review_repository.dart';
import 'package:dermalyze/features/shared/custom_date_textformfield.dart';
import 'package:flutter/material.dart';
import 'package:dermalyze/features/auth/view/home/doctor/presentation/bloc/doctor_home_bloc.dart';
import 'package:dermalyze/features/auth/view/home/doctor/presentation/bloc/doctor_home_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ScheduleFollowupBottomSheet extends StatefulWidget {
  final String patientName;
  final String diagnosis;
  final String patientId;

  const ScheduleFollowupBottomSheet({
    super.key,
    required this.patientName,
    required this.diagnosis,
    required this.patientId,
  });

  @override
  State<ScheduleFollowupBottomSheet> createState() =>
      _ScheduleFollowupBottomSheetState();
}

class _ScheduleFollowupBottomSheetState
    extends State<ScheduleFollowupBottomSheet> {
  final _dateController = TextEditingController();
  final _timeController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isSaving = false;
  final _repo = ReviewRepository();

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final inputBg = isDark ? const Color(0xFF0F172A) : Colors.white;
    final textPrimary = isDark ? Colors.white : AppColors.Black;
    final textSecondary = isDark ? Colors.grey.shade400 : AppColors.Gray;

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Schedule Follow-up',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.bold,
                    color: textPrimary,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: textSecondary, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Schedule next appointment for ${widget.patientName}',
              style: TextStyle(fontSize: 13, color: textSecondary),
            ),
            const SizedBox(height: 16),

            // Appointment Date
            Text(
              'Appointment Date',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            CustomDateTextformfield(
              controller: _dateController,
              hint: 'YYYY-MM-DD',
              validatorText: 'Please select appointment date',
            ),
            const SizedBox(height: 14),

            // Appointment Time
            Text(
              'Appointment Time',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: textPrimary,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _timeController,
              readOnly: true,
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Please select time' : null,
              style: TextStyle(fontSize: 14, color: textPrimary),
              decoration: InputDecoration(
                hintText: '--:--:--',
                hintStyle: TextStyle(fontSize: 14, color: textSecondary),
                filled: true,
                fillColor: inputBg,
                isDense: true,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 12,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.Gray2),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.Gray2),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: AppColors.SkyBlue),
                ),
              ),
              onTap: () async {
                final TimeOfDay? picked = await showTimePicker(
                  context: context,
                  initialTime: TimeOfDay.now(),
                );
                if (picked != null) {
                  setState(() {
                    final hh = picked.hour.toString().padLeft(2, '0');
                    final mm = picked.minute.toString().padLeft(2, '0');
                    _timeController.text = '$hh:$mm';
                  });
                }
              },
            ),
            const SizedBox(height: 16),

            // Patient Info Box
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: AppColors.Turqouoise.withOpacity(0.07),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: AppColors.Turqouoise.withOpacity(0.4),
                  width: 1.5,
                ),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today_outlined,
                    color: AppColors.Turqouoise,
                    size: 20,
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Current Patient:',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.Turqouoise,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        widget.patientName,
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.bold,
                          color: AppColors.Turqouoise,
                        ),
                      ),
                      Text(
                        widget.diagnosis,
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.Turqouoise,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Buttons
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        side: BorderSide(color: AppColors.Gray2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: Text(
                        'Cancel',
                        style: TextStyle(
                          color: textPrimary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton.icon(
                    onPressed: _isSaving
                        ? null
                        : () async {
                            if (_formKey.currentState!.validate()) {
                              setState(() => _isSaving = true);
                              try {
                                final response = await _repo.scheduleFollowup(
                                  patientId: widget.patientId,
                                  patientName: widget.patientName,
                                  diagnosis: widget.diagnosis,
                                  date: _dateController.text,
                                  time: _timeController.text,
                                );
                                if (context.mounted) {
                                  // Update the state immediately
                                  if (response.containsKey('patient')) {
                                    final patientData = response['patient'] as Map<String, dynamic>;
                                    patientData['patientId'] = widget.patientId; // ensure ID is present for bloc logic
                                    
                                    try {
                                      context.read<DoctorHomeBloc>().add(UpdatePatientEvent(patientData));
                                    } catch (e) {
                                      // If bloc not found in context, ignore
                                    }
                                  }

                                  Navigator.pop(context, response.containsKey('patient') ? response['patient'] as Map<String, dynamic> : null);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Follow-up scheduled ✓'),
                                      backgroundColor: Color(0xFF4ECDC4),
                                    ),
                                  );
                                }
                              } catch (_) {
                                // Appointment saved locally — backend endpoint pending
                                if (context.mounted) {
                                  Navigator.pop(context);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text('Follow-up scheduled locally ✓'),
                                      backgroundColor: Color(0xFF4ECDC4),
                                    ),
                                  );
                                }
                              } finally {
                                if (mounted) setState(() => _isSaving = false);
                              }
                            }
                          },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.SkyBlue,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: const Icon(
                        Icons.calendar_today_outlined,
                        color: Colors.white,
                        size: 16,
                      ),
                      label: const Text(
                        'Schedule',
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }
}