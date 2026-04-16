import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:dermalyze/features/auth/view/home/doctor/domain/entities/patient_entity.dart';
import 'package:dermalyze/features/auth/view/home/doctor/presentation/bloc/doctor_home_bloc.dart';
import 'package:dermalyze/features/auth/view/home/doctor/presentation/bloc/doctor_home_event.dart';
import 'package:dermalyze/features/auth/view/home/doctor/presentation/bloc/doctor_home_state.dart';
import 'package:dermalyze/features/auth/view/home/doctor/widgets/patient_item_card.dart';
import 'package:dermalyze/features/auth/view/home/doctor/widgets/patients_filter_tabs.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AllPatientsScreen extends StatefulWidget {
  const AllPatientsScreen({super.key});

  @override
  State<AllPatientsScreen> createState() => _AllPatientsScreenState();
}

class _AllPatientsScreenState extends State<AllPatientsScreen> {
  final _searchController = TextEditingController();
  String _selectedFilter = 'All';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<PatientEntity> _filterPatients(List<PatientEntity> all) {
    List<PatientEntity> result = all;
    if (_selectedFilter != 'All') {
      result = result
          .where((p) =>
              p.statusBadge.toLowerCase() == _selectedFilter.toLowerCase())
          .toList();
    }
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

  Map<String, int> _buildFilterCounts(List<PatientEntity> all) => {
        'All': all.length,
        'Improving': all.where((p) => p.statusBadge == 'improving').length,
        'Stable': all.where((p) => p.statusBadge == 'stable').length,
        'Critical': all.where((p) => p.statusBadge == 'critical').length,
      };

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<DoctorHomeBloc, DoctorHomeState>(
      builder: (context, state) {
        // طلب البيانات لو لسه مش loaded
        if (state is DoctorHomeInitial) {
          context.read<DoctorHomeBloc>().add(LoadDoctorHomeEvent());
        }

        final allPatients =
            state is DoctorHomeLoaded ? state.patients : <PatientEntity>[];
        final filtered = _filterPatients(allPatients);
        final counts = _buildFilterCounts(allPatients);

        return Scaffold(
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          appBar: AppBar(
            backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
            elevation: 0,
            leading: IconButton(
              icon: Icon(Icons.arrow_back, color: Theme.of(context).iconTheme.color),
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
                  '${filtered.length} patients found',
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
                    contentPadding:
                        const EdgeInsets.symmetric(vertical: 12),
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
                  onFilterChanged: (f) =>
                      setState(() => _selectedFilter = f),
                  filterCounts: counts,
                ),
                const SizedBox(height: 16),
                // Patients List
                if (state is DoctorHomeLoading)
                  const Expanded(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state is DoctorHomeError)
                  Expanded(
                    child: Center(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.error_outline,
                              color: Colors.red.shade300, size: 48),
                          const SizedBox(height: 12),
                          Text(
                            state.message,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                color: AppColors.Gray, fontSize: 13),
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () => context
                                .read<DoctorHomeBloc>()
                                .add(LoadDoctorHomeEvent()),
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      itemCount: filtered.length,
                      itemBuilder: (_, i) {
                        final p = filtered[i];
                        return PatientItemCard(
                          name: p.name,
                          diagnosis: p.diagnosis,
                          statusBadge: p.statusBadge,
                          qualityBadge: p.qualityBadge,
                          recoveryRate: p.recoveryRate,
                          lastVisit: p.lastVisit,
                          age: p.age,
                          // ✅ يمرر الـ PatientEntity الحقيقي
                          onTap: () => Navigator.pushNamed(
                            context,
                            AppRoutes.patientDetails,
                            arguments: p,
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}