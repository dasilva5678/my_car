import 'package:my_car/core/either/either.dart';
import 'package:my_car/core/error/exceptions.dart';
import 'package:my_car/core/error/failures.dart';
import 'package:my_car/core/error/repository_guard.dart';
import 'package:my_car/features/vehicles/data/datasources/vehicle_remote_datasource.dart';
import 'package:my_car/features/vehicles/data/models/vehicle_model.dart';
import 'package:my_car/features/vehicles/domain/entities/vehicle.dart';
import 'package:my_car/features/vehicles/domain/entities/vehicle_input.dart';
import 'package:my_car/features/vehicles/domain/failures/vehicle_failure.dart';
import 'package:my_car/features/vehicles/domain/repositories/vehicle_repository.dart';

class VehicleRepositoryImpl with RepositoryGuard implements VehicleRepository {
  final VehicleRemoteDataSource _remote;

  const VehicleRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, List<Vehicle>>> getVehicles() => guard(() async {
        final vehicles = await _remote.getVehicles();
        return vehicles.map((vehicle) => vehicle.toEntity()).toList();
      });

  @override
  Future<Either<Failure, Vehicle>> createVehicle(VehicleInput input) =>
      guard(() async {
        final vehicle =
            await _remote.createVehicle(VehicleModel.fromInput(input));
        return vehicle.toEntity();
      });

  @override
  Future<Either<Failure, Vehicle>> updateVehicle({
    required String id,
    required VehicleInput input,
  }) =>
      guard(() async {
        final vehicle = await _remote
            .updateVehicle(VehicleModel.fromInput(input, id: id));
        return vehicle.toEntity();
      });

  @override
  Future<Either<Failure, void>> deleteVehicle(String id) =>
      guard(() => _remote.deleteVehicle(id));

  @override
  Failure mapException(AppException exception) => switch (exception) {
        ServerException(statusCode: 401 || 403) =>
          const VehicleFailure.unauthorized(),
        ServerException(statusCode: 404) => const VehicleFailure.notFound(),
        ServerException(statusCode: 409) =>
          const VehicleFailure.plateAlreadyExists(),
        _ => super.mapException(exception),
      };
}
