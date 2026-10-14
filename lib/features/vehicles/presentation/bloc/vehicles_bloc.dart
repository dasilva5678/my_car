import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_car/features/vehicles/domain/entities/vehicle.dart';
import 'package:my_car/features/vehicles/domain/usecases/delete_vehicle_usecase.dart';
import 'package:my_car/features/vehicles/domain/usecases/get_vehicles_usecase.dart';
import 'package:my_car/features/vehicles/presentation/bloc/vehicles_event.dart';
import 'package:my_car/features/vehicles/presentation/bloc/vehicles_state.dart';

class VehiclesBloc extends Bloc<VehiclesEvent, VehiclesState> {
  final GetVehiclesUseCase _getVehicles;
  final DeleteVehicleUseCase _deleteVehicle;

  VehiclesBloc({
    required GetVehiclesUseCase getVehicles,
    required DeleteVehicleUseCase deleteVehicle,
  })  : _getVehicles = getVehicles,
        _deleteVehicle = deleteVehicle,
        super(const VehiclesLoading()) {
    on<VehiclesRequested>(_onRequested);
    on<VehicleDeleted>(_onDeleted);
  }

  List<Vehicle> get _currentVehicles => switch (state) {
        VehiclesLoaded(:final vehicles) => vehicles,
        VehiclesFailure(:final vehicles) => vehicles,
        _ => const [],
      };

  Future<void> _onRequested(
    VehiclesRequested event,
    Emitter<VehiclesState> emit,
  ) async {
    if (_currentVehicles.isEmpty && state is! VehiclesLoading) {
      emit(const VehiclesLoading());
    }
    final result = await _getVehicles();
    result.fold(
      onLeft: (failure) => emit(
        VehiclesFailure(failure.message, vehicles: _currentVehicles),
      ),
      onRight: (vehicles) => emit(_fromList(vehicles)),
    );
    event.completer?.complete();
  }

  Future<void> _onDeleted(
    VehicleDeleted event,
    Emitter<VehiclesState> emit,
  ) async {
    final result = await _deleteVehicle(event.id);
    result.fold(
      onLeft: (failure) => emit(
        VehiclesFailure(failure.message, vehicles: _currentVehicles),
      ),
      onRight: (_) => emit(
        _fromList(
          _currentVehicles.where((vehicle) => vehicle.id != event.id).toList(),
        ),
      ),
    );
    event.completer?.complete(result.isRight);
  }

  VehiclesState _fromList(List<Vehicle> vehicles) =>
      vehicles.isEmpty ? const VehiclesEmpty() : VehiclesLoaded(vehicles);
}
