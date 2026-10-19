import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/diary/views/diary_view.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MemonologApp());
}

/// memonolog (memory + monolog) uygulamasının ana kök bileşeni.
/// `ValueNotifier<ThemeMode>` ile çift tema desteğini reaktif yönetir.
class MemonologApp extends StatelessWidget {
  const MemonologApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: ThemeController.instance.themeModeNotifier,
      builder: (context, currentThemeMode, _) {
        return MaterialApp(
          title: 'memonolog',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentThemeMode,
          home: DiaryView(),
        );
      },
    );
  }
}

/// Geriye dönük uyumluluk için alias tanımları
typedef MonologApp = MemonologApp;
typedef DijitalGunlukApp = MemonologApp;
