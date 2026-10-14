import 'package:dio/dio.dart';
import 'package:my_car/core/network/auth_token_store.dart';

/// Envia `Authorization: Bearer <token>` em toda requisição quando há
/// sessão ativa.
class AuthInterceptor extends Interceptor {
  final AuthTokenStore _tokenStore;

  AuthInterceptor(this._tokenStore);

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    final token = _tokenStore.token;
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }
}
