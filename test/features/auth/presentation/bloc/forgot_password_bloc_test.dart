import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_car/core/either/either.dart';
import 'package:my_car/core/error/failures.dart';
import 'package:my_car/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:my_car/features/auth/presentation/bloc/forgot_password_bloc.dart';
import 'package:my_car/features/auth/presentation/bloc/forgot_password_event.dart';
import 'package:my_car/features/auth/presentation/bloc/forgot_password_state.dart';

import '../../../../helpers/fixtures.dart';

class _MockForgotPassword extends Mock implements ForgotPasswordUseCase {}

void main() {
  late _MockForgotPassword forgotPassword;

  setUp(() => forgotPassword = _MockForgotPassword());

  ForgotPasswordBloc buildBloc() =>
      ForgotPasswordBloc(forgotPassword: forgotPassword);

  void stubSuccess() => when(() => forgotPassword(email: tEmail))
      .thenAnswer((_) async => const Right(null));

  test('estado inicial é ForgotPasswordInitial', () {
    expect(buildBloc().state, const ForgotPasswordInitial());
  });

  group('ForgotPasswordSubmitted', () {
    blocTest<ForgotPasswordBloc, ForgotPasswordState>(
      'emite [Loading, Success] com o e-mail no sucesso',
      setUp: stubSuccess,
      build: buildBloc,
      act: (bloc) => bloc.add(const ForgotPasswordSubmitted(tEmail)),
      expect: () => const [
        ForgotPasswordLoading(),
        ForgotPasswordSuccess(tEmail),
      ],
    );

    blocTest<ForgotPasswordBloc, ForgotPasswordState>(
      'remove espaços do e-mail antes de enviar',
      setUp: stubSuccess,
      build: buildBloc,
      act: (bloc) => bloc.add(const ForgotPasswordSubmitted('  $tEmail ')),
      expect: () => const [
        ForgotPasswordLoading(),
        ForgotPasswordSuccess(tEmail),
      ],
      verify: (_) => verify(() => forgotPassword(email: tEmail)).called(1),
    );

    blocTest<ForgotPasswordBloc, ForgotPasswordState>(
      'emite [Loading, Failure] com a mensagem da Failure',
      setUp: () => when(() => forgotPassword(email: tEmail))
          .thenAnswer((_) async => const Left(NetworkFailure())),
      build: buildBloc,
      act: (bloc) => bloc.add(const ForgotPasswordSubmitted(tEmail)),
      expect: () => [
        const ForgotPasswordLoading(),
        ForgotPasswordFailure(const NetworkFailure().message),
      ],
    );

    blocTest<ForgotPasswordBloc, ForgotPasswordState>(
      'permite reenviar após uma falha',
      setUp: stubSuccess,
      build: buildBloc,
      seed: () => const ForgotPasswordFailure('erro'),
      act: (bloc) => bloc.add(const ForgotPasswordSubmitted(tEmail)),
      expect: () => const [
        ForgotPasswordLoading(),
        ForgotPasswordSuccess(tEmail),
      ],
    );
  });
}
