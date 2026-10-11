import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_car/core/either/either.dart';
import 'package:my_car/core/error/failures.dart';
import 'package:my_car/features/auth/domain/entities/app_user.dart';
import 'package:my_car/features/auth/domain/usecases/register_usecase.dart';
import 'package:my_car/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:my_car/features/auth/presentation/bloc/auth_event.dart';
import 'package:my_car/features/auth/presentation/bloc/auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final SignInUseCase _signIn;
  final RegisterUseCase _register;

  AuthBloc({
    required SignInUseCase signIn,
    required RegisterUseCase register,
  })  : _signIn = signIn,
        _register = register,
        super(const AuthInitial()) {
    on<AuthSignInRequested>(_onSignIn);
    on<AuthSignUpRequested>(_onSignUp);
    on<AuthSignOutRequested>(_onSignOut);
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
    _emitResult(result, emit);
  }

  Future<void> _onSignUp(
    AuthSignUpRequested event,
    Emitter<AuthState> emit,
  ) async {
    emit(const AuthLoading());
    final result = await _register(
      name: event.name,
      email: event.email,
      password: event.password,
    );
    _emitResult(result, emit);
  }

  // Ainda não há sessão persistida; quando houver token, delegar a um
  // SignOutUseCase que limpe o armazenamento.
  void _onSignOut(AuthSignOutRequested event, Emitter<AuthState> emit) =>
      emit(const AuthUnauthenticated());

  void _emitResult(Either<Failure, AppUser> result, Emitter<AuthState> emit) =>
      result.fold(
        onLeft: (failure) => emit(AuthError(failure)),
        onRight: (user) => emit(AuthAuthenticated(user)),
      );
}
