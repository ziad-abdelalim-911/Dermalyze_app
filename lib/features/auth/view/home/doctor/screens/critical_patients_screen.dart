import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:dermalyze/features/auth/view/home/doctor/domain/entities/patient_entity.dart';
import 'package:dermalyze/features/auth/view/home/doctor/presentation/bloc/doctor_home_bloc.dart';
import 'package:dermalyze/features/auth/view/home/doctor/presentation/bloc/doctor_home_event.dart';
import 'package:dermalyze/features/auth/view/home/doctor/presentation/bloc/doctor_home_state.dart';
import 'package:dermalyze/features/auth/view/home/doctor/widgets/critical_care_guidelines_card.dart';
import 'package:dermalyze/features/auth/view/home/doctor/widgets/critical_patient_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:url_launcher/url_launcher.dart';


class CriticalPatientsScreen extends StatelessWidget {
  const CriticalPatientsScreen({super.key});

  static Future<void> _launchCall(String phone) async {
    final uri = Uri(scheme: 'tel', path: phone);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorHomeBloc, DoctorHomeState>(
      builder: (context, state) {
        // طلب البيانات لو لسه مش loaded
        if (state is DoctorHomeInitial) {
          context.read<DoctorHomeBloc>().add(LoadDoctorHomeEvent());
        }

        final criticalPatients = state is DoctorHomeLoaded
            ? state.criticalPatients
            : <PatientEntity>[];

        final isDark = Theme.of(context).brightness == Brightness.dark;

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).scaffoldBackgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: const Icon(Icons.arrow_back, color: Colors.white),
              onPressed: () => Navigator.pop(context),
            ),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Critical Patients',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
                Text(
                  '${criticalPatients.length} patients require immediate attention',
                  style: const TextStyle(fontSize: 11, color: Colors.white70),
                ),
              ],
            ),
          ),
          body: state is DoctorHomeLoading
              ? const Center(child: CircularProgressIndicator(color: Color(0xFFE05252)))
              : state is DoctorHomeError
                  ? Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline,
                              color: Colors.red.shade300, size: 48),
                          const SizedBox(height: 12),
                          Text(state.message,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  color: AppColors.Gray, fontSize: 13)),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context
                                .read<DoctorHomeBloc>()
                                .add(LoadDoctorHomeEvent()),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    )
                  : criticalPatients.isEmpty
                      ? Center(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.check_circle_outline,
                                  color: Colors.green.shade300, size: 64),
                              const SizedBox(height: 16),
                              Text(
                                'No critical patients at this time',
                                style: TextStyle(
                                    color: AppColors.Gray, fontSize: 15),
                              ),
                            ],
                          ),
                        )
                      : ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            // Priority Alert
                            Container(
                              padding: const EdgeInsets.all(14),
                              margin: const EdgeInsets.only(bottom: 16),
                              decoration: BoxDecoration(
                                color: Theme.of(context).cardColor.withOpacity(0.08),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                    color: const Color(0xFFE05252)
                                        .withOpacity(0.3)),
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const Icon(Icons.warning_amber_rounded,
                                      color: Color(0xFFE05252), size: 20),
                                  const SizedBox(width: 10),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          'Priority Alert',
                                          style: TextStyle(
                                            fontSize: 13,
                                            fontWeight: FontWeight.bold,
                                            color: isDark ? Colors.white : AppColors.Black,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          'These patients require urgent monitoring and immediate medical intervention.',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: isDark ? Colors.grey.shade400 : AppColors.Gray,
                                              height: 1.4),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Patients Cards from API ✅
                            ...criticalPatients.map(
                              (p) => CriticalPatientCard(
                                name: p.name,
                                diagnosis: p.diagnosis,
                                age: p.age,
                                lastVisit: p.lastVisit,
                                updatedAgo: p.lastVisit,
                                currentSymptoms: p.currentSymptoms.isNotEmpty
                                    ? p.currentSymptoms
                                    : 'No symptoms recorded',
                                recoveryRate: p.recoveryRate,
                                nextAppointment: p.nextAppointment.isNotEmpty
                                    ? p.nextAppointment
                                    : 'Not scheduled',
                                riskLevel: p.recoveryRate < 0.25
                                    ? RiskLevel.severe
                                    : RiskLevel.high,
                                onView: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.patientDetails,
                                  arguments: p,
                                ),
                                onCall: p.phone.isNotEmpty
                                    ? () => _launchCall(p.phone)
                                    : () {},
                                onMessage: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.chat,
                                  arguments: {
                                    'receiverId': p.id,
                                    'receiverName': p.name,
                                    'receiverRole': 'Patient',
                                  },
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            const CriticalCareGuidelinesCard(),
                          ],
                        ),
        );
      },
    );
  }
}