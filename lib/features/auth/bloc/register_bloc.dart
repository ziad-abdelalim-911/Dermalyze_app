import 'package:dermalyze/features/auth/bloc/register_event.dart';
import 'package:dermalyze/features/auth/bloc/register_state.dart';
import 'package:dermalyze/features/auth/data/models/register_request_model.dart';
import 'package:dermalyze/features/auth/data/repositories/register_repository.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  final RegisterRepository _repository = RegisterRepository();

  RegisterBloc() : super(RegisterInitial()) {
    on<RegisterSubmitted>(_onRegisterSubmitted);
  }

  Future<void> _onRegisterSubmitted(
    RegisterSubmitted event,
    Emitter<RegisterState> emit,
  ) async {
    emit(RegisterLoading());
    try {
      final result = await _repository.register(
        RegisterRequestModel(
          name: event.name,
          email: event.email,
          password: event.password,
          role: event.role,
          doctorCode: event.doctorCode,
          phone: event.phone,
          nationalId: event.nationalId,
          birthDate: event.birthDate,
          idCardFront: event.idCardFront,
          idCardBack: event.idCardBack,
          selfie: event.selfie,
        ),
      );
      emit(RegisterSuccess(role: result.user.role));
    } catch (e) {
      emit(RegisterFailure(e.toString()));
    }
  }
}
