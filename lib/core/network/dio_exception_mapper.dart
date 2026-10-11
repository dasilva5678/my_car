import 'package:dio/dio.dart';
import 'package:my_car/core/error/exceptions.dart';

/// Único ponto do app que conhece [DioException]. Converte erros de
/// transporte em [AppException], mantendo o Dio isolado na camada de rede.
abstract final class DioExceptionMapper {
  static AppException map(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.transformTimeout:
        return const RequestTimeoutException();
      case DioExceptionType.connectionError:
        return const NetworkException();
      case DioExceptionType.badResponse:
      case DioExceptionType.badCertificate:
      case DioExceptionType.cancel:
      case DioExceptionType.unknown:
        final response = error.response;
        if (response == null) return const NetworkException();
        return ServerException(
          statusCode: response.statusCode,
          message: extractMessage(response.data),
        );
    }
  }

  /// Procura a mensagem de erro nos formatos mais comuns de resposta:
  /// `"texto"`, `{message}`, `{error}`, `{error: {...}}`, `{data: {...}}`.
  static String? extractMessage(dynamic data) {
    if (data is String) return data.trim().isEmpty ? null : data;
    if (data is! Map) return null;

    for (final key in const ['message', 'error', 'data']) {
      final value = data[key];
      if (value is String && value.trim().isNotEmpty) return value;
      if (value is Map) {
        final nested = extractMessage(value);
        if (nested != null) return nested;
      }
    }
    return null;
  }
}
