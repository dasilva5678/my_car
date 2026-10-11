import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:my_car/core/network/api_client.dart';
import 'package:my_car/core/network/endpoints.dart';
import 'package:my_car/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:my_car/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:my_car/features/auth/domain/repositories/auth_repository.dart';
import 'package:my_car/features/auth/domain/usecases/register_usecase.dart';
import 'package:my_car/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:my_car/features/auth/presentation/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  _registerCore();
  _registerAuth();
}

void _registerCore() {
  sl
    ..registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          connectTimeout: ApiConfig.timeout,
          receiveTimeout: ApiConfig.timeout,
          headers: const {'Content-Type': 'application/json'},
        ),
      ),
    )
    ..registerLazySingleton(() => ApiClient(sl()));
}

void _registerAuth() {
  sl
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()))
    ..registerLazySingleton(() => SignInUseCase(sl()))
    ..registerLazySingleton(() => RegisterUseCase(sl()))
    ..registerFactory(() => AuthBloc(signIn: sl(), register: sl()));
}
