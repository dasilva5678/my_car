import 'package:flutter_bloc/flutter_bloc.dart';

import '../repository/auth_repository.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository? repository;

  AuthBloc({this.repository}) : super(const AuthInitial()) {
    on<AuthCheckRequested>(_onCheck);
    on<AuthSignInRequested>(_onSignIn);
    on<AuthSignUpRequested>(_onSignUp);
    on<AuthSignOutRequested>(_onSignOut);
    on<AuthDeleteRequested>(_onDelete);
  }

  Future<void> _onCheck(AuthCheckRequested e, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    if (repository == null) {
      emit(const AuthUnauthenticated());
      return;
    }
    try {
      final user = await repository?.getCurrentUser();
      user != null
          ? emit(AuthAuthenticated(user))
          : emit(const AuthUnauthenticated());
    } catch (_) {
      emit(const AuthUnauthenticated());
    }
  }

  Future<void> _onSignIn(AuthSignInRequested e, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    if (repository == null) return;
    try {
      final user = await repository?.signIn(
        email: e.email,
        password: e.password,
      );
      if (user == null) {
        emit(const AuthUnauthenticated());
        return;
      }
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignUp(AuthSignUpRequested e, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    if (repository == null) return;
    try {
      final user = await repository?.register(
        name: e.name,
        email: e.email,
        password: e.password,
      );
      if (user == null) {
        emit(const AuthUnauthenticated());
        return;
      }
      emit(AuthAuthenticated(user));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onSignOut(
      AuthSignOutRequested e, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    if (repository == null) return;
    try {
      await repository!.signOut();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> _onDelete(AuthDeleteRequested e, Emitter<AuthState> emit) async {
    emit(const AuthLoading());
    if (repository == null) return;
    try {
      await repository!.deleteAccount();
      emit(const AuthUnauthenticated());
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }
}
