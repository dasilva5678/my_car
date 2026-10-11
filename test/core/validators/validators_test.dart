import 'package:flutter_test/flutter_test.dart';
import 'package:my_car/core/validators/validators.dart';

void main() {
  group('Validators.email', () {
    test('aceita e-mails válidos', () {
      expect(Validators.email('jessica@mail.com'), isNull);
      expect(Validators.email('  a.b+c@sub.domain.com.br '), isNull);
    });

    test('rejeita vazio e formato inválido', () {
      expect(Validators.email(''), 'Informe seu e-mail.');
      expect(Validators.email(null), 'Informe seu e-mail.');
      expect(Validators.email('sem-arroba'), 'Informe um e-mail válido.');
      expect(Validators.email('a@b'), 'Informe um e-mail válido.');
    });
  });

  group('Validators.password', () {
    test('exige valor', () {
      expect(Validators.password(''), 'Informe sua senha.');
      expect(Validators.password(null), 'Informe sua senha.');
      expect(Validators.password('x'), isNull);
    });

    test('respeita o tamanho mínimo', () {
      expect(
        Validators.password('12345', minLength: 6),
        'A senha deve ter pelo menos 6 caracteres.',
      );
      expect(Validators.password('123456', minLength: 6), isNull);
    });
  });

  test('Validators.name exige texto não vazio', () {
    expect(Validators.name('   '), 'Informe seu nome.');
    expect(Validators.name('Jessica'), isNull);
  });
}
