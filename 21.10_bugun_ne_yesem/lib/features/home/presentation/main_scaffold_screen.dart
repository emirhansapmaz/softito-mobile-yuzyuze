import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/theme/app_colors.dart';
import '../../favorites/presentation/favorites_screen.dart';
import '../../inventory/presentation/chef_recipes_screen.dart';
import '../../inventory/presentation/inventory_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import 'home_screen.dart';

class MainScaffoldScreen extends ConsumerStatefulWidget {
  const MainScaffoldScreen({super.key});

  @override
  ConsumerState<MainScaffoldScreen> createState() => _MainScaffoldScreenState();
}

class _MainScaffoldScreenState extends ConsumerState<MainScaffoldScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    FavoritesScreen(),
    InventoryScreen(),
    ChefRecipesScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: _pages,
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: isDark ? AppColors.borderDark : AppColors.borderLight,
              width: 1,
            ),
          ),
        ),
        child: NavigationBarTheme(
          data: NavigationBarThemeData(
            labelTextStyle: WidgetStateProperty.resolveWith((states) {
              final isSelected = states.contains(WidgetState.selected);
              return TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected
                    ? AppColors.primary
                    : (isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight),
                letterSpacing: -0.2,
              );
            }),
          ),
          child: NavigationBar(
            selectedIndex: _currentIndex,
            elevation: 0,
            backgroundColor: isDark ? AppColors.surfaceDark : Colors.white,
            indicatorColor: AppColors.primary.withValues(alpha: 0.18),
            labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
            onDestinationSelected: (index) {
              setState(() {
                _currentIndex = index;
              });
            },
            destinations: const [
              NavigationDestination(
                icon: Icon(Icons.home_outlined),
                selectedIcon:
                    Icon(Icons.home_rounded, color: AppColors.primary),
                label: 'Ana Sayfa',
              ),
              NavigationDestination(
                icon: Icon(Icons.favorite_outline_rounded),
                selectedIcon:
                    Icon(Icons.favorite_rounded, color: AppColors.primary),
                label: 'Favoriler',
              ),
              NavigationDestination(
                icon: Icon(Icons.kitchen_outlined),
                selectedIcon:
                    Icon(Icons.kitchen_rounded, color: AppColors.primary),
                label: 'Malzemeler',
              ),
              NavigationDestination(
                icon: Icon(Icons.auto_awesome_outlined),
                selectedIcon:
                    Icon(Icons.auto_awesome_rounded, color: AppColors.primary),
                label: 'Şef Menüsü',
              ),
              NavigationDestination(
                icon: Icon(Icons.person_outline_rounded),
                selectedIcon:
                    Icon(Icons.person_rounded, color: AppColors.primary),
                label: 'Profil',
              ),
            ],
          ),
        ),
      ),
    );
  }
}
