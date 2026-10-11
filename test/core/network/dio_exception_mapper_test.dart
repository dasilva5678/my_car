import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_car/core/error/exceptions.dart';
import 'package:my_car/core/network/dio_exception_mapper.dart';

void main() {
  final requestOptions = RequestOptions(path: '/test');

  DioException dioError(DioExceptionType type, {Response<dynamic>? response}) =>
      DioException(
        requestOptions: requestOptions,
        type: type,
        response: response,
      );

  Response<dynamic> response(int statusCode, dynamic data) => Response(
        requestOptions: requestOptions,
        statusCode: statusCode,
        data: data,
      );

  group('DioExceptionMapper.map', () {
    for (final type in [
      DioExceptionType.connectionTimeout,
      DioExceptionType.sendTimeout,
      DioExceptionType.receiveTimeout,
      DioExceptionType.transformTimeout,
    ]) {
      test('$type -> RequestTimeoutException', () {
        expect(
          DioExceptionMapper.map(dioError(type)),
          isA<RequestTimeoutException>(),
        );
      });
    }

    test('connectionError -> NetworkException', () {
      expect(
        DioExceptionMapper.map(dioError(DioExceptionType.connectionError)),
        isA<NetworkException>(),
      );
    });

    test('unknown sem resposta -> NetworkException', () {
      expect(
        DioExceptionMapper.map(dioError(DioExceptionType.unknown)),
        isA<NetworkException>(),
      );
    });

    test('badResponse -> ServerException com status e mensagem da API', () {
      final result = DioExceptionMapper.map(
        dioError(
          DioExceptionType.badResponse,
          response: response(400, {'message': 'E-mail inválido'}),
        ),
      );

      expect(
        result,
        isA<ServerException>()
            .having((e) => e.statusCode, 'statusCode', 400)
            .having((e) => e.message, 'message', 'E-mail inválido'),
      );
    });
  });

  group('DioExceptionMapper.extractMessage', () {
    test('lê texto puro', () {
      expect(DioExceptionMapper.extractMessage('Falhou'), 'Falhou');
    });

    test('lê message, error e estruturas aninhadas', () {
      expect(DioExceptionMapper.extractMessage({'message': 'a'}), 'a');
      expect(DioExceptionMapper.extractMessage({'error': 'b'}), 'b');
      expect(
        DioExceptionMapper.extractMessage({
          'error': {'message': 'c'},
        }),
        'c',
      );
      expect(
        DioExceptionMapper.extractMessage({
          'data': {'error': 'd'},
        }),
        'd',
      );
    });

    test('retorna null quando não há mensagem', () {
      expect(DioExceptionMapper.extractMessage(null), isNull);
      expect(DioExceptionMapper.extractMessage('  '), isNull);
      expect(DioExceptionMapper.extractMessage({'code': 1}), isNull);
    });
  });
}
