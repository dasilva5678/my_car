import 'package:equatable/equatable.dart';
import 'package:my_car/features/vehicles/domain/entities/vehicle.dart';

sealed class VehicleFormState extends Equatable {
  const VehicleFormState();

  @override
  List<Object?> get props => [];
}

final class VehicleFormInitial extends VehicleFormState {
  const VehicleFormInitial();
}

final class VehicleFormSubmitting extends VehicleFormState {
  const VehicleFormSubmitting();
}

final class VehicleFormSuccess extends VehicleFormState {
  final Vehicle vehicle;

  const VehicleFormSuccess(this.vehicle);

  @override
  List<Object?> get props => [vehicle];
}

final class VehicleFormFailure extends VehicleFormState {
  final String message;

  const VehicleFormFailure(this.message);

  @override
  List<Object?> get props => [message];
}
