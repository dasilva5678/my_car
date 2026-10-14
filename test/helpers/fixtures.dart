import 'package:my_car/features/auth/data/models/app_user_model.dart';
import 'package:my_car/features/auth/domain/entities/app_user.dart';
import 'package:my_car/features/vehicles/domain/entities/vehicle.dart';
import 'package:my_car/features/vehicles/domain/entities/vehicle_input.dart';

const tEmail = 'jessica@mail.com';
const tPassword = 'secret123';
const tName = 'Jessica';

const tUserModel = AppUserModel(id: '1', name: tName, email: tEmail);
const tUser = AppUser(id: '1', name: tName, email: tEmail);

const tVehicleId = '10';

const tVehicleInput = VehicleInput(
  name: 'Carro do dia a dia',
  brand: 'Honda',
  model: 'Civic',
  year: 2020,
  plate: 'ABC1D23',
  currentKm: 45000,
);

const tVehicle = Vehicle(
  id: tVehicleId,
  name: 'Carro do dia a dia',
  brand: 'Honda',
  model: 'Civic',
  year: 2020,
  plate: 'ABC1D23',
  currentKm: 45000,
);

const tOtherVehicle = Vehicle(
  id: '11',
  name: 'Moto',
  brand: 'Yamaha',
  model: 'Fazer',
  plate: 'XYZ9A87',
  currentKm: 12000,
);
