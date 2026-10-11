/// Exceções lançadas pela camada de dados (datasources / ApiClient).
///
/// Nunca devem chegar à apresentação: o `RepositoryGuard` as converte
/// em `Failure`. Features podem estender [AppException] para casos próprios.
abstract class AppException implements Exception {
  final String? message;

  const AppException([this.message]);

  @override
  String toString() => '$runtimeType(${message ?? ''})';
}

final class NetworkException extends AppException {
  const NetworkException();
}

final class RequestTimeoutException extends AppException {
  const RequestTimeoutException();
}

final class ServerException extends AppException {
  final int? statusCode;

  const ServerException({this.statusCode, String? message}) : super(message);
}

final class ParseException extends AppException {
  const ParseException([super.message]);
}

final class CacheException extends AppException {
  const CacheException([super.message]);
}
