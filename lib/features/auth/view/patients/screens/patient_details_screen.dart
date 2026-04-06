import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/doctors_review_card.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/followup_image_card.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/patient_info_card.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/prescribed_medications_card.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/progress_timeline_card.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/schedule_followup_bottom_sheet.dart';
import 'package:dermalyze/features/auth/view/patients/widgets/update_status_bottom_sheet.dart';
import 'package:flutter/material.dart';

class PatientDetailsScreen extends StatefulWidget {
  const PatientDetailsScreen({super.key});

  @override
  State<PatientDetailsScreen> createState() => _PatientDetailsScreenState();
}

class _PatientDetailsScreenState extends State<PatientDetailsScreen> {
  final _reviewController = TextEditingController();

  final _timelineItems = const [
    TimelineItem(label: 'Initial', badge: 'Low', date: 'Dec 01, 2024'),
    TimelineItem(
      label: 'Week 2',
      badge: 'Medium',
      date: 'Dec 15, 2024',
      improvement: '+13% improvement',
    ),
    TimelineItem(
      label: 'Current',
      badge: 'Medium',
      date: 'Dec 29, 2024',
      improvement: '+20% improvement',
    ),
  ];

  final _medications = const [
    MedicationItem(
      name: 'Hydrocortisone Cream 1%',
      dosage: 'Apply twice daily',
      schedule: 'Morning & Evening',
    ),
    MedicationItem(
      name: 'Cetirizine 10mg',
      dosage: '1 tablet',
      schedule: 'Once daily at bedtime',
    ),
  ];

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 100),
        child: Column(
          children: [
            FollowupImageCard(
              onTap: () => Navigator.pushNamed(context, AppRoutes.uploadAnalyze),
            ),
            const SizedBox(height: 16),
            PatientInfoCard(
              name: 'Shawkat',
              diagnosis: 'Atopic Dermatitis',
              quality: 'Medium',
              lastVisit: '2 days ago',
              recoveryRate: '68%',
            ),
            const SizedBox(height: 16),
            ProgressTimelineCard(items: _timelineItems),
            const SizedBox(height: 16),
            DoctorsReviewCard(
              reviewController: _reviewController,
              onSave: () {
                // TODO: save review logic
              },
            ),
            const SizedBox(height: 16),
            PrescribedMedicationsCard(
              medications: _medications,
              onAddMedication: () {
                // TODO: navigate to add medication
              },
            ),
          ],
        ),
      ),
      bottomNavigationBar: _buildBottomButtons(context),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.White,
      elevation: 0,
      leading: IconButton(
        icon: Icon(Icons.arrow_back, color: AppColors.Black),
        onPressed: () => Navigator.pop(context),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Patient Details',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: AppColors.Black,
            ),
          ),
          Text(
            'Review and manage case',
            style: TextStyle(fontSize: 12, color: AppColors.Gray),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomButtons(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
      decoration: BoxDecoration(
        color: AppColors.White,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, -3),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: SizedBox(
              height: 48,
              child: OutlinedButton(
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (_) => Padding(
                      padding: EdgeInsets.only(
                        bottom: MediaQuery.of(context).viewInsets.bottom,
                      ),
                      child: const ScheduleFollowupBottomSheet(
                        patientName: 'Shawkat',
                        diagnosis: 'Atopic Dermatitis',
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: AppColors.Turqouoise, width: 1.5),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  'Schedule Follow-up',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: AppColors.Turqouoise,
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
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    isScrollControlled: true,
                    shape: const RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.vertical(top: Radius.circular(24)),
                    ),
                    builder: (_) => const UpdateStatusBottomSheet(
                      patientName: 'Shawkat',
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.SkyBlue,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Update Status',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}