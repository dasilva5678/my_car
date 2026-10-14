import 'package:equatable/equatable.dart';

/// Situação da próxima manutenção (`LATE | SOON | OK` na API).
enum MaintenanceStatus { late, soon, ok }

class Vehicle extends Equatable {
  final String id;

  /// Apelido dado pelo usuário.
  final String name;
  final String brand;
  final String model;
  final int? year;

  /// Placa ou tag, sempre em maiúsculas.
  final String plate;
  final int currentKm;

  // Campos calculados pela API; só exibidos quando vierem preenchidos.
  final double? totalSpent;
  final String? nextMaintenanceTitle;
  final String? nextMaintenanceLabel;
  final MaintenanceStatus? nextMaintenanceStatus;

  const Vehicle({
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

  bool get hasNextMaintenance =>
      nextMaintenanceTitle != null && nextMaintenanceStatus != null;

  @override
  List<Object?> get props => [
        id,
        name,
        brand,
        model,
        year,
        plate,
        currentKm,
        totalSpent,
        nextMaintenanceTitle,
        nextMaintenanceLabel,
        nextMaintenanceStatus,
      ];
}
