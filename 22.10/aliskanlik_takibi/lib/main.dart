import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'core/constants/app_constants.dart';
import 'core/services/firebase_initializer.dart';
import 'core/theme/app_theme.dart';
import 'screens/auth/login_screen.dart';
import 'screens/main_navigation_screen.dart';
import 'services/firebase/auth_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Türkçe tarih formatı başlatma
  await initializeDateFormatting('tr_TR', null);

  // Firebase Başlatma
  await FirebaseInitializer.initialize();

  runApp(
    const ProviderScope(
      child: AliskanlikTakibiApp(),
    ),
  );
}

class AliskanlikTakibiApp extends StatelessWidget {
  const AliskanlikTakibiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system,
      home: const AuthWrapper(),
    );
  }
}

/// Firebase oturum durumunu dinleyerek kullanıcıyı ilgili ekrana yönlendiren sarmalayıcı
class AuthWrapper extends StatelessWidget {
  const AuthWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = AuthService();

    return StreamBuilder<User?>(
      stream: authService.authStateChanges,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }

        // Kullanıcı oturumu açık ise 5 sekmeli ana ekrana yönlendirilir
        if (snapshot.hasData && snapshot.data != null) {
          return const MainNavigationScreen();
        }

        // Giriş yapılmamışsa Login ekranı gösterilir
        return const LoginScreen();
      },
    );
  }
}
