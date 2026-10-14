/// Token de acesso da sessão atual, mantido só em memória.
///
/// Preenchido pelo login e lido pelo `AuthInterceptor`. Quando houver
/// sessão persistida, trocar a implementação por um armazenamento seguro.
class AuthTokenStore {
  String? _token;

  String? get token => _token;

  void save(String? token) => _token = token;

  void clear() => _token = null;
}
