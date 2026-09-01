import 'package:flutter_bloc/flutter_bloc.dart';

import '../domain/usecases/auth_use_cases.dart';
import 'auth_event.dart';
import 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignIn _signIn;
  final RegisterUserUsecase _registerUser;

  AuthBloc({
    required SignIn signIn,
    required RegisterUserUsecase registerUser,
  })  : _signIn = signIn,
        _registerUser = registerUser,
        super(const AuthInitial()) {
    on<AuthSignInRequested>(_onSignIn);
    on<AuthSignUpRequested>(_onSignUp);
  }

  Future<void> _onSignIn(
    AuthSignInRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _signIn(
      email: event.email,
      password: event.password,
    );

    result.fold(
      onSuccess: (user) => emit(AuthAuthenticated(user)),
      onFailure: (failure) => emit(AuthError(failure.message)),
    );
  }

  Future<void> _onSignUp(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _registerUser(
      name: event.name,
      email: event.email,
      password: event.password,
    );

    result.fold(
      onSuccess: (user) => emit(AuthAuthenticated(user)),
      onFailure: (failure) => emit(AuthError(failure.message)),
    );
  }
}
