import 'package:my_car/core/either/either.dart';
import 'package:my_car/core/error/failures.dart';
import 'package:my_car/features/vehicles/domain/repositories/vehicle_repository.dart';

class DeleteVehicleUseCase {
  final VehicleRepository _repository;

  const DeleteVehicleUseCase(this._repository);

  /// Remove o veículo e, no servidor, todo o histórico ligado a ele.
  Future<Either<Failure, void>> call(String id) =>
      _repository.deleteVehicle(id);
}
