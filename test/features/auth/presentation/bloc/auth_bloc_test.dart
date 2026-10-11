import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_car/core/either/either.dart';
import 'package:my_car/core/error/failures.dart';
import 'package:my_car/features/auth/domain/failures/auth_failure.dart';
import 'package:my_car/features/auth/domain/usecases/register_usecase.dart';
import 'package:my_car/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:my_car/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_car/features/auth/presentation/bloc/auth_event.dart';
import 'package:my_car/features/auth/presentation/bloc/auth_state.dart';

import '../../../../helpers/fixtures.dart';

class _MockSignIn extends Mock implements SignInUseCase {}

class _MockRegister extends Mock implements RegisterUseCase {}

void main() {
  late _MockSignIn signIn;
  late _MockRegister register;

  setUp(() {
    signIn = _MockSignIn();
    register = _MockRegister();
  });

  AuthBloc buildBloc() => AuthBloc(signIn: signIn, register: register);

  test('estado inicial é AuthInitial', () {
    expect(buildBloc().state, const AuthInitial());
  });

  group('AuthSignInRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emite [Loading, Authenticated] no sucesso',
      setUp: () => when(() => signIn(email: tEmail, password: tPassword))
          .thenAnswer((_) async => const Right(tUser)),
      build: buildBloc,
      act: (bloc) => bloc.add(
        const AuthSignInRequested(email: tEmail, password: tPassword),
      ),
      expect: () => const [AuthLoading(), AuthAuthenticated(tUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'emite [Loading, Error] com a Failure recebida',
      setUp: () =>
          when(() => signIn(email: tEmail, password: tPassword)).thenAnswer(
        (_) async => const Left(AuthFailure.invalidCredentials()),
      ),
      build: buildBloc,
      act: (bloc) => bloc.add(
        const AuthSignInRequested(email: tEmail, password: tPassword),
      ),
      expect: () => const [
        AuthLoading(),
        AuthError(AuthFailure.invalidCredentials()),
      ],
    );
  });

  group('AuthSignUpRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emite [Loading, Authenticated] no sucesso',
      setUp: () => when(
        () => register(name: tName, email: tEmail, password: tPassword),
      ).thenAnswer((_) async => const Right(tUser)),
      build: buildBloc,
      act: (bloc) => bloc.add(
        const AuthSignUpRequested(
          name: tName,
          email: tEmail,
          password: tPassword,
        ),
      ),
      expect: () => const [AuthLoading(), AuthAuthenticated(tUser)],
    );

    blocTest<AuthBloc, AuthState>(
      'emite [Loading, Error] na falha',
      setUp: () => when(
        () => register(name: tName, email: tEmail, password: tPassword),
      ).thenAnswer((_) async => const Left(NetworkFailure())),
      build: buildBloc,
      act: (bloc) => bloc.add(
        const AuthSignUpRequested(
          name: tName,
          email: tEmail,
          password: tPassword,
        ),
      ),
      expect: () => const [AuthLoading(), AuthError(NetworkFailure())],
    );
  });

  blocTest<AuthBloc, AuthState>(
    'AuthSignOutRequested emite Unauthenticated',
    build: buildBloc,
    seed: () => const AuthAuthenticated(tUser),
    act: (bloc) => bloc.add(const AuthSignOutRequested()),
    expect: () => const [AuthUnauthenticated()],
  );
}
