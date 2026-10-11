import 'package:dio/dio.dart';
import 'package:my_car/core/error/exceptions.dart';
import 'package:my_car/core/network/dio_exception_mapper.dart';

/// Fachada sobre o [Dio]. Datasources dependem desta classe e só precisam
/// lidar com [AppException]; nenhum `DioException` vaza daqui.
class ApiClient {
  final Dio _dio;

  const ApiClient(this._dio);

  Future<dynamic> get(String path, {Map<String, dynamic>? queryParameters}) =>
      _send(() => _dio.get<dynamic>(path, queryParameters: queryParameters));

  Future<dynamic> post(String path, {Object? data}) =>
      _send(() => _dio.post<dynamic>(path, data: data));

  Future<dynamic> put(String path, {Object? data}) =>
      _send(() => _dio.put<dynamic>(path, data: data));

  Future<dynamic> delete(String path, {Object? data}) =>
      _send(() => _dio.delete<dynamic>(path, data: data));

  Future<dynamic> _send(Future<Response<dynamic>> Function() request) async {
    try {
      final response = await request();
      return response.data;
    } on DioException catch (error) {
      throw DioExceptionMapper.map(error);
    }
  }
}
