import 'package:my_car/core/either/either.dart';
import 'package:my_car/core/error/failures.dart';
import 'package:my_car/features/vehicles/domain/entities/vehicle.dart';
import 'package:my_car/features/vehicles/domain/entities/vehicle_input.dart';
import 'package:my_car/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:my_car/features/vehicles/domain/validators/vehicle_validators.dart';

class CreateVehicleUseCase {
  final VehicleRepository _repository;

  const CreateVehicleUseCase(this._repository);

  Future<Either<Failure, Vehicle>> call(VehicleInput input) async {
    final data = input.normalized();
    final error = VehicleValidators.input(data);
    if (error != null) return Left(ValidationFailure(error));

    return _repository.createVehicle(data);
  }
}
