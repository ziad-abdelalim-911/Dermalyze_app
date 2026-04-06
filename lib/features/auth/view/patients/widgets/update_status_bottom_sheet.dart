import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:flutter/material.dart';

enum PatientStatus { improving, stable, critical }

class UpdateStatusBottomSheet extends StatefulWidget {
  final String patientName;

  const UpdateStatusBottomSheet({
    super.key,
    required this.patientName,
  });

  @override
  State<UpdateStatusBottomSheet> createState() =>
      _UpdateStatusBottomSheetState();
}

class _UpdateStatusBottomSheetState extends State<UpdateStatusBottomSheet> {
  PatientStatus? _selectedStatus;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Update Patient Status',
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
            'Change the medical status for ${widget.patientName}',
            style: TextStyle(fontSize: 13, color: AppColors.Gray),
          ),
          const SizedBox(height: 16),

          // Improving
          _buildStatusOption(
            status: PatientStatus.improving,
            title: 'Improving',
            subtitle: 'Patient showing positive progress',
          ),
          const SizedBox(height: 10),

          // Stable
          _buildStatusOption(
            status: PatientStatus.stable,
            title: 'Stable',
            subtitle: 'Condition is consistent',
          ),
          const SizedBox(height: 10),

          // Critical
          _buildStatusOption(
            status: PatientStatus.critical,
            title: 'Critical',
            subtitle: 'Requires immediate attention',
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
                  child: ElevatedButton(
                    onPressed: _selectedStatus == null
                        ? null
                        : () {
                            // TODO: send status to bloc
                            Navigator.pop(context, _selectedStatus);
                          },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.SkyBlue,
                      disabledBackgroundColor: AppColors.Gray2,
                      elevation: 0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Update Status',
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
    );
  }

  Widget _buildStatusOption({
    required PatientStatus status,
    required String title,
    required String subtitle,
  }) {
    final isSelected = _selectedStatus == status;

    Color borderColor;
    Color bgColor;
    Color radioColor;

    if (!isSelected) {
      borderColor = AppColors.Gray2;
      bgColor = Colors.white;
      radioColor = AppColors.Gray2;
    } else if (status == PatientStatus.critical) {
      borderColor = Colors.red;
      bgColor = Colors.red.withOpacity(0.05);
      radioColor = Colors.red;
    } else {
      borderColor = AppColors.Turqouoise;
      bgColor = AppColors.Turqouoise.withOpacity(0.05);
      radioColor = AppColors.SkyBlue;
    }

    return GestureDetector(
      onTap: () => setState(() => _selectedStatus = status),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: bgColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: borderColor, width: 1.5),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.Black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: AppColors.Gray),
                  ),
                ],
              ),
            ),
            Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color: radioColor, width: 2),
              ),
              child: isSelected
                  ? Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: radioColor,
                        ),
                      ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}