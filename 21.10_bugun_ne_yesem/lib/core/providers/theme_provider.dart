import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ThemeModeNotifier extends Notifier<ThemeMode> {
  @override
  ThemeMode build() {
    return ThemeMode.dark;
  }

  void setThemeMode(ThemeMode mode) {
    state = mode;
  }

  void toggleTheme() {
    if (state == ThemeMode.dark) {
      state = ThemeMode.light;
    } else {
      state = ThemeMode.dark;
    }
  }

  bool get isDarkMode => state == ThemeMode.dark;
}

final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

// Dil Ayarı Notifier
class LocaleNotifier extends Notifier<String> {
  @override
  String build() => 'tr';

  void setLocale(String langCode) {
    state = langCode;
  }
}

final localeProvider =
    NotifierProvider<LocaleNotifier, String>(LocaleNotifier.new);

// Bildirim Ayarları Notifier
class NotificationSettings {
  final bool dailyMealReminder;
  final bool eveningInspiration;
  final bool clocheHaptics;

  const NotificationSettings({
    this.dailyMealReminder = true,
    this.eveningInspiration = true,
    this.clocheHaptics = true,
  });

  NotificationSettings copyWith({
    bool? dailyMealReminder,
    bool? eveningInspiration,
    bool? clocheHaptics,
  }) {
    return NotificationSettings(
      dailyMealReminder: dailyMealReminder ?? this.dailyMealReminder,
      eveningInspiration: eveningInspiration ?? this.eveningInspiration,
      clocheHaptics: clocheHaptics ?? this.clocheHaptics,
    );
  }
}

class NotificationSettingsNotifier extends Notifier<NotificationSettings> {
  @override
  NotificationSettings build() => const NotificationSettings();

  void toggleDailyMealReminder(bool value) {
    state = state.copyWith(dailyMealReminder: value);
  }

  void toggleEveningInspiration(bool value) {
    state = state.copyWith(eveningInspiration: value);
  }

  void toggleClocheHaptics(bool value) {
    state = state.copyWith(clocheHaptics: value);
  }
}

final notificationSettingsProvider =
    NotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
  NotificationSettingsNotifier.new,
);
