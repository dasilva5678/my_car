import 'package:equatable/equatable.dart';
import 'package:my_car/features/vehicles/domain/entities/vehicle_input.dart';

sealed class VehicleFormEvent extends Equatable {
  const VehicleFormEvent();

  @override
  List<Object?> get props => [];
}

/// Cadastra o veículo, ou atualiza quando [id] é informado.
final class VehicleFormSubmitted extends VehicleFormEvent {
  final VehicleInput input;
  final String? id;

  const VehicleFormSubmitted(this.input, {this.id});

  bool get isEditing => id != null;

  @override
  List<Object?> get props => [input, id];
}
