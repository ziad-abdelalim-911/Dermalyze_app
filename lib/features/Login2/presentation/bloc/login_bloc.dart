import 'package:flutter_bloc/flutter_bloc.dart';

import '../../domain/repositories/login_repository.dart';
import 'login_event.dart';
import 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final LoginRepository repository;

  LoginBloc(this.repository) : super(LoginInitial()) {
    on<LoginButtonPressed>((event, emit) async {
      emit(LoginLoading());

      try {
        final result = await repository.login(
          email: event.email,
          password: event.password,
        );

        emit(LoginSuccess(role: result.user.role));
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });

    on<ActivateAccountPressed>((event, emit) async {
      emit(LoginLoading());

      try {
        final result = await repository.activateAccount(
          token: event.token,
          password: event.password,
        );

        emit(LoginSuccess(role: result.user.role));
      } catch (e) {
        emit(LoginFailure(e.toString()));
      }
    });
  }
}
