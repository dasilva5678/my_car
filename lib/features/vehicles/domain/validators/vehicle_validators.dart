import 'package:my_car/core/validators/validators.dart';
import 'package:my_car/features/vehicles/domain/entities/vehicle_input.dart';

/// Regras do cadastro de veículo, compartilhadas pelo formulário e pelos
/// use cases, no mesmo formato de `Validators`.
abstract final class VehicleValidators {
  static const minYear = 1900;

  static String? name(String? value) =>
      Validators.required(value, message: 'Informe um apelido');

  static String? model(String? value) =>
      Validators.required(value, message: 'Informe o modelo');

  static String? plate(String? value) =>
      Validators.required(value, message: 'Informe a placa ou tag');

  /// Opcional; quando preenchido, precisa ter 4 dígitos e ser plausível.
  static String? year(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final year = int.tryParse(value.trim());
    if (value.trim().length != 4 || year == null) return 'Informe um ano válido';
    return yearValue(year);
  }

  static String? yearValue(int? year) {
    if (year == null) return null;
    final maxYear = DateTime.now().year + 1;
    return (year < minYear || year > maxYear) ? 'Informe um ano válido' : null;
  }

  /// Opcional; vazio equivale a 0 km.
  static String? km(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final km = int.tryParse(value.trim());
    return kmValue(km ?? -1);
  }

  static String? kmValue(int km) =>
      km < 0 ? 'Informe uma quilometragem válida' : null;

  static String? input(VehicleInput input) =>
      name(input.name) ??
      model(input.model) ??
      plate(input.plate) ??
      yearValue(input.year) ??
      kmValue(input.currentKm);
}
