import 'package:my_car/core/either/either.dart';
import 'package:my_car/core/error/failures.dart';
import 'package:my_car/core/validators/validators.dart';
import 'package:my_car/features/auth/domain/repositories/auth_repository.dart';

class ForgotPasswordUseCase {
  final AuthRepository _repository;

  const ForgotPasswordUseCase(this._repository);

  Future<Either<Failure, void>> call({required String email}) async {
    final error = Validators.email(email);
    if (error != null) return Left(ValidationFailure(error));

    return _repository.forgotPassword(email: email);
  }
}
