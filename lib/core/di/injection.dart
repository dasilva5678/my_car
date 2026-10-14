import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:my_car/core/network/api_client.dart';
import 'package:my_car/core/network/auth_interceptor.dart';
import 'package:my_car/core/network/auth_token_store.dart';
import 'package:my_car/core/network/endpoints.dart';
import 'package:my_car/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:my_car/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:my_car/features/auth/domain/repositories/auth_repository.dart';
import 'package:my_car/features/auth/domain/usecases/forgot_password_usecase.dart';
import 'package:my_car/features/auth/domain/usecases/register_usecase.dart';
import 'package:my_car/features/auth/domain/usecases/sign_in_usecase.dart';
import 'package:my_car/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_car/features/auth/presentation/bloc/forgot_password_bloc.dart';
import 'package:my_car/features/vehicles/data/datasources/vehicle_remote_datasource.dart';
import 'package:my_car/features/vehicles/data/repositories/vehicle_repository_impl.dart';
import 'package:my_car/features/vehicles/domain/repositories/vehicle_repository.dart';
import 'package:my_car/features/vehicles/domain/usecases/create_vehicle_usecase.dart';
import 'package:my_car/features/vehicles/domain/usecases/delete_vehicle_usecase.dart';
import 'package:my_car/features/vehicles/domain/usecases/get_vehicles_usecase.dart';
import 'package:my_car/features/vehicles/domain/usecases/update_vehicle_usecase.dart';
import 'package:my_car/features/vehicles/presentation/bloc/vehicle_form_bloc.dart';
import 'package:my_car/features/vehicles/presentation/bloc/vehicles_bloc.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  _registerCore();
  _registerAuth();
  _registerVehicles();
}

void _registerCore() {
  sl
    ..registerLazySingleton(AuthTokenStore.new)
    ..registerLazySingleton<Dio>(
      () => Dio(
        BaseOptions(
          baseUrl: ApiConfig.baseUrl,
          connectTimeout: ApiConfig.timeout,
          receiveTimeout: ApiConfig.timeout,
          headers: const {'Content-Type': 'application/json'},
        ),
      )..interceptors.add(AuthInterceptor(sl())),
    )
    ..registerLazySingleton(() => ApiClient(sl()));
}

void _registerAuth() {
  sl
    ..registerLazySingleton<AuthRemoteDataSource>(
      () => AuthRemoteDataSourceImpl(sl(), sl()),
    )
    ..registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(sl()))
    ..registerLazySingleton(() => SignInUseCase(sl()))
    ..registerLazySingleton(() => RegisterUseCase(sl()))
    ..registerLazySingleton(() => ForgotPasswordUseCase(sl()))
    ..registerFactory(() => AuthBloc(signIn: sl(), register: sl()))
    ..registerFactory(() => ForgotPasswordBloc(forgotPassword: sl()));
}

void _registerVehicles() {
  sl
    ..registerLazySingleton<VehicleRemoteDataSource>(
      () => VehicleRemoteDataSourceImpl(sl()),
    )
    ..registerLazySingleton<VehicleRepository>(
      () => VehicleRepositoryImpl(sl()),
    )
    ..registerLazySingleton(() => GetVehiclesUseCase(sl()))
    ..registerLazySingleton(() => CreateVehicleUseCase(sl()))
    ..registerLazySingleton(() => UpdateVehicleUseCase(sl()))
    ..registerLazySingleton(() => DeleteVehicleUseCase(sl()))
    ..registerFactory(
      () => VehiclesBloc(getVehicles: sl(), deleteVehicle: sl()),
    )
    ..registerFactory(
      () => VehicleFormBloc(createVehicle: sl(), updateVehicle: sl()),
    );
}
