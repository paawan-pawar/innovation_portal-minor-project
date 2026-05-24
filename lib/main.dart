import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme/app_theme.dart';
import 'services/auth_service.dart';
import 'services/innovation_service.dart';
import 'screens/splash_screen.dart';

void main() {
  runApp(const InnovationPortalApp());
}

class InnovationPortalApp extends StatelessWidget {
  const InnovationPortalApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthService()),
        ChangeNotifierProvider(create: (_) => InnovationService()),
      ],
      child: MaterialApp(
        title: 'Innovation Excellence Portal',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: const SplashScreen(),
      ),
    );
  }
}
