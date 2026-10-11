import 'package:my_car/core/error/failures.dart';

/// Falhas de regra de negócio da autenticação. Falhas genéricas
/// (rede, timeout, servidor...) usam as classes de `core/error/failures.dart`.
final class AuthFailure extends Failure {
  const AuthFailure.invalidCredentials() : super('E-mail ou senha incorretos.');

  const AuthFailure.userAlreadyExists()
      : super('Já existe uma conta com este e-mail.');
}
