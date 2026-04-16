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

class CriticalPatientsScreen extends StatelessWidget {
  const CriticalPatientsScreen({super.key});

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

        return Scaffold(
          backgroundColor: const Color(0xFFF0F4F8),
          appBar: AppBar(
            backgroundColor: const Color(0xFFE05252),
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
                                color: const Color(0xFFE05252).withOpacity(0.08),
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
                                            color: AppColors.Black,
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          'These patients require urgent monitoring and immediate medical intervention.',
                                          style: TextStyle(
                                              fontSize: 12,
                                              color: AppColors.Gray,
                                              height: 1.4),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            // Patients Cards from API
                            ...criticalPatients.map(
                              (p) => CriticalPatientCard(
                                name: p.name,
                                diagnosis: p.diagnosis,
                                age: p.age,
                                lastVisit: p.lastVisit,
                                updatedAgo: '—',
                                currentSymptoms: '—',
                                recoveryRate: p.recoveryRate,
                                nextAppointment: '—',
                                riskLevel: RiskLevel.high,
                                onView: () => Navigator.pushNamed(
                                  context,
                                  AppRoutes.patientDetails,
                                  arguments: p,
                                ),
                                onCall: () {},
                                onMessage: () {},
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