import 'package:flutter/material.dart';
import 'package:my_car/app/app.dart';
import 'package:my_car/core/di/injection.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencies();
  runApp(const App());
}
