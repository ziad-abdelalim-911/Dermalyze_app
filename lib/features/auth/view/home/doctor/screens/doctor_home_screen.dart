import 'package:dermalyze/core/constants/app_colors.dart';
import 'package:dermalyze/core/routes/app_routes.dart';
import 'package:dermalyze/core/storage/token_storage.dart';
import 'package:dermalyze/features/auth/view/home/doctor/data/repositories/doctor_home_repository_impl.dart';
import 'package:dermalyze/features/auth/view/home/doctor/domain/usecases/get_critical_patients_usecase.dart';
import 'package:dermalyze/features/auth/view/home/doctor/domain/usecases/get_doctor_stats_usecase.dart';
import 'package:dermalyze/features/auth/view/home/doctor/domain/usecases/get_patients_usecase.dart';
import 'package:dermalyze/features/auth/view/home/doctor/presentation/bloc/doctor_home_bloc.dart';
import 'package:dermalyze/features/auth/view/home/doctor/presentation/bloc/doctor_home_event.dart';
import 'package:dermalyze/features/auth/view/home/doctor/presentation/bloc/doctor_home_state.dart';
import 'package:dermalyze/features/auth/view/home/doctor/widgets/add_patient_banner.dart';
import 'package:dermalyze/features/auth/view/home/doctor/widgets/clinical_resources_card.dart';
import 'package:dermalyze/features/auth/view/home/doctor/widgets/patient_list_card.dart';
import 'package:dermalyze/features/auth/view/home/doctor/widgets/patient_search_bar.dart';
import 'package:dermalyze/features/auth/view/home/doctor/widgets/quick_actions_card.dart';
import 'package:dermalyze/features/auth/view/home/doctor/widgets/stats_grid_card.dart';
import 'package:dermalyze/features/auth/view/notifications/notifications_cubit.dart';
import 'package:dermalyze/features/auth/view/notifications/notifications_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DoctorHomeScreen extends StatelessWidget {
  const DoctorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DoctorHomeBloc(
        getDoctorStatsUseCase: GetDoctorStatsUseCase(DoctorHomeRepositoryImpl()),
        getPatientsUseCase: GetPatientsUseCase(DoctorHomeRepositoryImpl()),
        getCriticalPatientsUseCase: GetCriticalPatientsUseCase(DoctorHomeRepositoryImpl()),
      )..add(LoadDoctorHomeEvent()),
      child: const _DoctorHomeView(),
    );
  }
}

class _DoctorHomeView extends StatefulWidget {
  const _DoctorHomeView();

  @override
  State<_DoctorHomeView> createState() => _DoctorHomeViewState();
}

class _DoctorHomeViewState extends State<_DoctorHomeView> {
  final _searchController = TextEditingController();
  String _doctorName = 'Doctor';

  @override
  void initState() {
    super.initState();
    _loadDoctorName();
    context.read<NotificationsCubit>().fetchNotifications();
  }

  Future<void> _loadDoctorName() async {
    try {
      final user = await TokenStorage().getUser();
      if (mounted && user != null) {
        setState(() => _doctorName = user['name'] ?? 'Doctor');
      }
    } catch (_) {}
  }



  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: BlocBuilder<DoctorHomeBloc, DoctorHomeState>(
        builder: (context, state) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // ── Header + Stats ──
                Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient2,
                    borderRadius: const BorderRadius.only(
                      bottomLeft: Radius.circular(28),
                      bottomRight: Radius.circular(28),
                    ),
                  ),
                  child: SafeArea(
                    bottom: false,
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Welcome, Dr.',
                                    style: TextStyle(
                                      color: Theme.of(context).cardColor.withOpacity(0.85),
                                      fontSize: 13,
                                    ),
                                  ),
                                  Text(
                                    _doctorName,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                              Row(
                                children: [
                              BlocBuilder<NotificationsCubit, NotificationsState>(
                                builder: (context, notificationState) {
                                  int unread = 0;
                                  if (notificationState is NotificationsLoaded) {
                                    unread = notificationState.unreadCount;
                                  }

                                  return Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Container(
                                        width: 40,
                                        height: 40,
                                        decoration: BoxDecoration(
                                          color: Theme.of(context).cardColor.withOpacity(0.2),
                                          borderRadius: BorderRadius.circular(12),
                                        ),
                                        child: IconButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context, AppRoutes.notifications);
                                          },
                                          icon: const Icon(
                                            Icons.notifications_outlined,
                                            color: Colors.white,
                                            size: 20,
                                          ),
                                        ),
                                      ),
                                      if (unread > 0)
                                        Positioned(
                                          top: -2,
                                          right: -2,
                                          child: Container(
                                            padding: const EdgeInsets.all(2),
                                            decoration: const BoxDecoration(
                                              color: Colors.red,
                                              shape: BoxShape.circle,
                                            ),
                                            constraints: const BoxConstraints(
                                              minWidth: 14,
                                              minHeight: 14,
                                            ),
                                            child: Center(
                                              child: Text(
                                                unread > 9 ? '9+' : '$unread',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 8,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                    ],
                                  );
                                },
                              ),
                                  const SizedBox(width: 10),
                                  Container(
                                    width: 40,
                                    height: 40,
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).cardColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      onPressed: () => Navigator.pushNamed(context, AppRoutes.Settings),
                                      icon: const Icon(
                                        Icons.settings_outlined,
                                        color: Colors.white,
                                        size: 20,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          // Stats
                          if (state is DoctorHomeLoaded)
                            StatsGridCard(
                              stats: [
                                StatItem(
                                  label: 'Total Patients',
                                  value: state.patients.length.toString(),
                                  icon: Icons.people_outline,
                                  iconColor: Colors.white,
                                ),
                                StatItem(
                                  label: 'Infected People',
                                  value: state.stats.infectedPeople.toString(),
                                  icon: Icons.warning_amber_outlined,
                                  iconColor: Colors.orangeAccent,
                                ),
                                StatItem(
                                  label: 'Active Today',
                                  value: state.stats.activeToday.toString(),
                                  icon: Icons.trending_up,
                                  iconColor: Colors.white,
                                ),
                                StatItem(
                                  label: 'Critical Cases',
                                  value: state.criticalPatients.length.toString(),
                                  icon: Icons.emergency_outlined,
                                  iconColor: Colors.redAccent,
                                ),
                              ],
                            ),
                          if (state is DoctorHomeLoading)
                            const Center(
                              child: CircularProgressIndicator(
                                color: Colors.white,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
                // ── Content ──
                if (state is DoctorHomeLoading)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 60),
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state is DoctorHomeError)
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.cloud_off_outlined,
                            size: 64,
                            color: Colors.red.withValues(alpha: 0.5),
                          ),
                          const SizedBox(height: 16),
                          const Text(
                            'Server Connection Issue',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Our clinical database is currently undergoing maintenance. Please try again in a few moments.',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: AppColors.Gray,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 24),
                          ElevatedButton.icon(
                            onPressed: () => context
                                .read<DoctorHomeBloc>()
                                .add(LoadDoctorHomeEvent()),
                            icon: const Icon(Icons.refresh),
                            label: const Text('Retry Connection'),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.SkyBlue,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'Error Log: ${state.message}',
                            style: TextStyle(
                              fontSize: 10,
                              color: Colors.grey.withValues(alpha: 0.6),
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (state is DoctorHomeLoaded)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 16, 16, 30),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        AddPatientBanner(
                          onTap: () async {
                            final refresh = await Navigator.pushNamed(
                                context, AppRoutes.addNewPatient);
                            if (refresh == true && context.mounted) {
                              context
                                  .read<DoctorHomeBloc>()
                                  .add(LoadDoctorHomeEvent());
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        PatientSearchBar(
                          controller: _searchController,
                          onChanged: (q) => context
                              .read<DoctorHomeBloc>()
                              .add(SearchPatientsEvent(q)),
                        ),
                        const SizedBox(height: 16),
                        Row(
                          mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Patients List',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                                color: Theme.of(context).colorScheme.onSurface,
                              ),
                            ),
                            Text(
                              '${state.filteredPatients.length} total',
                              style: TextStyle(
                                  fontSize: 13,
                                  color: AppColors.Gray),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        PatientListCard(
                          patients: state.filteredPatients
                              .map((p) => PatientListItem(
                                    name: p.name,
                                    diagnosis: p.diagnosis,
                                    qualityBadge: p.qualityBadge,
                                    statusBadge: p.statusBadge,
                                    recoveryRate: p.recoveryRate,
                                    lastVisit: p.lastVisit,
                                  ))
                              .toList(),
                          onPatientTap: (item) async {
                            // نلاقي الـ PatientEntity المناسب
                            final patient = state.filteredPatients
                                .firstWhere((p) => p.name == item.name);
                            await Navigator.pushNamed(
                              context,
                              AppRoutes.patientDetails,
                              arguments: patient,
                            );
                            if (context.mounted) {
                              context.read<DoctorHomeBloc>().add(LoadDoctorHomeEvent());
                            }
                          },
                        ),
                        const SizedBox(height: 16),
                        QuickActionsCard(
                          totalPatients: state.patients.length.toString(),
                          criticalCases: state.criticalPatients.length.toString(),
                          onAllPatients: () => Navigator.pushNamed(
                              context, AppRoutes.allPatients),
                          onCritical: () => Navigator.pushNamed(
                              context, AppRoutes.criticalPatients),
                        ),
                        const SizedBox(height: 16),
                        ClinicalResourcesCard(
                          onSmartHistory: () => Navigator.pushNamed(
                              context, AppRoutes.smartHistory),
                          onMedications: () => Navigator.pushNamed(
                              context, AppRoutes.medicationsGuide),
                          onDiseases: () => Navigator.pushNamed(
                              context, AppRoutes.diseasesLibrary),
                        ),
                      ],
                    ),
                  )
                else
                  const SizedBox(),
              ],
            ),
          );
        },
      ),
    );
  }
}