import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_car/app/router/route_names.dart';
import 'package:my_car/core/validators/validators.dart';
import 'package:my_car/design_system/design_system.dart';
import 'package:my_car/features/auth/presentation/bloc/auth_bloc.dart';
import 'package:my_car/features/auth/presentation/bloc/auth_event.dart';
import 'package:my_car/features/auth/presentation/bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _submit() {
    FocusScope.of(context).unfocus();
    if (!_formKey.currentState!.validate()) return;

    context.read<AuthBloc>().add(
          AuthSignInRequested(
            email: _emailController.text.trim(),
            password: _passwordController.text,
          ),
        );
  }

  void _onStateChanged(BuildContext context, AuthState state) {
    switch (state) {
      case AuthAuthenticated():
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
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: _onStateChanged,
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: Center(
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
                        const Icon(
                          Icons.build_circle_outlined,
                          size: 80,
                          color: AppColors.primary,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        const CustomText.headline(
                          'My Car',
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        const CustomText(
                          'Organize as manutenções dos seus veículos.',
                          textAlign: TextAlign.center,
                          color: AppColors.textSecondary,
                        ),
                        const SizedBox(height: AppSpacing.xl),
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
                          validator: Validators.password,
                          onFieldSubmitted: (_) => _submit(),
                          enabled: !isLoading,
                        ),
                        const SizedBox(height: AppSpacing.lg),
                        AppButton(
                          label: 'Entrar',
                          isLoading: isLoading,
                          onPressed: _submit,
                        ),
                        const SizedBox(height: AppSpacing.sm),
                        AppButton.text(
                          label: 'Não tem uma conta? Registre-se',
                          onPressed: isLoading
                              ? null
                              : () => context.go(RouteNames.register),
                        ),
                      ],
                    ),
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
