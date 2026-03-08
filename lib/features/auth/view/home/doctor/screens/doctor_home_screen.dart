import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:dermalyze/features/auth/view/home/doctor/widgets/add_patient_banner.dart';
import 'package:dermalyze/features/auth/view/home/doctor/widgets/clinical_resources_card.dart';
import 'package:dermalyze/features/auth/view/home/doctor/widgets/doctor_home_header.dart';
import 'package:dermalyze/features/auth/view/home/doctor/widgets/patient_list_card.dart';
import 'package:dermalyze/features/auth/view/home/doctor/widgets/patient_search_bar.dart';
import 'package:dermalyze/features/auth/view/home/doctor/widgets/quick_actions_card.dart';
import 'package:dermalyze/features/auth/view/home/doctor/widgets/stats_grid_card.dart';
import 'package:flutter/material.dart';

class DoctorHomeScreen extends StatefulWidget {
  const DoctorHomeScreen({super.key});

  @override
  State<DoctorHomeScreen> createState() => _DoctorHomeScreenState();
}

class _DoctorHomeScreenState extends State<DoctorHomeScreen> {
  final _searchController = TextEditingController();

  // Mock Data
  final _stats = const [
    StatItem(
      label: 'Total Patients',
      value: '247',
      icon: Icons.people_outline,
      iconColor: Colors.white,
    ),
    StatItem(
      label: 'Infected People',
      value: '84',
      icon: Icons.warning_amber_outlined,
      iconColor: Colors.orangeAccent,
    ),
    StatItem(
      label: 'Active Today',
      value: '23',
      icon: Icons.trending_up,
      iconColor: Colors.white,
    ),
    StatItem(
      label: 'Critical Cases',
      value: '5',
      icon: Icons.emergency_outlined,
      iconColor: Colors.redAccent,
    ),
  ];

  final List<PatientListItem> _patients = const [
    PatientListItem(
      name: 'Sarah Johnson',
      diagnosis: '',
      qualityBadge: 'Medium',
      statusBadge: 'improving',
      recoveryRate: 0.65,
      lastVisit: '',
    ),
    PatientListItem(
      name: 'Michael Chen',
      diagnosis: 'Psoriasis',
      qualityBadge: 'Low',
      statusBadge: 'stable',
      recoveryRate: 0.45,
      lastVisit: '5 days ago',
    ),
    PatientListItem(
      name: 'Emma Williams',
      diagnosis: 'Eczema',
      qualityBadge: 'High',
      statusBadge: 'improving',
      recoveryRate: 0.82,
      lastVisit: '1 day ago',
    ),
    PatientListItem(
      name: 'James Brown',
      diagnosis: 'Contact Dermatitis',
      qualityBadge: 'High',
      statusBadge: 'recovering',
      recoveryRate: 0.91,
      lastVisit: '3 days ago',
    ),
    PatientListItem(
      name: 'Olivia Davis',
      diagnosis: 'Rosacea',
      qualityBadge: 'Medium',
      statusBadge: 'stable',
      recoveryRate: 0.56,
      lastVisit: '4 days ago',
    ),
    PatientListItem(
      name: 'Robert Miller',
      diagnosis: 'Seborrheic Dermatitis',
      qualityBadge: 'Medium',
      statusBadge: 'improving',
      recoveryRate: 0.73,
      lastVisit: '1 day ago',
    ),
  ];

  List<PatientListItem> _filteredPatients = [];

  @override
  void initState() {
    super.initState();
    _filteredPatients = _patients;
  }

  void _onSearch(String query) {
    setState(() {
      _filteredPatients = _patients
          .where(
            (p) =>
                p.name.toLowerCase().contains(query.toLowerCase()) ||
                p.diagnosis.toLowerCase().contains(query.toLowerCase()),
          )
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      body: Column(
        children: [
          // Header with Stats
          Stack(
            clipBehavior: Clip.none,
            children: [
              DoctorHomeHeader(
                doctorName: 'Shawkat',
                onNotification: () =>
                    Navigator.pushNamed(context, AppRoutes.notifications),
                onSettings: () {},
              ),
              Positioned(
                bottom: -60,
                left: 16,
                right: 16,
                child: StatsGridCard(stats: _stats),
              ),
            ],
          ),
          const SizedBox(height: 60),
          // Scrollable Content
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AddPatientBanner(
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.addNewPatient),
                  ),
                  const SizedBox(height: 16),
                  PatientSearchBar(
                    controller: _searchController,
                    onChanged: _onSearch,
                  ),
                  const SizedBox(height: 16),
                  // Patients List Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Patients List',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.Black,
                        ),
                      ),
                      Text(
                        '${_filteredPatients.length} total',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.Gray,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  PatientListCard(
                    patients: _filteredPatients,
                    onPatientTap: (p) => Navigator.pushNamed(
                        context, AppRoutes.patientDetails),
                  ),
                  const SizedBox(height: 16),
                  QuickActionsCard(
                    totalPatients: '247',
                    criticalCases: '5',
                    onAllPatients: () {},
                    onCritical: () {},
                  ),
                  const SizedBox(height: 16),
                  ClinicalResourcesCard(
                    onSmartHistory: () {},
                    onMedications: () {},
                    onDiseases: () {},
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}