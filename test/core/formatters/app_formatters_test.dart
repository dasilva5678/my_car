import 'package:flutter_test/flutter_test.dart';
import 'package:my_car/core/formatters/app_formatters.dart';

/// O intl separa símbolo e valor com espaço não separável.
String _normalize(String value) => value.replaceAll(' ', ' ');

void main() {
  test('km usa separador de milhar pt-BR', () {
    expect(AppFormatters.km(45000), '45.000 km');
    expect(AppFormatters.km(0), '0 km');
  });

  test('currency formata em reais', () {
    expect(_normalize(AppFormatters.currency(1234.5)), r'R$ 1.234,50');
  });
}
