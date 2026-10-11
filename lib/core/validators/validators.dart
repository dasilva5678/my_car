/// Regras de validação reutilizadas pelos formulários (feedback imediato)
/// e pelos use cases (garantia de domínio). Retornam a mensagem de erro
/// ou `null` quando o valor é válido — assinatura compatível com
/// `FormField.validator`.
abstract final class Validators {
  static const minPasswordLength = 6;

  static final _emailRegex = RegExp(r'^[\w.+-]+@[\w-]+(\.[\w-]+)+$');

  static String? required(
    String? value, {
    String message = 'Campo obrigatório.',
  }) =>
      (value == null || value.trim().isEmpty) ? message : null;

  static String? name(String? value) =>
      required(value, message: 'Informe seu nome.');

  static String? email(String? value) =>
      required(value, message: 'Informe seu e-mail.') ??
      (_emailRegex.hasMatch(value!.trim())
          ? null
          : 'Informe um e-mail válido.');

  static String? password(String? value, {int minLength = 1}) {
    if (value == null || value.isEmpty) return 'Informe sua senha.';
    if (value.length < minLength) {
      return 'A senha deve ter pelo menos $minLength caracteres.';
    }
    return null;
  }
}
