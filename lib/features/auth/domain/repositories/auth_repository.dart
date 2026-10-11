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
}
