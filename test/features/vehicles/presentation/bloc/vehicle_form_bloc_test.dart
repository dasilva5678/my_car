import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_car/core/either/either.dart';
import 'package:my_car/core/error/failures.dart';
import 'package:my_car/features/vehicles/domain/failures/vehicle_failure.dart';
import 'package:my_car/features/vehicles/domain/usecases/create_vehicle_usecase.dart';
import 'package:my_car/features/vehicles/domain/usecases/update_vehicle_usecase.dart';
import 'package:my_car/features/vehicles/presentation/bloc/vehicle_form_bloc.dart';
import 'package:my_car/features/vehicles/presentation/bloc/vehicle_form_event.dart';
import 'package:my_car/features/vehicles/presentation/bloc/vehicle_form_state.dart';

import '../../../../helpers/fixtures.dart';

class _MockCreateVehicle extends Mock implements CreateVehicleUseCase {}

class _MockUpdateVehicle extends Mock implements UpdateVehicleUseCase {}

void main() {
  late _MockCreateVehicle createVehicle;
  late _MockUpdateVehicle updateVehicle;

  setUp(() {
    createVehicle = _MockCreateVehicle();
    updateVehicle = _MockUpdateVehicle();
  });

  VehicleFormBloc buildBloc() => VehicleFormBloc(
        createVehicle: createVehicle,
        updateVehicle: updateVehicle,
      );

  test('estado inicial é VehicleFormInitial', () {
    expect(buildBloc().state, const VehicleFormInitial());
  });

  group('VehicleFormSubmitted sem id (cadastro)', () {
    blocTest<VehicleFormBloc, VehicleFormState>(
      'emite [Submitting, Success] e não chama a atualização',
      setUp: () => when(() => createVehicle(tVehicleInput))
          .thenAnswer((_) async => const Right(tVehicle)),
      build: buildBloc,
      act: (bloc) => bloc.add(const VehicleFormSubmitted(tVehicleInput)),
      expect: () => const [
        VehicleFormSubmitting(),
        VehicleFormSuccess(tVehicle),
      ],
      verify: (_) => verifyZeroInteractions(updateVehicle),
    );

    blocTest<VehicleFormBloc, VehicleFormState>(
      'emite [Submitting, Failure] com a mensagem da Failure',
      setUp: () => when(() => createVehicle(tVehicleInput)).thenAnswer(
        (_) async => const Left(VehicleFailure.plateAlreadyExists()),
      ),
      build: buildBloc,
      act: (bloc) => bloc.add(const VehicleFormSubmitted(tVehicleInput)),
      expect: () => [
        const VehicleFormSubmitting(),
        VehicleFormFailure(const VehicleFailure.plateAlreadyExists().message),
      ],
    );
  });

  group('VehicleFormSubmitted com id (edição)', () {
    blocTest<VehicleFormBloc, VehicleFormState>(
      'emite [Submitting, Success] e não chama o cadastro',
      setUp: () => when(
        () => updateVehicle(id: tVehicleId, input: tVehicleInput),
      ).thenAnswer((_) async => const Right(tVehicle)),
      build: buildBloc,
      act: (bloc) => bloc.add(
        const VehicleFormSubmitted(tVehicleInput, id: tVehicleId),
      ),
      expect: () => const [
        VehicleFormSubmitting(),
        VehicleFormSuccess(tVehicle),
      ],
      verify: (_) => verifyZeroInteractions(createVehicle),
    );

    blocTest<VehicleFormBloc, VehicleFormState>(
      'permite reenviar após uma falha',
      setUp: () => when(
        () => updateVehicle(id: tVehicleId, input: tVehicleInput),
      ).thenAnswer((_) async => const Left(NetworkFailure())),
      build: buildBloc,
      seed: () => const VehicleFormFailure('erro'),
      act: (bloc) => bloc.add(
        const VehicleFormSubmitted(tVehicleInput, id: tVehicleId),
      ),
      expect: () => [
        const VehicleFormSubmitting(),
        VehicleFormFailure(const NetworkFailure().message),
      ],
    );
  });
}
