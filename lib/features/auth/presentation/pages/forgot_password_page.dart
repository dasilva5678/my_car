import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_car/app/router/route_names.dart';
import 'package:my_car/core/validators/validators.dart';
import 'package:my_car/design_system/design_system.dart';
import 'package:my_car/features/auth/presentation/bloc/forgot_password_bloc.dart';
import 'package:my_car/features/auth/presentation/bloc/forgot_password_event.dart';
import 'package:my_car/features/auth/presentation/bloc/forgot_password_state.dart';

class ForgotPasswordPage extends StatefulWidget {
  /// E-mail já digitado no login, usado como valor inicial do campo.
  final String? initialEmail;

  const ForgotPasswordPage({super.key, this.initialEmail});

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final _formKey = GlobalKey<FormState>();
  late final _emailController =
      TextEditingController(text: widget.initialEmail);

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    context
        .read<ForgotPasswordBloc>()
        .add(ForgotPasswordSubmitted(_emailController.text.trim()));
  }

  void _backToLogin() {
    if (context.canPop()) {
      context.pop();
    } else {
      context.go(RouteNames.login);
    }
  }

  void _onStateChanged(BuildContext context, ForgotPasswordState state) {
    if (state is ForgotPasswordFailure) context.showError(state.message);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recuperar senha'),
        leading: BackButton(onPressed: _backToLogin),
      ),
      body: BlocConsumer<ForgotPasswordBloc, ForgotPasswordState>(
        listener: _onStateChanged,
        builder: (context, state) {
          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              child: switch (state) {
                ForgotPasswordSuccess(:final email) => _buildSuccess(email),
                _ => _buildForm(isLoading: state is ForgotPasswordLoading),
              },
            ),
          );
        },
      ),
    );
  }

  Widget _buildForm({required bool isLoading}) {
    return AutofillGroup(
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const CustomText.subheadline('Esqueceu a senha?'),
            const SizedBox(height: AppSpacing.xs),
            const CustomText(
              'Informe o e-mail da sua conta. Enviaremos um link para criar '
              'uma nova senha.',
              color: AppColors.textSecondary,
            ),
            const SizedBox(height: AppSpacing.xl),
            AppTextField(
              controller: _emailController,
              label: 'E-mail',
              prefixIcon: Icons.email_outlined,
              keyboardType: TextInputType.emailAddress,
              textInputAction: TextInputAction.done,
              autofillHints: const [AutofillHints.email],
              validator: Validators.email,
              onFieldSubmitted: (_) => _submit(),
              enabled: !isLoading,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppButton(
              label: 'Enviar link',
              isLoading: isLoading,
              onPressed: _submit,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSuccess(String email) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const SizedBox(height: AppSpacing.xxl),
        const Icon(
          Icons.mark_email_read_outlined,
          size: 64,
          color: AppColors.success,
        ),
        const SizedBox(height: AppSpacing.md),
        const CustomText.title(
          'Verifique seu e-mail',
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: AppSpacing.sm),
        CustomText(
          'Se existir uma conta para $email, você receberá o link em '
          'instantes.',
          textAlign: TextAlign.center,
          color: AppColors.textSecondary,
        ),
        const SizedBox(height: AppSpacing.xl),
        AppButton(label: 'Voltar ao login', onPressed: _backToLogin),
      ],
    );
  }
}
