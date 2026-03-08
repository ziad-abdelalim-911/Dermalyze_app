import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:dermalyze/features/auth/view/home/doctor/widgets/critical_care_guidelines_card.dart';
import 'package:dermalyze/features/auth/view/home/doctor/widgets/critical_patient_card.dart';
import 'package:flutter/material.dart';

class _CriticalPatient {
  final String name;
  final String diagnosis;
  final int age;
  final String lastVisit;
  final String updatedAgo;
  final String currentSymptoms;
  final double recoveryRate;
  final String nextAppointment;
  final RiskLevel riskLevel;

  const _CriticalPatient({
    required this.name,
    required this.diagnosis,
    required this.age,
    required this.lastVisit,
    required this.updatedAgo,
    required this.currentSymptoms,
    required this.recoveryRate,
    required this.nextAppointment,
    required this.riskLevel,
  });
}

class CriticalPatientsScreen extends StatelessWidget {
  const CriticalPatientsScreen({super.key});

  static const List<_CriticalPatient> _patients = [
    _CriticalPatient(
      name: 'William Martinez',
      diagnosis: 'Dermatitis Herpetiformis',
      age: 51,
      lastVisit: '12 hours ago',
      updatedAgo: '2 hours ago',
      currentSymptoms: 'Severe blistering, intense itching',
      recoveryRate: 0.38,
      nextAppointment: 'Jan 8, 2026',
      riskLevel: RiskLevel.high,
    ),
    _CriticalPatient(
      name: 'Ethan Thomas',
      diagnosis: 'Allergic Contact Dermatitis',
      age: 36,
      lastVisit: '1 day ago',
      updatedAgo: '5 hours ago',
      currentSymptoms: 'Spreading rash, swelling',
      recoveryRate: 0.29,
      nextAppointment: 'Jan 9, 2026',
      riskLevel: RiskLevel.high,
    ),
    _CriticalPatient(
      name: 'Daniel Wilson',
      diagnosis: 'Stevens-Johnson Syndrome',
      age: 45,
      lastVisit: '6 hours ago',
      updatedAgo: '1 hour ago',
      currentSymptoms: 'Skin peeling, fever, mucous involvement',
      recoveryRate: 0.22,
      nextAppointment: 'Jan 7, 2026',
      riskLevel: RiskLevel.severe,
    ),
    _CriticalPatient(
      name: 'Grace Lee',
      diagnosis: 'Pemphigus Vulgaris',
      age: 58,
      lastVisit: '8 hours ago',
      updatedAgo: '3 hours ago',
      currentSymptoms: 'Oral blisters, skin erosions',
      recoveryRate: 0.35,
      nextAppointment: 'Jan 8, 2026',
      riskLevel: RiskLevel.high,
    ),
    _CriticalPatient(
      name: 'Lucas Moore',
      diagnosis: 'Toxic Epidermal Necrolysis',
      age: 52,
      lastVisit: '4 hours ago',
      updatedAgo: '30 minutes ago',
      currentSymptoms: 'Extensive skin detachment, systemic symptoms',
      recoveryRate: 0.18,
      nextAppointment: 'Jan 7, 2026',
      riskLevel: RiskLevel.severe,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
        backgroundColor: const Color(0xFFE05252),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Critical Patients',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
            Text(
              '5 patients require immediate attention',
              style: TextStyle(fontSize: 11, color: Colors.white70),
            ),
          ],
        ),
      ),
      body: ListView(
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
                  color: const Color(0xFFE05252).withOpacity(0.3)),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Color(0xFFE05252), size: 20),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
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
          // Patients Cards
          ..._patients.map(
            (p) => CriticalPatientCard(
              name: p.name,
              diagnosis: p.diagnosis,
              age: p.age,
              lastVisit: p.lastVisit,
              updatedAgo: p.updatedAgo,
              currentSymptoms: p.currentSymptoms,
              recoveryRate: p.recoveryRate,
              nextAppointment: p.nextAppointment,
              riskLevel: p.riskLevel,
              onView: () =>
                  Navigator.pushNamed(context, AppRoutes.patientDetails),
              onCall: () {
                // TODO: call logic
              },
              onMessage: () {
                // TODO: message logic
              },
            ),
          ),
          const SizedBox(height: 16),
          const CriticalCareGuidelinesCard(),
        ],
      ),
    );
  }
}