import 'package:equatable/equatable.dart';

/// Erro já traduzido para a camada de domínio/apresentação.
///
/// Repositórios nunca deixam exceções vazarem: convertem tudo em [Failure]
/// e devolvem via `Either`. Features específicas estendem esta classe
/// (ex.: `AuthFailure`).
abstract class Failure extends Equatable {
  final String message;

  const Failure(this.message);

  @override
  List<Object?> get props => [message];
}

final class NetworkFailure extends Failure {
  const NetworkFailure()
      : super('Sem conexão com o servidor. Verifique sua internet.');
}

final class TimeoutFailure extends Failure {
  const TimeoutFailure()
      : super('O servidor demorou para responder. Tente novamente.');
}

final class ServerFailure extends Failure {
  final int? statusCode;

  const ServerFailure({this.statusCode, String? message})
      : super(message ?? 'Erro no servidor. Tente novamente mais tarde.');

  @override
  List<Object?> get props => [message, statusCode];
}

final class InvalidResponseFailure extends Failure {
  const InvalidResponseFailure()
      : super('O servidor retornou uma resposta inválida.');
}

final class CacheFailure extends Failure {
  const CacheFailure()
      : super('Não foi possível acessar os dados salvos no dispositivo.');
}

final class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

final class UnexpectedFailure extends Failure {
  const UnexpectedFailure()
      : super('Não foi possível concluir a operação. Tente novamente.');
}
