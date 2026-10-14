import 'package:equatable/equatable.dart';
import 'package:my_car/features/vehicles/domain/entities/vehicle.dart';

sealed class VehiclesState extends Equatable {
  const VehiclesState();

  @override
  List<Object?> get props => [];
}

final class VehiclesLoading extends VehiclesState {
  const VehiclesLoading();
}

final class VehiclesLoaded extends VehiclesState {
  final List<Vehicle> vehicles;

  const VehiclesLoaded(this.vehicles);

  @override
  List<Object?> get props => [vehicles];
}

final class VehiclesEmpty extends VehiclesState {
  const VehiclesEmpty();
}

/// [vehicles] guarda a última lista carregada, para que uma falha ao
/// recarregar ou remover não apague o que já estava na tela.
final class VehiclesFailure extends VehiclesState {
  final String message;
  final List<Vehicle> vehicles;

  const VehiclesFailure(this.message, {this.vehicles = const []});

  @override
  List<Object?> get props => [message, vehicles];
}
