import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:my_car/core/either/either.dart';
import 'package:my_car/core/error/exceptions.dart';
import 'package:my_car/core/error/failures.dart';
import 'package:my_car/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:my_car/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:my_car/features/auth/domain/entities/app_user.dart';
import 'package:my_car/features/auth/domain/failures/auth_failure.dart';

import '../../../../helpers/fixtures.dart';

class _MockRemote extends Mock implements AuthRemoteDataSource {}

void main() {
  late _MockRemote remote;
  late AuthRepositoryImpl repository;

  setUp(() {
    remote = _MockRemote();
    repository = AuthRepositoryImpl(remote);
  });

  Future<Either<Failure, AppUser>> signIn() =>
      repository.signIn(email: tEmail, password: tPassword);

  void stubSignInThrows(Object error) => when(
        () => remote.signIn(
          email: any(named: 'email'),
          password: any(named: 'password'),
        ),
      ).thenThrow(error);

  Failure? leftOf(Either<Failure, AppUser> result) =>
      result.fold(onLeft: (f) => f, onRight: (_) => null);

  group('signIn', () {
    test('converte o model em entidade', () async {
      when(() => remote.signIn(email: tEmail, password: tPassword))
          .thenAnswer((_) async => tUserModel);

      final result = await signIn();

      expect(result.fold(onLeft: (_) => null, onRight: (u) => u), tUser);
    });

    test('401 -> AuthFailure.invalidCredentials', () async {
      stubSignInThrows(const ServerException(statusCode: 401, message: 'x'));

      expect(leftOf(await signIn()), const AuthFailure.invalidCredentials());
    });

    test('outros status mantêm a mensagem da API', () async {
      stubSignInThrows(
        const ServerException(statusCode: 422, message: 'Conta bloqueada'),
      );

      expect(
        leftOf(await signIn()),
        const ServerFailure(statusCode: 422, message: 'Conta bloqueada'),
      );
    });

    test('falha de rede -> NetworkFailure', () async {
      stubSignInThrows(const NetworkException());

      expect(leftOf(await signIn()), const NetworkFailure());
    });
  });

  group('register', () {
    Future<Either<Failure, AppUser>> register() =>
        repository.register(name: tName, email: tEmail, password: tPassword);

    void stubRegisterThrows(Object error) => when(
          () => remote.register(
            name: any(named: 'name'),
            email: any(named: 'email'),
            password: any(named: 'password'),
          ),
        ).thenThrow(error);

    test('UserAlreadyExistsException -> AuthFailure.userAlreadyExists',
        () async {
      stubRegisterThrows(const UserAlreadyExistsException());

      expect(leftOf(await register()), const AuthFailure.userAlreadyExists());
    });

    test('409 -> AuthFailure.userAlreadyExists', () async {
      stubRegisterThrows(const ServerException(statusCode: 409));

      expect(leftOf(await register()), const AuthFailure.userAlreadyExists());
    });

    test('erro inesperado -> UnexpectedFailure', () async {
      stubRegisterThrows(Exception('boom'));

      expect(leftOf(await register()), const UnexpectedFailure());
    });
  });

  group('forgotPassword', () {
    test('retorna Right quando a API responde com sucesso', () async {
      when(() => remote.forgotPassword(email: tEmail)).thenAnswer((_) async {});

      final result = await repository.forgotPassword(email: tEmail);

      expect(result.isRight, isTrue);
    });

    test('erro de servidor -> ServerFailure', () async {
      when(() => remote.forgotPassword(email: any(named: 'email')))
          .thenThrow(const ServerException(statusCode: 500));

      final result = await repository.forgotPassword(email: tEmail);

      expect(
        result.fold(onLeft: (f) => f, onRight: (_) => null),
        const ServerFailure(statusCode: 500),
      );
    });
  });
}
