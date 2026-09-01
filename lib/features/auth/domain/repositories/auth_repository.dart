import '../../../../core/result/result.dart';
import '../entities/app_user.dart';

abstract interface class AuthRepository {
  Future<Result<AppUser>> signIn({
    required String email,
    required String password,
  });

  Future<Result<AppUser>> register({
    required String name,
    required String email,
    required String password,
  });
}
