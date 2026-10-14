import 'package:equatable/equatable.dart';

/// Dados editáveis de um veículo, usados para cadastrar e atualizar.
class VehicleInput extends Equatable {
  final String name;
  final String brand;
  final String model;
  final int? year;
  final String plate;
  final int currentKm;

  const VehicleInput({
    required this.name,
    required this.brand,
    required this.model,
    this.year,
    required this.plate,
    required this.currentKm,
  });

  /// Remove espaços das pontas e deixa a placa em maiúsculas.
  VehicleInput normalized() => VehicleInput(
        name: name.trim(),
        brand: brand.trim(),
        model: model.trim(),
        year: year,
        plate: plate.trim().toUpperCase(),
        currentKm: currentKm,
      );

  @override
  List<Object?> get props => [name, brand, model, year, plate, currentKm];
}
