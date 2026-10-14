import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_car/app/router/route_names.dart';
import 'package:my_car/core/di/injection.dart';
import 'package:my_car/features/auth/presentation/bloc/forgot_password_bloc.dart';
import 'package:my_car/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:my_car/features/auth/presentation/pages/login_page.dart';
import 'package:my_car/features/auth/presentation/pages/register_page.dart';
import 'package:my_car/features/vehicles/presentation/pages/vehicles_page.dart';

final appRouter = GoRouter(
  initialLocation: RouteNames.login,
  routes: [
    GoRoute(
      path: RouteNames.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: RouteNames.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: RouteNames.forgotPassword,
      builder: (context, state) => BlocProvider(
        create: (_) => sl<ForgotPasswordBloc>(),
        child: ForgotPasswordPage(initialEmail: state.extra as String?),
      ),
    ),
    GoRoute(
      path: RouteNames.vehicles,
      builder: (context, state) => const VehiclesPage(),
    ),
  ],
);
