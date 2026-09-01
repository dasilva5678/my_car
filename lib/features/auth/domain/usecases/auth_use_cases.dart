import '../../../../core/result/result.dart';
import '../entities/app_user.dart';
import '../repositories/auth_repository.dart';

class SignIn {
  final AuthRepository _repository;

  const SignIn(this._repository);

  Future<Result<AppUser>> call({
    required String email,
    required String password,
  }) =>
      _repository.signIn(email: email, password: password);
}

class RegisterUserUsecase {
  final AuthRepository _repository;

  const RegisterUserUsecase(this._repository);

  Future<Result<AppUser>> call({
    required String name,
    required String email,
    required String password,
  }) =>
      _repository.register(name: name, email: email, password: password);
}
