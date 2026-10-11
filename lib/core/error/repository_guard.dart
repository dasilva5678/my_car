import 'dart:developer' as developer;

import 'package:my_car/core/either/either.dart';
import 'package:my_car/core/error/exceptions.dart';
import 'package:my_car/core/error/failures.dart';

/// Centraliza o `try/catch` dos repositórios, convertendo exceções em
/// [Failure].
///
/// Para tratar casos específicos de uma feature, sobrescreva
/// [mapException] e delegue o restante para `super.mapException`.
mixin RepositoryGuard {
  Future<Either<Failure, T>> guard<T>(Future<T> Function() action) async {
    try {
      return Right(await action());
    } on AppException catch (exception) {
      return Left(mapException(exception));
    } catch (error, stackTrace) {
      developer.log(
        'Erro inesperado no repositório',
        name: runtimeType.toString(),
        error: error,
        stackTrace: stackTrace,
      );
      return const Left(UnexpectedFailure());
    }
  }

  Failure mapException(AppException exception) => switch (exception) {
        NetworkException() => const NetworkFailure(),
        RequestTimeoutException() => const TimeoutFailure(),
        ServerException(:final statusCode, :final message) =>
          ServerFailure(statusCode: statusCode, message: message),
        ParseException() => const InvalidResponseFailure(),
        CacheException() => const CacheFailure(),
        _ => const UnexpectedFailure(),
      };
}
