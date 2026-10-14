import 'package:my_car/core/error/failures.dart';

/// Falhas específicas de veículos. Falhas genéricas (rede, timeout,
/// servidor...) usam as classes de `core/error/failures.dart`.
final class VehicleFailure extends Failure {
  const VehicleFailure.notFound() : super('Veículo não encontrado.');

  const VehicleFailure.plateAlreadyExists()
      : super('Já existe um veículo com esta placa ou tag.');

  const VehicleFailure.unauthorized()
      : super('Sua sessão expirou. Entre novamente.');
}
