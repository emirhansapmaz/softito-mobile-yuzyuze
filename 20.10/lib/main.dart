import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/auth/view/auth_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const YorungeApp());
}

/// Yörünge Girişimcilik Platformu - Kök Uygulama Bileşeni.
/// `ValueListenableBuilder` ile çift tema ("Derin Uzay" & "Şafak Fırlatışı") reaktif yönetilir.
class YorungeApp extends StatelessWidget {
  const YorungeApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeModeNotifier,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: 'Yörünge Girişimcilik Platformu',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          home: const AuthView(),
        );
      },
    );
  }
}
