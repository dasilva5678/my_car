import 'package:my_car/core/either/either.dart';
import 'package:my_car/core/error/failures.dart';
import 'package:my_car/features/vehicles/domain/entities/vehicle.dart';
import 'package:my_car/features/vehicles/domain/entities/vehicle_input.dart';
import 'package:my_car/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:my_car/features/vehicles/domain/validators/vehicle_validators.dart';

class UpdateVehicleUseCase {
  final VehicleRepository _repository;

  const UpdateVehicleUseCase(this._repository);

  Future<Either<Failure, Vehicle>> call({
    required String id,
    required VehicleInput input,
  }) async {
    final data = input.normalized();
    final error = VehicleValidators.input(data);
    if (error != null) return Left(ValidationFailure(error));

    return _repository.updateVehicle(id: id, input: data);
  }
}
