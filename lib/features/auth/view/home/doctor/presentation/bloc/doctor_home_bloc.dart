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

  DoctorHomeBloc({
    required this.getDoctorStatsUseCase,
    required this.getPatientsUseCase,
    required this.getCriticalPatientsUseCase,
  }) : super(DoctorHomeInitial()) {
    on<LoadDoctorHomeEvent>(_onLoad);
    on<SearchPatientsEvent>(_onSearch);
    on<FilterPatientsEvent>(_onFilter);
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
}