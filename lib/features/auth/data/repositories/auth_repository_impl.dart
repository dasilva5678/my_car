import '../../../../core/result/result.dart';
import '../../domain/entities/app_user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../failure/auth_failure.dart';
import '../services/auth_service.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthService _service;

  const AuthRepositoryImpl(this._service);

  @override
  Future<Result<AppUser>> signIn({
    required String email,
    required String password,
  }) async {
    if (email.trim().isEmpty || password.isEmpty) {
      return const Failure(AuthFailure.invalidFields());
    }

    try {
      final user = await _service.signIn(email: email, password: password);
      return Success(user.toEntity());
    } on AuthApiException catch (error) {
      return Failure(AuthFailure(error.message));
    } on AuthNetworkException {
      return const Failure(AuthFailure.network());
    } on InvalidAuthResponseException {
      return const Failure(AuthFailure.invalidResponse());
    } catch (_) {
      return const Failure(AuthFailure.unexpected());
    }
  }

  @override
  Future<Result<AppUser>> register({
    required String name,
    required String email,
    required String password,
  }) async {
    if (name.trim().isEmpty || email.trim().isEmpty || password.isEmpty) {
      return const Failure(AuthFailure.invalidFields());
    }

    try {
      final user = await _service.register(
        name: name,
        email: email,
        password: password,
      );
      return Success(user.toEntity());
    } on UserAlreadyExistsException {
      return const Failure(AuthFailure.userAlreadyExists());
    } catch (_) {
      return const Failure(AuthFailure.unexpected());
    }
  }
}
