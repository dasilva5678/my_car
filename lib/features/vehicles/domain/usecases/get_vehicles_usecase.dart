import 'package:my_car/core/either/either.dart';
import 'package:my_car/core/error/failures.dart';
import 'package:my_car/features/vehicles/domain/entities/vehicle.dart';
import 'package:my_car/features/vehicles/domain/repositories/vehicle_repository.dart';

class GetVehiclesUseCase {
  final VehicleRepository _repository;

  const GetVehiclesUseCase(this._repository);

  Future<Either<Failure, List<Vehicle>>> call() => _repository.getVehicles();
}
