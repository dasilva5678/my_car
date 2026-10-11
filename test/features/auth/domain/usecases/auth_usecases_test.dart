import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_car/core/either/either.dart';
import 'package:my_car/core/error/failures.dart';
import 'package:my_car/features/auth/domain/entities/app_user.dart';
import 'package:my_car/features/auth/domain/repositories/auth_repository.dart';
import 'package:my_car/features/auth/domain/usecases/register_usecase.dart';
import 'package:my_car/features/auth/domain/usecases/sign_in_usecase.dart';

import '../../../../helpers/fixtures.dart';

class _MockRepository extends Mock implements AuthRepository {}

void main() {
  late _MockRepository repository;

  setUp(() => repository = _MockRepository());

  Failure? leftOf(Either<Failure, AppUser> result) =>
      result.fold(onLeft: (f) => f, onRight: (_) => null);

  group('SignInUseCase', () {
    test('delega ao repositório quando os dados são válidos', () async {
      when(() => repository.signIn(email: tEmail, password: tPassword))
          .thenAnswer((_) async => const Right(tUser));

      final result =
          await SignInUseCase(repository)(email: tEmail, password: tPassword);

      expect(result.isRight, isTrue);
      verify(() => repository.signIn(email: tEmail, password: tPassword))
          .called(1);
    });

    test('retorna ValidationFailure sem chamar o repositório', () async {
      final result =
          await SignInUseCase(repository)(email: 'invalido', password: '');

      expect(
          leftOf(result), const ValidationFailure('Informe um e-mail válido.'));
      verifyZeroInteractions(repository);
    });
  });

  group('RegisterUseCase', () {
    test('delega ao repositório quando os dados são válidos', () async {
      when(
        () => repository.register(
          name: tName,
          email: tEmail,
          password: tPassword,
        ),
      ).thenAnswer((_) async => const Right(tUser));

      final result = await RegisterUseCase(repository)(
        name: tName,
        email: tEmail,
        password: tPassword,
      );

      expect(result.isRight, isTrue);
    });

    test('exige senha com tamanho mínimo', () async {
      final result = await RegisterUseCase(repository)(
        name: tName,
        email: tEmail,
        password: '123',
      );

      expect(
        leftOf(result),
        const ValidationFailure('A senha deve ter pelo menos 6 caracteres.'),
      );
      verifyZeroInteractions(repository);
    });

    test('exige nome', () async {
      final result = await RegisterUseCase(repository)(
        name: ' ',
        email: tEmail,
        password: tPassword,
      );

      expect(leftOf(result), const ValidationFailure('Informe seu nome.'));
    });
  });
}
