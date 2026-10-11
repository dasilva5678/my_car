import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_car/app/router/route_names.dart';
import 'package:my_car/design_system/design_system.dart';
import 'package:my_car/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_car/features/auth/presentation/bloc/auth_event.dart';
import 'package:my_car/features/auth/presentation/bloc/auth_state.dart';

class VehiclesPage extends StatelessWidget {
  const VehiclesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocListener<AuthBloc, AuthState>(
      listenWhen: (_, state) => state is AuthUnauthenticated,
      listener: (context, _) => context.go(RouteNames.login),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Veículos'),
          actions: [
            IconButton(
              icon: const Icon(Icons.logout),
              tooltip: 'Sair',
              onPressed: () =>
                  context.read<AuthBloc>().add(const AuthSignOutRequested()),
            ),
          ],
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: BlocBuilder<AuthBloc, AuthState>(
              builder: (context, state) {
                final name = state is AuthAuthenticated ? state.user.name : '';
                return Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(
                      Icons.directions_car_outlined,
                      size: 64,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppSpacing.md),
                    CustomText.title(
                      name.isEmpty ? 'Bem-vindo!' : 'Bem-vindo, $name!',
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    const CustomText(
                      'Você ainda não cadastrou veículos.',
                      textAlign: TextAlign.center,
                      color: AppColors.textSecondary,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
