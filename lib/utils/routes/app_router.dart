import 'package:go_router/go_router.dart';
import 'package:my_car/features/auth/pages/register_page.dart';
import 'package:my_car/features/vehicles/pages/vehicles_page.dart';
import '../../features/auth/pages/login_page.dart';
import 'name_routes.dart';

final appRouter = GoRouter(
  initialLocation: NameRoutes.login,
  routes: [
    GoRoute(
      path: NameRoutes.login,
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: NameRoutes.register,
      builder: (context, state) => const RegisterPage(),
    ),
    GoRoute(
      path: NameRoutes.vehicles,
      builder: (context, state) => const VehiclesPage(),
    ),
  ],
);
