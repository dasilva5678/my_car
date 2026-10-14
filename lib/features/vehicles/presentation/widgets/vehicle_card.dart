import 'package:flutter/material.dart';
import 'package:my_car/core/formatters/app_formatters.dart';
import 'package:my_car/design_system/design_system.dart';
import 'package:my_car/features/vehicles/domain/entities/vehicle.dart';

class VehicleCard extends StatelessWidget {
  final Vehicle vehicle;
  final VoidCallback onTap;

  const VehicleCard({super.key, required this.vehicle, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final totalSpent = vehicle.totalSpent;

    return Material(
      color: AppColors.surface,
      clipBehavior: Clip.antiAlias,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.all(AppRadius.lg),
        side: BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.md),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _Header(vehicle: vehicle),
              const Divider(height: AppSpacing.lg),
              Row(
                children: [
                  Expanded(
                    child: _Stat(
                      label: 'Km atual',
                      value: AppFormatters.km(vehicle.currentKm),
                    ),
                  ),
                  Expanded(
                    child: totalSpent == null
                        ? const SizedBox.shrink()
                        : _Stat(
                            label: 'Total gasto',
                            value: AppFormatters.currency(totalSpent),
                          ),
                  ),
                ],
              ),
              if (vehicle.hasNextMaintenance) ...[
                const SizedBox(height: AppSpacing.md),
                _NextMaintenance(
                  title: vehicle.nextMaintenanceTitle!,
                  label: vehicle.nextMaintenanceLabel,
                  status: vehicle.nextMaintenanceStatus!,
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _Header extends StatelessWidget {
  final Vehicle vehicle;

  const _Header({required this.vehicle});

  /// "{marca} {modelo} · {ano}", omitindo o que não foi informado.
  String get _description {
    final name = [vehicle.brand, vehicle.model]
        .where((part) => part.trim().isNotEmpty)
        .join(' ');
    final year = vehicle.year;
    if (year == null) return name;
    return name.isEmpty ? '$year' : '$name · $year';
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 44,
          height: 44,
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.14),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.directions_car_outlined,
            color: AppColors.primary,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CustomText.subtitle(
                vehicle.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (_description.isNotEmpty)
                CustomText.caption(
                  _description,
                  color: AppColors.textSecondary,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
        const SizedBox(width: AppSpacing.sm),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.sm,
            vertical: AppSpacing.xs,
          ),
          decoration: BoxDecoration(
            border: Border.all(color: AppColors.border),
            borderRadius: const BorderRadius.all(AppRadius.sm),
          ),
          child: CustomText.caption(
            vehicle.plate,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.8,
          ),
        ),
      ],
    );
  }
}

class _Stat extends StatelessWidget {
  final String label;
  final String value;

  const _Stat({required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        CustomText.caption(label, color: AppColors.textSecondary),
        const SizedBox(height: AppSpacing.xs),
        CustomText.subtitle(value),
      ],
    );
  }
}

class _NextMaintenance extends StatelessWidget {
  final String title;
  final String? label;
  final MaintenanceStatus status;

  const _NextMaintenance({
    required this.title,
    required this.label,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surfaceVariant,
        borderRadius: BorderRadius.all(AppRadius.md),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(
              color: status.color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: CustomText(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          CustomText.caption(
            label ?? status.defaultLabel,
            color: status.color,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }
}

extension MaintenanceStatusView on MaintenanceStatus {
  Color get color => switch (this) {
        MaintenanceStatus.late => AppColors.error,
        MaintenanceStatus.soon => AppColors.warning,
        MaintenanceStatus.ok => AppColors.success,
      };

  /// Usado quando a API não manda `nextMaintenanceLabel`.
  String get defaultLabel => switch (this) {
        MaintenanceStatus.late => 'Atrasada',
        MaintenanceStatus.soon => 'Em breve',
        MaintenanceStatus.ok => 'Em dia',
      };
}
