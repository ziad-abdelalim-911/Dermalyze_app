import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:dermalyze/features/auth/view/home/doctor/widgets/patient_item_card.dart';
import 'package:dermalyze/features/auth/view/home/doctor/widgets/patients_filter_tabs.dart';
import 'package:flutter/material.dart';

class _Patient {
  final String name;
  final String diagnosis;
  final String status;
  final String quality;
  final double recoveryRate;
  final String lastVisit;
  final int age;

  const _Patient({
    required this.name,
    required this.diagnosis,
    required this.status,
    required this.quality,
    required this.recoveryRate,
    required this.lastVisit,
    required this.age,
  });
}

class AllPatientsScreen extends StatefulWidget {
  const AllPatientsScreen({super.key});

  @override
  State<AllPatientsScreen> createState() => _AllPatientsScreenState();
}

class _AllPatientsScreenState extends State<AllPatientsScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'All';

  // Mock Data
  final List<_Patient> _allPatients = const [
    _Patient(name: 'Amr Abdelrahim', diagnosis: 'Atopic Dermatitis', status: 'Improving', quality: 'Medium', recoveryRate: 0.58, lastVisit: '2 days ago', age: 34),
    _Patient(name: 'Michael Chen', diagnosis: 'Psoriasis', status: 'Stable', quality: 'Low', recoveryRate: 0.45, lastVisit: '5 days ago', age: 42),
    _Patient(name: 'Emma Williams', diagnosis: 'Eczema', status: 'Improving', quality: 'High', recoveryRate: 0.82, lastVisit: '1 day ago', age: 29),
    _Patient(name: 'James Brown', diagnosis: 'Contact Dermatitis', status: 'Improving', quality: 'High', recoveryRate: 0.91, lastVisit: '3 days ago', age: 11),
    _Patient(name: 'Olivia Davis', diagnosis: 'Rosacea', status: 'Stable', quality: 'Medium', recoveryRate: 0.56, lastVisit: '4 days ago', age: 29),
    _Patient(name: 'Robert Miller', diagnosis: 'Seborrheic Dermatitis', status: 'Improving', quality: 'Medium', recoveryRate: 0.73, lastVisit: '1 day ago', age: 41),
    _Patient(name: 'Sophia Garcia', diagnosis: 'Acne Vulgaris', status: 'Improving', quality: 'High', recoveryRate: 0.68, lastVisit: '6 hours ago', age: 22),
    _Patient(name: 'William Martinez', diagnosis: 'Dermatitis-reperfomis', status: 'Critical', quality: 'Low', recoveryRate: 0.25, lastVisit: '10 years ago', age: 31),
    _Patient(name: 'Isabella Rodriguez', diagnosis: 'Perioral Dermatitis', status: 'Stable', quality: 'Medium', recoveryRate: 0.65, lastVisit: '2 days ago', age: 31),
    _Patient(name: 'Benjamin Taylor', diagnosis: 'Nummular Eczema', status: 'Improving', quality: 'High', recoveryRate: 0.77, lastVisit: '2 days ago', age: 44),
    _Patient(name: 'Mia Anderson', diagnosis: 'Stasis Dermatitis', status: 'Stable', quality: 'Medium', recoveryRate: 0.52, lastVisit: '5 days ago', age: 13),
    _Patient(name: 'Ethan Thomas', diagnosis: 'Allergic Contact Dermatitis', status: 'Critical', quality: 'Low', recoveryRate: 0.29, lastVisit: '1 day ago', age: 28),
    _Patient(name: 'Charlotte Jackson', diagnosis: 'Dyshidrotic Eczema', status: 'Improving', quality: 'Medium', recoveryRate: 0.18, lastVisit: '4 days ago', age: 26),
    _Patient(name: 'Alexander White', diagnosis: 'Lichen Planus', status: 'Improving', quality: 'High', recoveryRate: 0.84, lastVisit: '2 days ago', age: 48),
    _Patient(name: 'Amelia Harris', diagnosis: 'Photodermatitis', status: 'Improving', quality: 'High', recoveryRate: 0.82, lastVisit: '1 day ago', age: 31),
  ];

  List<_Patient> get _filteredPatients {
    List<_Patient> result = _allPatients;

    // Filter by status
    if (_selectedFilter != 'All') {
      result = result
          .where((p) =>
              p.status.toLowerCase() == _selectedFilter.toLowerCase())
          .toList();
    }

    // Filter by search
    final query = _searchController.text.toLowerCase();
    if (query.isNotEmpty) {
      result = result
          .where((p) =>
              p.name.toLowerCase().contains(query) ||
              p.diagnosis.toLowerCase().contains(query))
          .toList();
    }

    return result;
  }

  Map<String, int> get _filterCounts => {
        'All': _allPatients.length,
        'Improving': _allPatients.where((p) => p.status == 'Improving').length,
        'Stable': _allPatients.where((p) => p.status == 'Stable').length,
        'Critical': _allPatients.where((p) => p.status == 'Critical').length,
      };

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F4F8),
      appBar: AppBar(
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
              'All Patients',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: AppColors.Black,
              ),
            ),
            Text(
              '${_filteredPatients.length} patients found',
              style: TextStyle(fontSize: 12, color: AppColors.Gray),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 16),
        child: Column(
          children: [
            // Search Bar
            TextField(
              controller: _searchController,
              onChanged: (_) => setState(() {}),
              style: TextStyle(fontSize: 14, color: AppColors.Black),
              decoration: InputDecoration(
                hintText: 'Search by name or diagnosis...',
                hintStyle: TextStyle(fontSize: 13, color: AppColors.Gray),
                prefixIcon:
                    Icon(Icons.search, color: AppColors.Gray, size: 20),
                filled: true,
                fillColor: Colors.white,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: AppColors.Gray2, width: 1.5),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: AppColors.Gray2, width: 1.5),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide:
                      BorderSide(color: AppColors.SkyBlue, width: 1.8),
                ),
              ),
            ),
            const SizedBox(height: 12),
            // Filter Tabs
            PatientsFilterTabs(
              selectedFilter: _selectedFilter,
              onFilterChanged: (f) => setState(() => _selectedFilter = f),
              filterCounts: _filterCounts,
            ),
            const SizedBox(height: 16),
            // Patients List
            Expanded(
              child: ListView.builder(
                itemCount: _filteredPatients.length,
                itemBuilder: (_, i) {
                  final p = _filteredPatients[i];
                  return PatientItemCard(
                    name: p.name,
                    diagnosis: p.diagnosis,
                    statusBadge: p.status,
                    qualityBadge: p.quality,
                    recoveryRate: p.recoveryRate,
                    lastVisit: p.lastVisit,
                    age: p.age,
                    onTap: () => Navigator.pushNamed(
                        context, AppRoutes.patientDetails),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}