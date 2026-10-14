import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_car/features/vehicles/domain/usecases/create_vehicle_usecase.dart';
import 'package:my_car/features/vehicles/domain/usecases/update_vehicle_usecase.dart';
import 'package:my_car/features/vehicles/presentation/bloc/vehicle_form_event.dart';
import 'package:my_car/features/vehicles/presentation/bloc/vehicle_form_state.dart';

class VehicleFormBloc extends Bloc<VehicleFormEvent, VehicleFormState> {
  final CreateVehicleUseCase _createVehicle;
  final UpdateVehicleUseCase _updateVehicle;

  VehicleFormBloc({
    required CreateVehicleUseCase createVehicle,
    required UpdateVehicleUseCase updateVehicle,
  })  : _createVehicle = createVehicle,
        _updateVehicle = updateVehicle,
        super(const VehicleFormInitial()) {
    on<VehicleFormSubmitted>(_onSubmitted);
  }

  Future<void> _onSubmitted(
    VehicleFormSubmitted event,
    Emitter<VehicleFormState> emit,
  ) async {
    emit(const VehicleFormSubmitting());
    final id = event.id;
    final result = id == null
        ? await _createVehicle(event.input)
        : await _updateVehicle(id: id, input: event.input);
    result.fold(
      onLeft: (failure) => emit(VehicleFormFailure(failure.message)),
      onRight: (vehicle) => emit(VehicleFormSuccess(vehicle)),
    );
  }
}
