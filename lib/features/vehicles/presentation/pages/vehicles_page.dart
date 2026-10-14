import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_car/app/router/route_names.dart';
import 'package:my_car/design_system/design_system.dart';
import 'package:my_car/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_car/features/auth/presentation/bloc/auth_event.dart';
import 'package:my_car/features/auth/presentation/bloc/auth_state.dart';
import 'package:my_car/features/vehicles/domain/entities/vehicle.dart';
import 'package:my_car/features/vehicles/presentation/bloc/vehicles_bloc.dart';
import 'package:my_car/features/vehicles/presentation/bloc/vehicles_event.dart';
import 'package:my_car/features/vehicles/presentation/bloc/vehicles_state.dart';
import 'package:my_car/features/vehicles/presentation/pages/vehicle_form_page.dart';
import 'package:my_car/features/vehicles/presentation/widgets/vehicle_card.dart';

class VehiclesPage extends StatelessWidget {
  const VehiclesPage({super.key});

  // TODO: abrir o detalhe do veículo (com histórico) quando a feature de
  // manutenção existir; por enquanto o card leva à edição.
  Future<void> _openForm(BuildContext context, {Vehicle? vehicle}) async {
    final result = await context.push<VehicleFormResult>(
      vehicle == null
          ? RouteNames.vehicleNew
          : RouteNames.vehicleEdit(vehicle.id),
      extra: vehicle,
    );
    if (result == null || !context.mounted) return;

    final bloc = context.read<VehiclesBloc>();
    switch (result) {
      case VehicleFormResult.created:
        bloc.add(const VehiclesRequested());
        context.showSuccess('Veículo cadastrado');
      case VehicleFormResult.updated:
        bloc.add(const VehiclesRequested());
        context.showSuccess('Veículo atualizado');
      case VehicleFormResult.deleted:
        final completer = Completer<bool>();
        bloc.add(VehicleDeleted(vehicle!.id, completer: completer));
        // Falhas já são exibidas pelo listener da página.
        if (await completer.future && context.mounted) {
          context.showSuccess('Veículo removido');
        }
    }
  }

  Future<void> _refresh(BuildContext context) {
    final completer = Completer<void>();
    context.read<VehiclesBloc>().add(VehiclesRequested(completer: completer));
    return completer.future;
  }

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
        floatingActionButton: BlocBuilder<VehiclesBloc, VehiclesState>(
          builder: (_, state) {
            if (_vehiclesOf(state).isEmpty) return const SizedBox.shrink();
            return FloatingActionButton(
              tooltip: 'Cadastrar veículo',
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              shape: const RoundedRectangleBorder(
                borderRadius: BorderRadius.all(AppRadius.lg),
              ),
              onPressed: () => _openForm(context),
              child: const Icon(Icons.add),
            );
          },
        ),
        body: BlocConsumer<VehiclesBloc, VehiclesState>(
          listenWhen: (_, state) => state is VehiclesFailure,
          listener: (context, state) =>
              context.showError((state as VehiclesFailure).message),
          builder: (context, state) {
            final vehicles = _vehiclesOf(state);
            final firstName = _firstName(context);

            return switch (state) {
              VehiclesLoading() =>
                const Center(child: CircularProgressIndicator()),
              _ when vehicles.isNotEmpty => RefreshIndicator(
                  onRefresh: () => _refresh(context),
                  child: _VehicleList(
                    firstName: firstName,
                    vehicles: vehicles,
                    onTap: (vehicle) => _openForm(context, vehicle: vehicle),
                  ),
                ),
              VehiclesFailure(:final message) => RefreshIndicator(
                  onRefresh: () => _refresh(context),
                  child: _FillScrollView(
                    child: _ErrorContent(
                      message: message,
                      onRetry: () => context
                          .read<VehiclesBloc>()
                          .add(const VehiclesRequested()),
                    ),
                  ),
                ),
              _ => RefreshIndicator(
                  onRefresh: () => _refresh(context),
                  child: _FillScrollView(
                    child: _EmptyContent(
                      firstName: firstName,
                      onAdd: () => _openForm(context),
                    ),
                  ),
                ),
            };
          },
        ),
      ),
    );
  }

  static List<Vehicle> _vehiclesOf(VehiclesState state) => switch (state) {
        VehiclesLoaded(:final vehicles) => vehicles,
        VehiclesFailure(:final vehicles) => vehicles,
        _ => const [],
      };

  static String _firstName(BuildContext context) {
    final state = context.watch<AuthBloc>().state;
    final name = state is AuthAuthenticated ? state.user.name.trim() : '';
    return name.isEmpty ? '' : name.split(RegExp(r'\s+')).first;
  }
}

class _VehicleList extends StatelessWidget {
  final String firstName;
  final List<Vehicle> vehicles;
  final ValueChanged<Vehicle> onTap;

  const _VehicleList({
    required this.firstName,
    required this.vehicles,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final count = vehicles.length;

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      // Espaço extra no fim para o FAB não cobrir o último card.
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md,
        AppSpacing.md + 80,
      ),
      itemCount: count + 1,
      separatorBuilder: (_, __) => const SizedBox(height: AppSpacing.md),
      itemBuilder: (context, index) {
        if (index == 0) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText(
                firstName.isEmpty ? 'Olá' : 'Olá, $firstName',
                color: AppColors.textSecondary,
              ),
              CustomText.title(count == 1 ? '1 veículo' : '$count veículos'),
            ],
          );
        }
        final vehicle = vehicles[index - 1];
        return VehicleCard(vehicle: vehicle, onTap: () => onTap(vehicle));
      },
    );
  }
}

/// Conteúdo centralizado que ainda permite o pull-to-refresh.
class _FillScrollView extends StatelessWidget {
  final Widget child;

  const _FillScrollView({required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) => SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: ConstrainedBox(
          constraints: BoxConstraints(minHeight: constraints.maxHeight),
          child: Center(
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.lg),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

class _EmptyContent extends StatelessWidget {
  final String firstName;
  final VoidCallback onAdd;

  const _EmptyContent({required this.firstName, required this.onAdd});

  @override
  Widget build(BuildContext context) {
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
          firstName.isEmpty ? 'Bem-vindo!' : 'Bem-vindo, $firstName!',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        const CustomText(
          'Você ainda não cadastrou veículos.',
          textAlign: TextAlign.center,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(
          label: 'Cadastrar veículo',
          icon: Icons.add,
          onPressed: onAdd,
        ),
      ],
    );
  }
}

class _ErrorContent extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorContent({required this.message, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.error_outline, size: 64, color: AppColors.error),
        const SizedBox(height: AppSpacing.md),
        CustomText(
          message,
          textAlign: TextAlign.center,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: AppSpacing.lg),
        AppButton(label: 'Tentar novamente', onPressed: onRetry),
      ],
    );
  }
}
