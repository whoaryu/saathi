import 'package:flutter/material.dart';
import 'package:saathi/core/services/service_provider.dart';
import 'package:saathi/core/theme/app_theme.dart';
import 'package:saathi/features/auth/presentation/screens/login_screen.dart';
import 'package:saathi/features/pet_adoption/presentation/screens/pet_list_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceProvider().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Saathi',
      theme: AppTheme.lightTheme,
      debugShowCheckedModeBanner: false,
      home: const AuthWrapper(),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    // Bypass login for development
    // return ServiceProvider().authService.isLoggedIn
    //     ? const PetListScreen()
    //     : const LoginScreen();
    return const PetListScreen();
  }
}
