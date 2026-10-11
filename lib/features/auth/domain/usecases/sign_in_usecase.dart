import 'package:my_car/core/either/either.dart';
import 'package:my_car/core/error/failures.dart';
import 'package:my_car/core/validators/validators.dart';
import 'package:my_car/features/auth/domain/entities/app_user.dart';
import 'package:my_car/features/auth/domain/repositories/auth_repository.dart';

class SignInUseCase {
  final AuthRepository _repository;

  const SignInUseCase(this._repository);

  Future<Either<Failure, AppUser>> call({
    required String email,
    required String password,
  }) async {
    final error = Validators.email(email) ?? Validators.password(password);
    if (error != null) return Left(ValidationFailure(error));

    return _repository.signIn(email: email, password: password);
  }
}
