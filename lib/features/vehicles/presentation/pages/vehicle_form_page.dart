import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_car/app/router/route_names.dart';
import 'package:my_car/design_system/design_system.dart';
import 'package:my_car/features/vehicles/domain/entities/vehicle.dart';
import 'package:my_car/features/vehicles/domain/entities/vehicle_input.dart';
import 'package:my_car/features/vehicles/domain/validators/vehicle_validators.dart';
import 'package:my_car/features/vehicles/presentation/bloc/vehicle_form_bloc.dart';
import 'package:my_car/features/vehicles/presentation/bloc/vehicle_form_event.dart';
import 'package:my_car/features/vehicles/presentation/bloc/vehicle_form_state.dart';
import 'package:my_car/features/vehicles/presentation/widgets/delete_vehicle_dialog.dart';

/// Devolvido à lista ao fechar o formulário; a lista recarrega/remove e
/// mostra o feedback.
enum VehicleFormResult { created, updated, deleted }

class VehicleFormPage extends StatefulWidget {
  /// Veículo em edição; `null` para cadastro.
  final Vehicle? vehicle;

  const VehicleFormPage({super.key, this.vehicle});

  @override
  State<VehicleFormPage> createState() => _VehicleFormPageState();
}

class _VehicleFormPageState extends State<VehicleFormPage> {
  final _formKey = GlobalKey<FormState>();
  late final _nameController = TextEditingController(text: _vehicle?.name);
  late final _brandController = TextEditingController(text: _vehicle?.brand);
  late final _yearController =
      TextEditingController(text: _vehicle?.year?.toString());
  late final _modelController = TextEditingController(text: _vehicle?.model);
  late final _plateController = TextEditingController(text: _vehicle?.plate);
  late final _kmController =
      TextEditingController(text: _vehicle?.currentKm.toString());

  Vehicle? get _vehicle => widget.vehicle;
  bool get _isEditing => _vehicle != null;

  @override
  void dispose() {
    _nameController.dispose();
    _brandController.dispose();
    _yearController.dispose();
    _modelController.dispose();
    _plateController.dispose();
    _kmController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    final input = VehicleInput(
      name: _nameController.text,
      brand: _brandController.text,
      model: _modelController.text,
      year: int.tryParse(_yearController.text.trim()),
      plate: _plateController.text,
      currentKm: int.tryParse(_kmController.text.trim()) ?? 0,
    );
    context
        .read<VehicleFormBloc>()
        .add(VehicleFormSubmitted(input, id: _vehicle?.id));
  }

  Future<void> _confirmDelete() async {
    final confirmed = await showDeleteVehicleDialog(
      context,
      vehicleName: _vehicle!.name,
    );
    if (confirmed && mounted) _close(VehicleFormResult.deleted);
  }

  void _close([VehicleFormResult? result]) {
    if (context.canPop()) {
      context.pop(result);
    } else {
      context.go(RouteNames.vehicles);
    }
  }

  void _onStateChanged(BuildContext context, VehicleFormState state) {
    switch (state) {
      case VehicleFormSuccess():
        _close(
          _isEditing ? VehicleFormResult.updated : VehicleFormResult.created,
        );
      case VehicleFormFailure(:final message):
        context.showError(message);
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<VehicleFormBloc, VehicleFormState>(
      listener: _onStateChanged,
      builder: (context, state) {
        final isSubmitting = state is VehicleFormSubmitting;

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              tooltip: 'Fechar',
              onPressed: () => _close(),
            ),
            title: Text(_isEditing ? 'Editar veículo' : 'Novo veículo'),
            actions: [
              if (_isEditing)
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  tooltip: 'Remover',
                  onPressed: isSubmitting ? null : _confirmDelete,
                ),
            ],
          ),
          body: SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              child: _buildForm(isSubmitting: isSubmitting),
            ),
          ),
        );
      },
    );
  }

  Widget _buildForm({required bool isSubmitting}) {
    final enabled = !isSubmitting;

    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextField(
            controller: _nameController,
            label: 'Apelido',
            hint: 'Ex.: Carro do dia a dia',
            prefixIcon: Icons.label,
            textCapitalization: TextCapitalization.sentences,
            textInputAction: TextInputAction.next,
            validator: VehicleValidators.name,
            enabled: enabled,
          ),
          const SizedBox(height: AppSpacing.md),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: AppTextField(
                  controller: _brandController,
                  label: 'Marca',
                  textCapitalization: TextCapitalization.words,
                  textInputAction: TextInputAction.next,
                  enabled: enabled,
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: AppTextField(
                  controller: _yearController,
                  label: 'Ano',
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(4),
                  ],
                  validator: VehicleValidators.year,
                  enabled: enabled,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _modelController,
            label: 'Modelo',
            prefixIcon: Icons.directions_car,
            textCapitalization: TextCapitalization.words,
            textInputAction: TextInputAction.next,
            validator: VehicleValidators.model,
            enabled: enabled,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _plateController,
            label: 'Placa / tag',
            hint: 'ABC1D23',
            prefixIcon: Icons.tag,
            textCapitalization: TextCapitalization.characters,
            textInputAction: TextInputAction.next,
            inputFormatters: [_UpperCaseFormatter()],
            validator: VehicleValidators.plate,
            enabled: enabled,
          ),
          const SizedBox(height: AppSpacing.md),
          AppTextField(
            controller: _kmController,
            label: 'Quilometragem atual',
            prefixIcon: Icons.speed,
            suffixText: 'km',
            keyboardType: TextInputType.number,
            textInputAction: TextInputAction.done,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly],
            validator: VehicleValidators.km,
            onFieldSubmitted: (_) => _submit(),
            enabled: enabled,
          ),
          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: 'Salvar',
            isLoading: isSubmitting,
            onPressed: _submit,
          ),
        ],
      ),
    );
  }
}

/// Garante a placa em maiúsculas mesmo em teclados que ignoram
/// `TextCapitalization.characters`.
class _UpperCaseFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) =>
      newValue.copyWith(text: newValue.text.toUpperCase());
}
