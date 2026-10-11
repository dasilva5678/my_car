import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_car/app/router/route_names.dart';
import 'package:my_car/core/validators/validators.dart';
import 'package:my_car/design_system/design_system.dart';
import 'package:my_car/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_car/features/auth/presentation/bloc/auth_event.dart';
import 'package:my_car/features/auth/presentation/bloc/auth_state.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
          AuthSignUpRequested(
            name: _nameController.text.trim(),
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  void _onStateChanged(BuildContext context, AuthState state) {
    switch (state) {
      case AuthAuthenticated():
        context.showSuccess('Conta criada com sucesso!');
        context.go(RouteNames.vehicles);
      case AuthError(:final failure):
        context.showError(failure.message);
      default:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Criar conta'),
        leading: BackButton(onPressed: () => context.go(RouteNames.login)),
      ),
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: _onStateChanged,
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.xl,
                vertical: AppSpacing.lg,
              ),
              child: AutofillGroup(
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      const CustomText.subheadline('Vamos começar'),
                      const SizedBox(height: AppSpacing.xs),
                      const CustomText(
                        'Crie sua conta para acompanhar as manutenções.',
                        color: AppColors.textSecondary,
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      AppTextField(
                        controller: _nameController,
                        label: 'Nome',
                        prefixIcon: Icons.person_outline,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.name],
                        validator: Validators.name,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppTextField(
                        controller: _emailController,
                        label: 'E-mail',
                        prefixIcon: Icons.email_outlined,
                        keyboardType: TextInputType.emailAddress,
                        textInputAction: TextInputAction.next,
                        autofillHints: const [AutofillHints.email],
                        validator: Validators.email,
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: AppSpacing.md),
                      AppPasswordField(
                        controller: _passwordController,
                        textInputAction: TextInputAction.done,
                        autofillHints: const [AutofillHints.newPassword],
                        validator: (value) => Validators.password(
                          value,
                          minLength: Validators.minPasswordLength,
                        ),
                        onFieldSubmitted: (_) => _submit(),
                        enabled: !isLoading,
                      ),
                      const SizedBox(height: AppSpacing.lg),
                      AppButton(
                        label: 'Criar conta',
                        isLoading: isLoading,
                        onPressed: _submit,
                      ),
                      const SizedBox(height: AppSpacing.sm),
                      AppButton.text(
                        label: 'Já tem uma conta? Faça login',
                        onPressed: isLoading
                            ? null
                            : () => context.go(RouteNames.login),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
