import 'package:flutter/material.dart';
import 'screens/auth/login_screen.dart';
import 'screens/home/home_screen.dart';
import 'utils/colors.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Gestion Immobilière',
      theme: ThemeData(
        primaryColor: AppColors.primary,
        scaffoldBackgroundColor: AppColors.background,
        fontFamily: 'Poppins',
      ),
      home: const LoginScreen(),
      debugShowCheckedModeBanner: false,
      // AJOUTEZ CES ROUTES :
      routes: {
        '/home': (context) {
          final user = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>?;
          return HomeScreen(user: user ?? {});
        },
      },
      onGenerateRoute: (settings) {
        // Gérer les routes non définies
        return MaterialPageRoute(
          builder: (context) => const LoginScreen(),
        );
      },
    );
  }
}