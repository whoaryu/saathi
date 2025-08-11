import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:saathi/core/services/service_provider.dart';
import 'package:saathi/core/theme/app_theme.dart';
import 'package:saathi/features/auth/presentation/providers/auth_provider.dart';
import 'package:saathi/features/auth/presentation/screens/login_screen.dart';
import 'package:saathi/features/auth/presentation/screens/loading_screen.dart';
import 'package:saathi/features/home/presentation/screens/home_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ServiceProvider().initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: 'Saathi',
        theme: AppTheme.lightTheme,
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(),
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<AuthProvider>(
      builder: (context, authProvider, child) {
        if (authProvider.isLoading) {
          return const LoadingScreen();
        }
        
        if (authProvider.isAuthenticated) {
          return const HomeScreen();
        }
        
        return const LoginScreen();
      },
    );
  }
}
