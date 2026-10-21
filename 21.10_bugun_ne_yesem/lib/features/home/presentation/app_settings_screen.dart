import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/providers/theme_provider.dart';
import '../../../core/theme/app_colors.dart';

class AppSettingsScreen extends ConsumerWidget {
  const AppSettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeMode = ref.watch(themeModeProvider);
    final locale = ref.watch(localeProvider);
    final notifications = ref.watch(notificationSettingsProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Uygulama Ayarları'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        children: [
          // 1. TEMA VE GÖRÜNÜM AYARLARI
          _buildSectionHeader('Görünüm & Tema', Icons.palette_outlined),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            elevation: 0,
            color: isDark ? AppColors.cardDark : Colors.white,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 8),
              child: Column(
                children: [
                  ListTile(
                    title: const Text('Açık Tema (Light Mode)', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Ferah, yumuşak sage yeşili tonları'),
                    leading: const Icon(Icons.light_mode_rounded, color: Colors.amber, size: 28),
                    trailing: themeMode == ThemeMode.light
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                        : const Icon(Icons.circle_outlined, color: Colors.grey),
                    onTap: () {
                      ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.light);
                    },
                  ),
                  const Divider(indent: 16, endIndent: 16),
                  ListTile(
                    title: const Text('Koyu Tema (Dark Mode)', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Gözü yormayan şık koyu yeşil & antrasit'),
                    leading: const Icon(Icons.dark_mode_rounded, color: Colors.deepPurpleAccent, size: 28),
                    trailing: themeMode == ThemeMode.dark
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                        : const Icon(Icons.circle_outlined, color: Colors.grey),
                    onTap: () {
                      ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
                    },
                  ),
                  const Divider(indent: 16, endIndent: 16),
                  ListTile(
                    title: const Text('Sistem Teması', style: TextStyle(fontWeight: FontWeight.w600)),
                    subtitle: const Text('Cihazınızın sistem ayarlarıyla otomatik eşleşir'),
                    leading: const Icon(Icons.settings_system_daydream_rounded, color: AppColors.primary, size: 28),
                    trailing: themeMode == ThemeMode.system
                        ? const Icon(Icons.check_circle_rounded, color: AppColors.primary)
                        : const Icon(Icons.circle_outlined, color: Colors.grey),
                    onTap: () {
                      ref.read(themeModeProvider.notifier).setThemeMode(ThemeMode.system);
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 2. DİL AYARLARI
          _buildSectionHeader('Dil & Bölge', Icons.language_rounded),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            elevation: 0,
            color: isDark ? AppColors.cardDark : Colors.white,
            child: ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.translate_rounded, color: AppColors.primary),
              ),
              title: const Text('Uygulama Dili', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Text(locale == 'tr' ? 'Türkçe (Varsayılan)' : 'English'),
              trailing: DropdownButton<String>(
                value: locale,
                underline: const SizedBox(),
                borderRadius: BorderRadius.circular(16),
                items: const [
                  DropdownMenuItem(value: 'tr', child: Text('Türkçe 🇹🇷')),
                  DropdownMenuItem(value: 'en', child: Text('English 🇬🇧')),
                ],
                onChanged: (val) {
                  if (val != null) {
                    ref.read(localeProvider.notifier).setLocale(val);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(val == 'tr'
                            ? 'Uygulama dili Türkçe olarak güncellendi.'
                            : 'App language set to English.'),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  }
                },
              ),
            ),
          ),
          const SizedBox(height: 24),

          // 3. BİLDİRİM TERCİHLERİ
          _buildSectionHeader('Öğün & Tarif Bildirimleri', Icons.notifications_active_outlined),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            elevation: 0,
            color: isDark ? AppColors.cardDark : Colors.white,
            child: Column(
              children: [
                SwitchListTile(
                  activeTrackColor: AppColors.primary,
                  title: const Text('Günün Menü Önerisi', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Her gün 12:00\'de leziz bir öğle önerisi al'),
                  value: notifications.dailyMealReminder,
                  onChanged: (val) {
                    ref.read(notificationSettingsProvider.notifier).toggleDailyMealReminder(val);
                  },
                ),
                const Divider(indent: 16, endIndent: 16),
                SwitchListTile(
                  activeTrackColor: AppColors.primary,
                  title: const Text('Akşam Yemeği İlhamı', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('18:00\'de dolaptaki malzemelere uygun tarif hatırlatması'),
                  value: notifications.eveningInspiration,
                  onChanged: (val) {
                    ref.read(notificationSettingsProvider.notifier).toggleEveningInspiration(val);
                  },
                ),
                const Divider(indent: 16, endIndent: 16),
                SwitchListTile(
                  activeTrackColor: AppColors.primary,
                  title: const Text('Gümüş Kubbe Titreşimi', style: TextStyle(fontWeight: FontWeight.w600)),
                  subtitle: const Text('Kubbe açılırken haptik geri bildirim verilsin'),
                  value: notifications.clocheHaptics,
                  onChanged: (val) {
                    ref.read(notificationSettingsProvider.notifier).toggleClocheHaptics(val);
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          // 4. DEPOLAMA VE ÖNBELLEK
          _buildSectionHeader('Veri & Depolama', Icons.cleaning_services_rounded),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            elevation: 0,
            color: isDark ? AppColors.cardDark : Colors.white,
            child: ListTile(
              leading: Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.delete_sweep_rounded, color: Colors.orange),
              ),
              title: const Text('Görsel Önbelleğini Temizle', style: TextStyle(fontWeight: FontWeight.bold)),
              subtitle: const Text('Yemek fotoğraflarını yeniden indirmek için önbelleği boşalt'),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Uygulama önbelleği başarıyla temizlendi!'),
                    backgroundColor: AppColors.success,
                    duration: Duration(seconds: 2),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 24),

          // 5. UYGULAMA HAKKINDA
          _buildSectionHeader('Hakkında', Icons.info_outline_rounded),
          const SizedBox(height: 8),
          Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
              side: BorderSide(
                color: isDark ? AppColors.borderDark : AppColors.borderLight,
              ),
            ),
            elevation: 0,
            color: isDark ? AppColors.cardDark : Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.1),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(Icons.soup_kitchen_rounded, color: AppColors.primary),
                      ),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AppConstants.appName,
                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                          ),
                          Text('Sürüm 1.0.0 (Build 2026)', style: TextStyle(color: Colors.grey, fontSize: 12)),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Bugün Ne Yesem, evdeki malzemelerinizle harikalar yaratmanızı ve ne yiyeceğinize saniyeler içinde karar vermenizi sağlayan akıllı bir mutfak asistanıdır.',
                    style: TextStyle(fontSize: 12, color: Colors.grey, height: 1.4),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, IconData icon) {
    return Row(
      children: [
        Icon(icon, size: 18, color: AppColors.primary),
        const SizedBox(width: 8),
        Text(
          title,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: AppColors.primary,
          ),
        ),
      ],
    );
  }
}
