import 'package:dermalyze/features/auth/bloc/auth_event.dart';
import 'package:dermalyze/features/auth/bloc/auth_state.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:dermalyze/core/storage/token_storage.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final TokenStorage tokenStorage;

  AuthBloc(this.tokenStorage) : super(AuthInitial()) {
    on<AppStarted>(_onAppStarted);
    on<LoggedIn>(_onLoggedIn);
    on<LoggedOut>(_onLoggedOut);
  }

  Future<void> _onAppStarted(
    AppStarted event,
    Emitter<AuthState> emit,
  ) async {
    emit(AuthLoading());

    final token = await tokenStorage.getToken();

    if (token != null) {
      emit(AuthAuthenticated());
    } else {
      emit(AuthUnauthenticated());
    }
  }

  Future<void> _onLoggedIn(
    LoggedIn event,
    Emitter<AuthState> emit,
  ) async {
    await tokenStorage.saveToken(event.token);
    emit(AuthAuthenticated());
  }

  Future<void> _onLoggedOut(
    LoggedOut event,
    Emitter<AuthState> emit,
  ) async {
    await tokenStorage.clearToken();
    emit(AuthUnauthenticated());
  }
}