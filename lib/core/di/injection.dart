import 'package:get_it/get_it.dart';

import '../../features/auth/repository/auth_repository.dart';
import '../../features/auth/bloc/auth_bloc.dart';

final sl = GetIt.instance;

Future<void> setupDependencies() async {
  sl.registerLazySingleton<AuthRepository>(
    () => AuthRepository(),
  );

  sl.registerFactory(() => AuthBloc(repository: sl()));
}
