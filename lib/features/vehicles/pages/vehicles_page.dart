import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:my_car/utils/routes/name_routes.dart';
import 'package:my_car/design_system/theme/style/colors.dart';

class VehiclesPage extends StatelessWidget {
  const VehiclesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Veículos'),
        backgroundColor: DefaultColors.orange,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => context.go(NameRoutes.login),
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
    );
  }
}
