import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_car/features/auth/bloc/auth_bloc.dart';
import 'package:my_car/features/auth/bloc/auth_event.dart';
import 'package:my_car/features/auth/bloc/auth_state.dart';
import 'package:my_car/utils/routes/name_routes.dart';
import 'package:my_car/design_system/theme/style/colors.dart';

class VehiclesPage extends StatelessWidget {
  const VehiclesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthUnauthenticated) {
          context.go(NameRoutes.login);
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(state.message),
              backgroundColor: DefaultColors.red,
            ),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Veículos'),
          backgroundColor: DefaultColors.orange,
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              onPressed: () {
                context.read<AuthBloc>().add(const AuthSignOutRequested());
              },
            ),
          ],
        ),
        body: const Center(
          child: Text(
            'Bem-vindo! Você está autenticado.',
            style: TextStyle(color: Colors.white, fontSize: 18),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
