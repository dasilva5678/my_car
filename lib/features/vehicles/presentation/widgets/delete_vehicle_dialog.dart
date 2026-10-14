import 'package:flutter/material.dart';
import 'package:my_car/design_system/design_system.dart';

/// Pede confirmação antes de remover. Retorna `true` se o usuário confirmou.
Future<bool> showDeleteVehicleDialog(
  BuildContext context, {
  required String vehicleName,
}) async {
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      icon: const Icon(Icons.delete),
      title: const Text('Remover veículo?'),
      content: CustomText(
        '$vehicleName e todo o histórico de manutenções, agendamentos e '
        'orçamentos ligados a ele serão excluídos.',
        color: AppColors.textSecondary,
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(false),
          child: const Text('Cancelar'),
        ),
        TextButton(
          style: TextButton.styleFrom(foregroundColor: AppColors.error),
          onPressed: () => Navigator.of(context).pop(true),
          child: const Text('Remover'),
        ),
      ],
    ),
  );
  return confirmed ?? false;
}
