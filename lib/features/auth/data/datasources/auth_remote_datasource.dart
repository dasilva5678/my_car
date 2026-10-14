import 'package:my_car/core/error/exceptions.dart';
import 'package:my_car/core/network/api_client.dart';
import 'package:my_car/core/network/endpoints.dart';
import 'package:my_car/features/auth/data/models/app_user_model.dart';

final class UserAlreadyExistsException extends AppException {
  const UserAlreadyExistsException();
}

abstract interface class AuthRemoteDataSource {
  Future<AppUserModel> signIn({
    required String email,
    required String password,
  });

  Future<AppUserModel> register({
    required String name,
    required String email,
    required String password,
  });

  Future<void> forgotPassword({required String email});
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiClient _client;

  // TODO: substituir pelo endpoint de cadastro quando a API disponibilizar.
  final Map<String, AppUserModel> _localUsers = {};

  AuthRemoteDataSourceImpl(this._client);

  @override
  Future<AppUserModel> signIn({
    required String email,
    required String password,
  }) async {
    final data = await _client.post(
      Endpoints.login,
      data: {
        'email': email.trim().toLowerCase(),
        'password': password,
      },
    );
    return AppUserModel.fromJson(_extractUserJson(data));
  }

  @override
  Future<AppUserModel> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final normalizedEmail = email.trim().toLowerCase();
    if (_localUsers.containsKey(normalizedEmail)) {
      throw const UserAlreadyExistsException();
    }

    final user = AppUserModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name.trim(),
      email: normalizedEmail,
    );
    _localUsers[normalizedEmail] = user;
    return user;
  }

  @override
  Future<void> forgotPassword({required String email}) async {
    // 200/204 não trazem corpo relevante; erros chegam como AppException.
    await _client.post(
      Endpoints.forgotPassword,
      data: {'email': email.trim().toLowerCase()},
    );
  }

  /// Aceita `{...user}`, `{user: {...}}`, `{data: {...}}` e
  /// `{data: {user: {...}}}`.
  Map<String, dynamic> _extractUserJson(dynamic responseData) {
    if (responseData is! Map) {
      throw const ParseException('Resposta de login não é um objeto.');
    }

    dynamic userData =
        responseData['user'] ?? responseData['data'] ?? responseData;
    if (userData is Map && userData['user'] is Map) {
      userData = userData['user'];
    }
    if (userData is! Map) {
      throw const ParseException('Usuário ausente na resposta de login.');
    }

    final userJson = Map<String, dynamic>.from(userData);
    if (userJson['id'] == null || userJson['email'] == null) {
      throw const ParseException('Usuário sem id ou e-mail.');
    }
    return userJson;
  }
}
