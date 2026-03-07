import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/shared/Custom_Date_Textformfield.dart';
import 'package:flutter/material.dart';

class ScheduleFollowupBottomSheet extends StatefulWidget {
  final String patientName;
  final String diagnosis;

  const ScheduleFollowupBottomSheet({
    super.key,
    required this.patientName,
    required this.diagnosis,
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

  @override
  void dispose() {
    _dateController.dispose();
    _timeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
                    color: AppColors.Black,
                  ),
                ),
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Icon(Icons.close, color: AppColors.Gray, size: 22),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text(
              'Schedule next appointment for ${widget.patientName}',
              style: TextStyle(fontSize: 13, color: AppColors.Gray),
            ),
            const SizedBox(height: 16),

            // Appointment Date
            Text(
              'Appointment Date',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: AppColors.Black,
              ),
            ),
            const SizedBox(height: 6),
            CustomDateTextformfield(
              controller: _dateController,
              hint: 'dd/mm/yy',
              validatorText: 'Please select appointment date',
            ),
            const SizedBox(height: 14),

            // Appointment Time
            Text(
              'Appointment Time',
              style: TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w500,
                color: AppColors.Black,
              ),
            ),
            const SizedBox(height: 6),
            TextFormField(
              controller: _timeController,
              readOnly: true,
              validator: (v) =>
                  (v == null || v.isEmpty) ? 'Please select time' : null,
              style: TextStyle(fontSize: 14, color: AppColors.Black),
              decoration: InputDecoration(
                hintText: '--:--:--',
                hintStyle: TextStyle(fontSize: 14, color: AppColors.Gray),
                filled: true,
                fillColor: Colors.white,
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
                    _timeController.text = picked.format(context);
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
                          color: AppColors.Black,
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
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // TODO: send to bloc
                          Navigator.pop(context);
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