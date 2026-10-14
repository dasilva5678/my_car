import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_car/app/router/route_names.dart';
import 'package:my_car/core/di/injection.dart';
import 'package:my_car/features/auth/presentation/bloc/forgot_password_bloc.dart';
import 'package:my_car/features/auth/presentation/pages/forgot_password_page.dart';
import 'package:my_car/features/auth/presentation/pages/login_page.dart';
import 'package:my_car/features/auth/presentation/pages/register_page.dart';
import 'package:my_car/features/vehicles/domain/entities/vehicle.dart';
import 'package:my_car/features/vehicles/presentation/bloc/vehicle_form_bloc.dart';
import 'package:my_car/features/vehicles/presentation/bloc/vehicles_bloc.dart';
import 'package:my_car/features/vehicles/presentation/bloc/vehicles_event.dart';
import 'package:my_car/features/vehicles/presentation/pages/vehicle_form_page.dart';
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
      builder: (context, state) => BlocProvider(
        create: (_) => sl<VehiclesBloc>()..add(const VehiclesRequested()),
        child: const VehiclesPage(),
      ),
      // Sub-rotas relativas: /vehicles/new e /vehicles/:id/edit
      // (ver RouteNames.vehicleNew / RouteNames.vehicleEdit).
      routes: [
        GoRoute(
          path: 'new',
          builder: (context, state) => BlocProvider(
            create: (_) => sl<VehicleFormBloc>(),
            child: const VehicleFormPage(),
          ),
        ),
        GoRoute(
          path: ':id/edit',
          // O veículo chega via `extra`; sem ele (link direto), volta à lista.
          redirect: (context, state) =>
              state.extra is Vehicle ? null : RouteNames.vehicles,
          builder: (context, state) => BlocProvider(
            create: (_) => sl<VehicleFormBloc>(),
            child: VehicleFormPage(vehicle: state.extra as Vehicle),
          ),
        ),
      ],
    ),
  ],
);
