abstract class DoctorHomeEvent {}

class LoadDoctorHomeEvent extends DoctorHomeEvent {}

class SearchPatientsEvent extends DoctorHomeEvent {
  final String query;
  SearchPatientsEvent(this.query);
}

class FilterPatientsEvent extends DoctorHomeEvent {
  final String filter;
  FilterPatientsEvent(this.filter);
}

class UpdatePatientEvent extends DoctorHomeEvent {
  final Map<String, dynamic> updatedPatientData;
  UpdatePatientEvent(this.updatedPatientData);
}