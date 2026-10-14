import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_car/core/either/either.dart';
import 'package:my_car/core/error/failures.dart';
import 'package:my_car/features/vehicles/domain/entities/vehicle.dart';
import 'package:my_car/features/vehicles/domain/entities/vehicle_input.dart';
import 'package:my_car/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:my_car/features/vehicles/domain/usecases/create_vehicle_usecase.dart';
import 'package:my_car/features/vehicles/domain/usecases/delete_vehicle_usecase.dart';
import 'package:my_car/features/vehicles/domain/usecases/get_vehicles_usecase.dart';
import 'package:my_car/features/vehicles/domain/usecases/update_vehicle_usecase.dart';

import '../../../../helpers/fixtures.dart';

class _MockRepository extends Mock implements VehicleRepository {}

VehicleInput _inputWith({
  String name = 'Carro do dia a dia',
  String model = 'Civic',
  String plate = 'ABC1D23',
  int? year = 2020,
  int currentKm = 45000,
}) =>
    VehicleInput(
      name: name,
      brand: 'Honda',
      model: model,
      year: year,
      plate: plate,
      currentKm: currentKm,
    );

void main() {
  late _MockRepository repository;

  setUpAll(() => registerFallbackValue(tVehicleInput));

  setUp(() => repository = _MockRepository());

  Failure? leftOf(Either<Failure, Vehicle> result) =>
      result.fold(onLeft: (f) => f, onRight: (_) => null);

  group('GetVehiclesUseCase', () {
    test('delega ao repositório', () async {
      when(() => repository.getVehicles())
          .thenAnswer((_) async => const Right([tVehicle]));

      final result = await GetVehiclesUseCase(repository)();

      expect(
        result.fold(onLeft: (_) => null, onRight: (list) => list),
        [tVehicle],
      );
    });

    test('repassa a Failure do repositório', () async {
      when(() => repository.getVehicles())
          .thenAnswer((_) async => const Left(NetworkFailure()));

      final result = await GetVehiclesUseCase(repository)();

      expect(
        result.fold(onLeft: (f) => f, onRight: (_) => null),
        const NetworkFailure(),
      );
    });
  });

  group('CreateVehicleUseCase', () {
    test('normaliza os dados antes de enviar', () async {
      when(() => repository.createVehicle(any()))
          .thenAnswer((_) async => const Right(tVehicle));

      final result = await CreateVehicleUseCase(repository)(
        _inputWith(name: '  Carro do dia a dia ', plate: ' abc1d23 '),
      );

      expect(result.isRight, isTrue);
      verify(() => repository.createVehicle(tVehicleInput)).called(1);
    });

    for (final entry in {
      'Informe um apelido': _inputWith(name: ' '),
      'Informe o modelo': _inputWith(model: ''),
      'Informe a placa ou tag': _inputWith(plate: '  '),
      'Informe um ano válido': _inputWith(year: 1800),
      'Informe uma quilometragem válida': _inputWith(currentKm: -1),
    }.entries) {
      test('retorna ValidationFailure "${entry.key}"', () async {
        final result = await CreateVehicleUseCase(repository)(entry.value);

        expect(leftOf(result), ValidationFailure(entry.key));
        verifyZeroInteractions(repository);
      });
    }

    test('aceita ano vazio', () async {
      when(() => repository.createVehicle(any()))
          .thenAnswer((_) async => const Right(tVehicle));

      final result =
          await CreateVehicleUseCase(repository)(_inputWith(year: null));

      expect(result.isRight, isTrue);
    });
  });

  group('UpdateVehicleUseCase', () {
    test('delega ao repositório com o id e os dados normalizados', () async {
      when(
        () => repository.updateVehicle(
          id: any(named: 'id'),
          input: any(named: 'input'),
        ),
      ).thenAnswer((_) async => const Right(tVehicle));

      final result = await UpdateVehicleUseCase(repository)(
        id: tVehicleId,
        input: _inputWith(plate: 'abc1d23'),
      );

      expect(result.isRight, isTrue);
      verify(
        () => repository.updateVehicle(id: tVehicleId, input: tVehicleInput),
      ).called(1);
    });

    test('retorna ValidationFailure sem chamar o repositório', () async {
      final result = await UpdateVehicleUseCase(repository)(
        id: tVehicleId,
        input: _inputWith(model: ' '),
      );

      expect(leftOf(result), const ValidationFailure('Informe o modelo'));
      verifyZeroInteractions(repository);
    });
  });

  group('DeleteVehicleUseCase', () {
    test('delega ao repositório', () async {
      when(() => repository.deleteVehicle(tVehicleId))
          .thenAnswer((_) async => const Right(null));

      final result = await DeleteVehicleUseCase(repository)(tVehicleId);

      expect(result.isRight, isTrue);
      verify(() => repository.deleteVehicle(tVehicleId)).called(1);
    });
  });
}
