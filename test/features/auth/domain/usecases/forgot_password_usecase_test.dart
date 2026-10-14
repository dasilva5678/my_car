import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_car/core/either/either.dart';
import 'package:my_car/core/error/failures.dart';
import 'package:my_car/features/auth/domain/repositories/auth_repository.dart';
import 'package:my_car/features/auth/domain/usecases/forgot_password_usecase.dart';

import '../../../../helpers/fixtures.dart';

class _MockRepository extends Mock implements AuthRepository {}

void main() {
  late _MockRepository repository;
  late ForgotPasswordUseCase useCase;

  setUp(() {
    repository = _MockRepository();
    useCase = ForgotPasswordUseCase(repository);
  });

  Failure? leftOf(Either<Failure, void> result) =>
      result.fold(onLeft: (f) => f, onRight: (_) => null);

  test('delega ao repositório quando o e-mail é válido', () async {
    when(() => repository.forgotPassword(email: tEmail))
        .thenAnswer((_) async => const Right(null));

    final result = await useCase(email: tEmail);

    expect(result.isRight, isTrue);
    verify(() => repository.forgotPassword(email: tEmail)).called(1);
  });

  test('propaga a Failure do repositório', () async {
    when(() => repository.forgotPassword(email: tEmail))
        .thenAnswer((_) async => const Left(NetworkFailure()));

    expect(leftOf(await useCase(email: tEmail)), const NetworkFailure());
  });

  test('e-mail vazio retorna ValidationFailure sem chamar o repositório',
      () async {
    final result = await useCase(email: ' ');

    expect(leftOf(result), const ValidationFailure('Informe seu e-mail.'));
    verifyZeroInteractions(repository);
  });

  test('e-mail inválido retorna ValidationFailure sem chamar o repositório',
      () async {
    final result = await useCase(email: 'invalido');

    expect(
        leftOf(result), const ValidationFailure('Informe um e-mail válido.'));
    verifyZeroInteractions(repository);
  });
}
