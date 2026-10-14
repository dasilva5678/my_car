import '../../domain/entities/vehicle.dart';
import '../../domain/entities/vehicle_input.dart';

class VehicleModel {
  final String id;
  final String name;
  final String brand;
  final String model;
  final int? year;
  final String plate;
  final int currentKm;
  final double? totalSpent;
  final String? nextMaintenanceTitle;
  final String? nextMaintenanceLabel;
  final MaintenanceStatus? nextMaintenanceStatus;

  const VehicleModel({
    required this.id,
    required this.name,
    required this.brand,
    required this.model,
    this.year,
    required this.plate,
    required this.currentKm,
    this.totalSpent,
    this.nextMaintenanceTitle,
    this.nextMaintenanceLabel,
    this.nextMaintenanceStatus,
  });

  /// Veículo ainda não salvo (o id vem da API) ou a ser atualizado.
  factory VehicleModel.fromInput(VehicleInput input, {String id = ''}) {
    return VehicleModel(
      id: id,
      name: input.name,
      brand: input.brand,
      model: input.model,
      year: input.year,
      plate: input.plate,
      currentKm: input.currentKm,
    );
  }

  /// A próxima manutenção pode vir achatada (`nextMaintenanceTitle`...) ou
  /// aninhada em `nextMaintenance: {title, label, status}`.
  factory VehicleModel.fromMap(Map<String, dynamic> map) {
    final next = map['nextMaintenance'];
    final nextMap = next is Map ? next : const {};

    return VehicleModel(
      id: map['id'].toString(),
      name: (map['name'] ?? map['nickname'] ?? '').toString(),
      brand: (map['brand'] ?? '').toString(),
      model: (map['model'] ?? '').toString(),
      year: _toInt(map['year']),
      plate: (map['plate'] ?? '').toString().toUpperCase(),
      currentKm: _toInt(map['currentKm'] ?? map['current_km']) ?? 0,
      totalSpent: _toDouble(map['totalSpent'] ?? map['total_spent']),
      nextMaintenanceTitle:
          _toText(map['nextMaintenanceTitle'] ?? nextMap['title']),
      nextMaintenanceLabel:
          _toText(map['nextMaintenanceLabel'] ?? nextMap['label']),
      nextMaintenanceStatus:
          _toStatus(map['nextMaintenanceStatus'] ?? nextMap['status']),
    );
  }

  /// Corpo de POST/PUT: só os campos editáveis (o id vai na URL).
  Map<String, dynamic> toMap() => {
        'name': name,
        'brand': brand,
        'model': model,
        'year': year,
        'plate': plate,
        'currentKm': currentKm,
      };

  Vehicle toEntity() => Vehicle(
        id: id,
        name: name,
        brand: brand,
        model: model,
        year: year,
        plate: plate,
        currentKm: currentKm,
        totalSpent: totalSpent,
        nextMaintenanceTitle: nextMaintenanceTitle,
        nextMaintenanceLabel: nextMaintenanceLabel,
        nextMaintenanceStatus: nextMaintenanceStatus,
      );

  static int? _toInt(dynamic value) =>
      value is num ? value.toInt() : int.tryParse('${value ?? ''}');

  static double? _toDouble(dynamic value) =>
      value is num ? value.toDouble() : double.tryParse('${value ?? ''}');

  static String? _toText(dynamic value) {
    final text = value?.toString().trim();
    return (text == null || text.isEmpty) ? null : text;
  }

  static MaintenanceStatus? _toStatus(dynamic value) =>
      switch (value?.toString().toUpperCase()) {
        'LATE' => MaintenanceStatus.late,
        'SOON' => MaintenanceStatus.soon,
        'OK' => MaintenanceStatus.ok,
        _ => null,
      };
}
