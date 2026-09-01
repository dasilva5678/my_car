import '../../../core/error/app_failure.dart';

final class AuthFailure extends AppFailure {
  const AuthFailure(super.message);

  const AuthFailure.invalidFields()
      : super('Preencha todos os campos obrigatórios.');

  const AuthFailure.userAlreadyExists()
      : super('Já existe uma conta com este e-mail.');

  const AuthFailure.network() : super('Não foi possível conectar ao servidor.');

  const AuthFailure.invalidResponse()
      : super('O servidor retornou uma resposta inválida.');

  const AuthFailure.unexpected()
      : super('Não foi possível concluir a operação. Tente novamente.');
}
