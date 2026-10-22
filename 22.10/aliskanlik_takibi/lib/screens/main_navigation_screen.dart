import 'package:flutter/material.dart';
import '../core/constants/app_colors.dart';
import 'badges/badges_screen.dart';
import 'dashboard/dashboard_screen.dart';
import 'habits/habits_screen.dart';
import 'leaderboard/leaderboard_screen.dart';
import 'settings/settings_screen.dart';

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = const [
    DashboardScreen(),   // Sekme 1: Günün Görevleri
    HabitsScreen(),      // Sekme 2: Alışkanlıklar & Tasarruf
    LeaderboardScreen(), // Sekme 3: Liderlik Tablosu
    BadgesScreen(),      // Sekme 4: Başarılar ve Rozetler
    SettingsScreen(),    // Sekme 5: Hesap ve Ayarlar
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _selectedIndex,
        onDestinationSelected: (index) => setState(() => _selectedIndex = index),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        indicatorColor: isDark
            ? AppColors.sageGreen.withValues(alpha: 0.25)
            : AppColors.sageGreen.withValues(alpha: 0.25),
        elevation: 0,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.check_circle_outline_rounded),
            selectedIcon: Icon(Icons.check_circle_rounded, color: AppColors.deepSage),
            label: 'Görevler',
          ),
          NavigationDestination(
            icon: Icon(Icons.spa_outlined),
            selectedIcon: Icon(Icons.spa_rounded, color: AppColors.deepSage),
            label: 'Alışkanlıklar',
          ),
          NavigationDestination(
            icon: Icon(Icons.leaderboard_outlined),
            selectedIcon: Icon(Icons.leaderboard_rounded, color: AppColors.deepSage),
            label: 'Sıralama',
          ),
          NavigationDestination(
            icon: Icon(Icons.military_tech_outlined),
            selectedIcon: Icon(Icons.military_tech_rounded, color: AppColors.deepSage),
            label: 'Rozetler',
          ),
          NavigationDestination(
            icon: Icon(Icons.settings_outlined),
            selectedIcon: Icon(Icons.settings_rounded, color: AppColors.deepSage),
            label: 'Ayarlar',
          ),
        ],
      ),
    );
  }
}
