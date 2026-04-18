import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/features/auth/view/patients/data/review_repository.dart';
import 'package:flutter/material.dart';

enum PatientStatus { improving, stable, critical }

class UpdateStatusBottomSheet extends StatefulWidget {
  final String patientName;
  final String patientId;

  const UpdateStatusBottomSheet({
    super.key,
    required this.patientName,
    required this.patientId,
  });

  @override
  State<UpdateStatusBottomSheet> createState() =>
      _UpdateStatusBottomSheetState();
}

class _UpdateStatusBottomSheetState extends State<UpdateStatusBottomSheet> {
  PatientStatus? _selectedStatus;
  bool _isUpdating = false;
  final _repo = ReviewRepository();

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final bgColor = isDark ? const Color(0xFF1E293B) : Colors.white;
    final textPrimary = isDark ? Colors.white : AppColors.Black;
    final textSecondary = isDark ? Colors.grey.shade400 : AppColors.Gray;
    
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
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
            'Change the medical status for ${widget.patientName}',
            style: TextStyle(fontSize: 13, color: textSecondary),
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
                  child: ElevatedButton(
                    onPressed: _selectedStatus == null || _isUpdating
                        ? null
                        : () async {
                            setState(() => _isUpdating = true);
                            try {
                              await _repo.updatePatientStatus(
                                patientId: widget.patientId,
                                status: _selectedStatus!.name,
                              );
                              if (context.mounted) {
                                Navigator.pop(context, _selectedStatus);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Status updated to ${_selectedStatus!.name}'),
                                    backgroundColor: const Color(0xFF4ECDC4),
                                  ),
                                );
                              }
                            } catch (e) {
                              if (context.mounted) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text('Failed to update: ${e.toString()}'),
                                    backgroundColor: Colors.red.shade400,
                                  ),
                                );
                              }
                            } finally {
                              if (mounted) setState(() => _isUpdating = false);
                            }
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
    final isDark = Theme.of(context).brightness == Brightness.dark;

    Color borderColor;
    Color bgColor;
    Color radioColor;

    if (!isSelected) {
      borderColor = isDark ? Colors.white24 : AppColors.Gray2;
      bgColor = isDark ? const Color(0xFF0F172A) : Colors.white;
      radioColor = isDark ? Colors.white38 : AppColors.Gray2;
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
                      color: isDark ? Colors.white : AppColors.Black,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 12, color: isDark ? Colors.grey.shade400 : AppColors.Gray),
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