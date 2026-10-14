import 'package:my_car/core/either/either.dart';
import 'package:my_car/core/error/exceptions.dart';
import 'package:my_car/core/error/failures.dart';
import 'package:my_car/core/error/repository_guard.dart';
import 'package:my_car/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:my_car/features/auth/domain/entities/app_user.dart';
import 'package:my_car/features/auth/domain/failures/auth_failure.dart';
import 'package:my_car/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl with RepositoryGuard implements AuthRepository {
  final AuthRemoteDataSource _remote;

  const AuthRepositoryImpl(this._remote);

  @override
  Future<Either<Failure, AppUser>> signIn({
    required String email,
    required String password,
  }) =>
      guard(() async {
        final user = await _remote.signIn(email: email, password: password);
        return user.toEntity();
      });

  @override
  Future<Either<Failure, AppUser>> register({
    required String name,
    required String email,
    required String password,
  }) =>
      guard(() async {
        final user = await _remote.register(
          name: name,
          email: email,
          password: password,
        );
        return user.toEntity();
      });

  @override
  Future<Either<Failure, void>> forgotPassword({required String email}) =>
      guard(() => _remote.forgotPassword(email: email));

  @override
  Failure mapException(AppException exception) => switch (exception) {
        UserAlreadyExistsException() ||
        ServerException(statusCode: 409) =>
          const AuthFailure.userAlreadyExists(),
        ServerException(statusCode: 401) =>
          const AuthFailure.invalidCredentials(),
        _ => super.mapException(exception),
      };
}
