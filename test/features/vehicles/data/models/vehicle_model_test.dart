import 'package:flutter_test/flutter_test.dart';
import 'package:my_car/features/vehicles/data/models/vehicle_model.dart';
import 'package:my_car/features/vehicles/domain/entities/vehicle.dart';

import '../../../../helpers/fixtures.dart';

void main() {
  group('fromMap', () {
    test('lê os campos básicos e deixa a placa em maiúsculas', () {
      final model = VehicleModel.fromMap({
        'id': 10,
        'name': 'Carro do dia a dia',
        'brand': 'Honda',
        'model': 'Civic',
        'year': 2020,
        'plate': 'abc1d23',
        'currentKm': 45000,
      });

      expect(model.toEntity(), tVehicle);
    });

    test('lê a próxima manutenção achatada', () {
      final vehicle = VehicleModel.fromMap({
        'id': 1,
        'currentKm': '1000',
        'totalSpent': 1234.5,
        'nextMaintenanceTitle': 'Troca de óleo',
        'nextMaintenanceLabel': 'Em 3 dias',
        'nextMaintenanceStatus': 'SOON',
      }).toEntity();

      expect(vehicle.currentKm, 1000);
      expect(vehicle.totalSpent, 1234.5);
      expect(vehicle.nextMaintenanceTitle, 'Troca de óleo');
      expect(vehicle.nextMaintenanceLabel, 'Em 3 dias');
      expect(vehicle.nextMaintenanceStatus, MaintenanceStatus.soon);
      expect(vehicle.hasNextMaintenance, isTrue);
    });

    test('lê a próxima manutenção aninhada', () {
      final vehicle = VehicleModel.fromMap({
        'id': 1,
        'nextMaintenance': {'title': 'Pneus', 'status': 'late'},
      }).toEntity();

      expect(vehicle.nextMaintenanceTitle, 'Pneus');
      expect(vehicle.nextMaintenanceStatus, MaintenanceStatus.late);
    });

    test('campos opcionais ausentes ficam nulos', () {
      final vehicle = VehicleModel.fromMap({'id': 1}).toEntity();

      expect(vehicle.year, isNull);
      expect(vehicle.totalSpent, isNull);
      expect(vehicle.hasNextMaintenance, isFalse);
      expect(vehicle.currentKm, 0);
    });
  });

  test('toMap envia só os campos editáveis', () {
    expect(VehicleModel.fromInput(tVehicleInput, id: '10').toMap(), {
      'name': 'Carro do dia a dia',
      'brand': 'Honda',
      'model': 'Civic',
      'year': 2020,
      'plate': 'ABC1D23',
      'currentKm': 45000,
    });
  });
}
