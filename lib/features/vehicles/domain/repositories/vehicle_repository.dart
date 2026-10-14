import 'package:my_car/core/either/either.dart';
import 'package:my_car/core/error/failures.dart';
import 'package:my_car/features/vehicles/domain/entities/vehicle.dart';
import 'package:my_car/features/vehicles/domain/entities/vehicle_input.dart';

abstract interface class VehicleRepository {
  /// Veículos do usuário logado.
  Future<Either<Failure, List<Vehicle>>> getVehicles();

  Future<Either<Failure, Vehicle>> createVehicle(VehicleInput input);

  Future<Either<Failure, Vehicle>> updateVehicle({
    required String id,
    required VehicleInput input,
  });

  Future<Either<Failure, void>> deleteVehicle(String id);
}
