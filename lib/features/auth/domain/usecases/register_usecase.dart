import 'package:my_car/core/either/either.dart';
import 'package:my_car/core/error/failures.dart';
import 'package:my_car/core/validators/validators.dart';
import 'package:my_car/features/auth/domain/entities/app_user.dart';
import 'package:my_car/features/auth/domain/repositories/auth_repository.dart';

class RegisterUseCase {
  final AuthRepository _repository;

  const RegisterUseCase(this._repository);

  Future<Either<Failure, AppUser>> call({
    required String name,
    required String email,
    required String password,
  }) async {
    final error = Validators.name(name) ??
        Validators.email(email) ??
        Validators.password(
          password,
          minLength: Validators.minPasswordLength,
        );
    if (error != null) return Left(ValidationFailure(error));

    return _repository.register(name: name, email: email, password: password);
  }
}
