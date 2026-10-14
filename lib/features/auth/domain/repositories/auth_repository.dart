import 'package:my_car/core/either/either.dart';
import 'package:my_car/core/error/failures.dart';
import 'package:my_car/features/auth/domain/entities/app_user.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  });

  Future<Either<Failure, AppUser>> register({
    required String name,
    required String email,
    required String password,
  });

  /// Solicita o envio do link de redefinição de senha. A API responde
  /// sucesso mesmo quando o e-mail não existe, para não revelar contas.
  Future<Either<Failure, void>> forgotPassword({required String email});
}
