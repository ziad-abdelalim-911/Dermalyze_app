import 'dart:async';
import 'package:dermalyze/core/services/socket_service.dart';
import 'package:dermalyze/features/auth/view/home/doctor/presentation/bloc/doctor_home_event.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/patient_entity.dart';
import '../../domain/usecases/get_critical_patients_usecase.dart';
import '../../domain/usecases/get_doctor_stats_usecase.dart';
import '../../domain/usecases/get_patients_usecase.dart';
import 'doctor_home_state.dart';

class DoctorHomeBloc extends Bloc<DoctorHomeEvent, DoctorHomeState> {
  final GetDoctorStatsUseCase getDoctorStatsUseCase;
  final GetPatientsUseCase getPatientsUseCase;
  final GetCriticalPatientsUseCase getCriticalPatientsUseCase;
  StreamSubscription? _patientSubscription;

  DoctorHomeBloc({
    required this.getDoctorStatsUseCase,
    required this.getPatientsUseCase,
    required this.getCriticalPatientsUseCase,
  }) : super(DoctorHomeInitial()) {
    on<LoadDoctorHomeEvent>(_onLoad);
    on<SearchPatientsEvent>(_onSearch);
    on<FilterPatientsEvent>(_onFilter);
    on<UpdatePatientEvent>(_onUpdatePatient);

    _patientSubscription = SocketService().patientUpdateStream.listen((data) {
      add(UpdatePatientEvent(data));
    });
  }

  @override
  Future<void> close() {
    _patientSubscription?.cancel();
    return super.close();
  }

  Future<void> _onLoad(
    LoadDoctorHomeEvent event,
    Emitter<DoctorHomeState> emit,
  ) async {
    emit(DoctorHomeLoading());
    try {
      final stats = await getDoctorStatsUseCase();
      final patients = await getPatientsUseCase();
      
      // Filter locally to avoid double API requests!
      final criticalPatients = patients.where((p) => p.isCritical).toList();

      emit(DoctorHomeLoaded(
        stats: stats,
        patients: patients,
        filteredPatients: patients,
        criticalPatients: criticalPatients,
      ));
    } catch (e) {
      emit(DoctorHomeError(e.toString()));
    }
  }

  void _onSearch(
    SearchPatientsEvent event,
    Emitter<DoctorHomeState> emit,
  ) {
    if (state is! DoctorHomeLoaded) return;
    final current = state as DoctorHomeLoaded;

    final filtered = _applyFilters(
      patients: current.patients,
      query: event.query,
      filter: current.selectedFilter,
    );

    emit(current.copyWith(
      filteredPatients: filtered,
      searchQuery: event.query,
    ));
  }

  void _onFilter(
    FilterPatientsEvent event,
    Emitter<DoctorHomeState> emit,
  ) {
    if (state is! DoctorHomeLoaded) return;
    final current = state as DoctorHomeLoaded;

    final filtered = _applyFilters(
      patients: current.patients,
      query: current.searchQuery,
      filter: event.filter,
    );

    emit(current.copyWith(
      filteredPatients: filtered,
      selectedFilter: event.filter,
    ));
  }

  List<PatientEntity> _applyFilters({
    required List<PatientEntity> patients,
    required String query,
    required String filter,
  }) {
    List<PatientEntity> result = patients;

    if (filter != 'All') {
      result = result
          .where((p) => p.statusBadge.toLowerCase() == filter.toLowerCase())
          .toList();
    }

    if (query.isNotEmpty) {
      result = result
          .where((p) =>
              p.name.toLowerCase().contains(query.toLowerCase()) ||
              p.diagnosis.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    return result;
  }

  void _onUpdatePatient(
    UpdatePatientEvent event,
    Emitter<DoctorHomeState> emit,
  ) {
    if (state is! DoctorHomeLoaded) return;
    final current = state as DoctorHomeLoaded;
    final data = event.updatedPatientData;
    final patientId = data['patientId']?.toString();
    if (patientId == null) return;

    // Update patient list
    final updatedPatients = current.patients.map((p) {
      if (p.id == patientId) {
        double newRecoveryRate = p.recoveryRate;
        String newImprovement = p.improvement;
        if (data.containsKey('recoveryProgress')) {
          final recovery = data['recoveryProgress'];
          double parsedRecovery = 0.0;
          if (recovery is num) {
            parsedRecovery = recovery.toDouble();
          } else if (recovery is String) {
            parsedRecovery = double.tryParse(recovery) ?? 0.0;
          }
          newRecoveryRate = parsedRecovery > 1.0 ? parsedRecovery / 100.0 : parsedRecovery.clamp(0.0, 1.0);
        }
        if (data.containsKey('improvement')) {
          newImprovement = data['improvement'].toString();
        }

        return p.copyWith(
          nextAppointment: data['nextAppointment'] ?? p.nextAppointment,
          lastVisit: data['lastVisit'] ?? p.lastVisit,
          statusBadge: data['status'] ?? p.statusBadge,
          recoveryRate: newRecoveryRate,
          improvement: newImprovement,
        );
      }
      return p;
    }).toList();

    // Re-apply filters using updated list
    final updatedFiltered = _applyFilters(
      patients: updatedPatients,
      query: current.searchQuery,
      filter: current.selectedFilter,
    );

    final updatedCritical = updatedPatients.where((p) => p.isCritical).toList();

    emit(current.copyWith(
      patients: updatedPatients,
      filteredPatients: updatedFiltered,
      criticalPatients: updatedCritical,
    ));
  }
}