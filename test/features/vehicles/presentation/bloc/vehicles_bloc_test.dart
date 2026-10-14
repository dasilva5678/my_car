import 'dart:async';

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_car/core/either/either.dart';
import 'package:my_car/core/error/failures.dart';
import 'package:my_car/features/vehicles/domain/usecases/delete_vehicle_usecase.dart';
import 'package:my_car/features/vehicles/domain/usecases/get_vehicles_usecase.dart';
import 'package:my_car/features/vehicles/presentation/bloc/vehicles_bloc.dart';
import 'package:my_car/features/vehicles/presentation/bloc/vehicles_event.dart';
import 'package:my_car/features/vehicles/presentation/bloc/vehicles_state.dart';

import '../../../../helpers/fixtures.dart';

class _MockGetVehicles extends Mock implements GetVehiclesUseCase {}

class _MockDeleteVehicle extends Mock implements DeleteVehicleUseCase {}

void main() {
  late _MockGetVehicles getVehicles;
  late _MockDeleteVehicle deleteVehicle;

  setUp(() {
    getVehicles = _MockGetVehicles();
    deleteVehicle = _MockDeleteVehicle();
  });

  VehiclesBloc buildBloc() =>
      VehiclesBloc(getVehicles: getVehicles, deleteVehicle: deleteVehicle);

  test('estado inicial é VehiclesLoading', () {
    expect(buildBloc().state, const VehiclesLoading());
  });

  group('VehiclesRequested', () {
    blocTest<VehiclesBloc, VehiclesState>(
      'emite Loaded com a lista',
      setUp: () => when(() => getVehicles())
          .thenAnswer((_) async => const Right([tVehicle])),
      build: buildBloc,
      act: (bloc) => bloc.add(const VehiclesRequested()),
      expect: () => const [
        VehiclesLoaded([tVehicle]),
      ],
    );

    blocTest<VehiclesBloc, VehiclesState>(
      'emite Empty quando não há veículos',
      setUp: () =>
          when(() => getVehicles()).thenAnswer((_) async => const Right([])),
      build: buildBloc,
      act: (bloc) => bloc.add(const VehiclesRequested()),
      expect: () => const [VehiclesEmpty()],
    );

    blocTest<VehiclesBloc, VehiclesState>(
      'emite Failure com a mensagem da Failure',
      setUp: () => when(() => getVehicles())
          .thenAnswer((_) async => const Left(NetworkFailure())),
      build: buildBloc,
      act: (bloc) => bloc.add(const VehiclesRequested()),
      expect: () => [VehiclesFailure(const NetworkFailure().message)],
    );

    blocTest<VehiclesBloc, VehiclesState>(
      'volta para Loading ao tentar novamente após falha sem lista',
      setUp: () => when(() => getVehicles())
          .thenAnswer((_) async => const Right([tVehicle])),
      build: buildBloc,
      seed: () => const VehiclesFailure('erro'),
      act: (bloc) => bloc.add(const VehiclesRequested()),
      expect: () => const [
        VehiclesLoading(),
        VehiclesLoaded([tVehicle]),
      ],
    );

    blocTest<VehiclesBloc, VehiclesState>(
      'recarrega sem Loading quando já há lista na tela',
      setUp: () => when(() => getVehicles())
          .thenAnswer((_) async => const Right([tVehicle, tOtherVehicle])),
      build: buildBloc,
      seed: () => const VehiclesLoaded([tVehicle]),
      act: (bloc) => bloc.add(const VehiclesRequested()),
      expect: () => const [
        VehiclesLoaded([tVehicle, tOtherVehicle]),
      ],
    );

    blocTest<VehiclesBloc, VehiclesState>(
      'mantém a lista atual quando recarregar falha',
      setUp: () => when(() => getVehicles())
          .thenAnswer((_) async => const Left(TimeoutFailure())),
      build: buildBloc,
      seed: () => const VehiclesLoaded([tVehicle]),
      act: (bloc) => bloc.add(const VehiclesRequested()),
      expect: () => [
        VehiclesFailure(
          const TimeoutFailure().message,
          vehicles: const [tVehicle],
        ),
      ],
    );

    test('conclui o completer mesmo sem mudança de estado', () async {
      when(() => getVehicles())
          .thenAnswer((_) async => const Right([tVehicle]));
      final bloc = buildBloc()..add(const VehiclesRequested());
      await bloc.stream.first;

      final completer = Completer<void>();
      bloc.add(VehiclesRequested(completer: completer));

      await expectLater(completer.future, completes);
      await bloc.close();
    });
  });

  group('VehicleDeleted', () {
    blocTest<VehiclesBloc, VehiclesState>(
      'remove o veículo da lista',
      setUp: () => when(() => deleteVehicle(tVehicleId))
          .thenAnswer((_) async => const Right(null)),
      build: buildBloc,
      seed: () => const VehiclesLoaded([tVehicle, tOtherVehicle]),
      act: (bloc) => bloc.add(const VehicleDeleted(tVehicleId)),
      expect: () => const [
        VehiclesLoaded([tOtherVehicle]),
      ],
      verify: (_) => verify(() => deleteVehicle(tVehicleId)).called(1),
    );

    blocTest<VehiclesBloc, VehiclesState>(
      'emite Empty ao remover o último veículo',
      setUp: () => when(() => deleteVehicle(tVehicleId))
          .thenAnswer((_) async => const Right(null)),
      build: buildBloc,
      seed: () => const VehiclesLoaded([tVehicle]),
      act: (bloc) => bloc.add(const VehicleDeleted(tVehicleId)),
      expect: () => const [VehiclesEmpty()],
    );

    blocTest<VehiclesBloc, VehiclesState>(
      'emite Failure mantendo a lista quando a remoção falha',
      setUp: () => when(() => deleteVehicle(tVehicleId))
          .thenAnswer((_) async => const Left(ServerFailure())),
      build: buildBloc,
      seed: () => const VehiclesLoaded([tVehicle]),
      act: (bloc) => bloc.add(const VehicleDeleted(tVehicleId)),
      expect: () => [
        VehiclesFailure(
          const ServerFailure().message,
          vehicles: const [tVehicle],
        ),
      ],
    );

    for (final success in [true, false]) {
      test('completer recebe $success', () async {
        when(() => deleteVehicle(tVehicleId)).thenAnswer(
          (_) async =>
              success ? const Right(null) : const Left(NetworkFailure()),
        );
        final completer = Completer<bool>();
        final bloc = buildBloc()
          ..add(VehicleDeleted(tVehicleId, completer: completer));

        expect(await completer.future, success);
        await bloc.close();
      });
    }
  });
}
