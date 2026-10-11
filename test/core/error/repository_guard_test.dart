import 'package:flutter_test/flutter_test.dart';
import 'package:my_car/core/either/either.dart';
import 'package:my_car/core/error/exceptions.dart';
import 'package:my_car/core/error/failures.dart';
import 'package:my_car/core/error/repository_guard.dart';

class _Repository with RepositoryGuard {}

void main() {
  final repository = _Repository();

  Future<Failure?> failureOf(Object error) async {
    final result = await repository.guard<int>(() async => throw error);
    return result.fold(onLeft: (f) => f, onRight: (_) => null);
  }

  test('retorna Right com o valor quando a ação tem sucesso', () async {
    final result = await repository.guard(() async => 42);

    expect(result, isA<Right<Failure, int>>());
    expect(result.fold(onLeft: (_) => null, onRight: (v) => v), 42);
  });

  test('mapeia cada AppException para a Failure correspondente', () async {
    expect(await failureOf(const NetworkException()), const NetworkFailure());
    expect(
      await failureOf(const RequestTimeoutException()),
      const TimeoutFailure(),
    );
    expect(
      await failureOf(const ParseException()),
      const InvalidResponseFailure(),
    );
    expect(await failureOf(const CacheException()), const CacheFailure());
    expect(
      await failureOf(const ServerException(statusCode: 500, message: 'x')),
      const ServerFailure(statusCode: 500, message: 'x'),
    );
  });

  test('ServerFailure sem mensagem usa o texto padrão', () async {
    final failure = await failureOf(const ServerException(statusCode: 500));

    expect(failure?.message, const ServerFailure().message);
  });

  test('erro desconhecido vira UnexpectedFailure', () async {
    expect(await failureOf(StateError('boom')), const UnexpectedFailure());
  });
}
