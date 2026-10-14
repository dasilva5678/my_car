/// Configuração da API. Sobrescreva a URL sem alterar código:
/// `flutter run --dart-define=API_BASE_URL=http://10.0.2.2:8080`
/// (10.0.2.2 é o `localhost` da máquina visto pelo emulador Android).
abstract final class ApiConfig {
  static const baseUrl = String.fromEnvironment(
    'API_BASE_URL',
    defaultValue: 'http://localhost:8080',
  );
  static const timeout = Duration(seconds: 10);
}

/// Caminhos relativos à [ApiConfig.baseUrl].
abstract final class Endpoints {
  static const login = '/user/login';
  static const forgotPassword = '/auth/forgot-password';
  static const vehicles = '/vehicles';

  static String vehicle(String id) => '/vehicles/$id';
}
