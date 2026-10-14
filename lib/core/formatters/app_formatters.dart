import 'package:intl/intl.dart';

/// Formatação de números e moeda no padrão brasileiro.
abstract final class AppFormatters {
  static const _locale = 'pt_BR';

  static final _integer = NumberFormat.decimalPattern(_locale);
  static final _currency =
      NumberFormat.currency(locale: _locale, symbol: r'R$', decimalDigits: 2);

  /// `45000` → `45.000 km`
  static String km(int value) => '${_integer.format(value)} km';

  /// `1234.5` → `R$ 1.234,50`
  static String currency(double value) => _currency.format(value);
}
