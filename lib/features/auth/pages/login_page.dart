import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:my_car/design_system/componets/custom_text.dart';
import 'package:my_car/design_system/theme/style/colors.dart';
import 'package:my_car/utils/routes/name_routes.dart';

import '../bloc/auth_bloc.dart';
import '../bloc/auth_event.dart';
import '../bloc/auth_state.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocConsumer<AuthBloc, AuthState>(
        listener: (context, state) {
          if (state is AuthAuthenticated) {
            context.go(NameRoutes.vehicles);
          }
          if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: CustomText(state.message),
                backgroundColor: DefaultColors.red,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is AuthLoading;

          return SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 32),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(),
                  const Icon(
                    Icons.build_circle_outlined,
                    size: 80,
                    color: DefaultColors.orange,
                  ),
                  const SizedBox(height: 24),
                  const CustomText(
                    'My Car',
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                  const SizedBox(height: 8),
                  const CustomText(
                    'Organize as manutenções dos seus veículos.',
                    textAlign: TextAlign.center,
                    fontSize: 14,
                    colorText: DefaultColors.textColor,
                  ),
                  const SizedBox(height: 24),
                  TextField(
                    controller: _emailController,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: DefaultColors.orange),
                      ),
                      labelText: 'E-mail',
                      prefixIcon:
                          Icon(Icons.email, color: DefaultColors.orange),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: const InputDecoration(
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: DefaultColors.orange),
                      ),
                      labelText: 'Senha',
                      prefixIcon: Icon(Icons.lock, color: DefaultColors.orange),
                    ),
                    style: const TextStyle(color: Colors.white),
                  ),
                  const SizedBox(height: 24),
                  SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                        onPressed: isLoading
                            ? null
                            : () {
                                context.read<AuthBloc>().add(
                                      AuthSignInRequested(
                                        email: _emailController.text.trim(),
                                        password:
                                            _passwordController.text.trim(),
                                      ),
                                    );
                              },
                        child: isLoading
                            ? const CircularProgressIndicator(
                                color: Colors.white,
                              )
                            : const CustomText(
                                'Entrar',
                                colorText: Colors.white,
                                fontSize: 17,
                              )),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.go(NameRoutes.register),
                    child: const CustomText(
                      'Não tem uma conta? Registre-se',
                      fontSize: 14,
                    ),
                  ),
                  const Spacer(),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
