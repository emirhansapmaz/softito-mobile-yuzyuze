// Flutter temel Material bileşenlerini içeren kütüphaneyi içe aktarıyoruz
import 'package:flutter/material.dart';
// Modern reaktif durum yönetimi için Riverpod paketini içe aktarıyoruz
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Tema modunu (Açık veya Koyu) yöneten Riverpod Notifier sınıfımız
class ThemeModeNotifier extends Notifier<ThemeMode> {
  // Notifier ilk kez başlatıldığında çalışıp varsayılan durumu belirleyen build metodu
  @override
  // Varsayılan tema olarak koyu (dark) temayı seçiyoruz
  ThemeMode build() {
    // Koyu tema modu
    return ThemeMode.dark;
  // build kapanış parantezi
  }

  // Kullanıcı açıkça bir tema modu seçtiğinde durumu güncelleyen fonksiyon
  void setThemeMode(ThemeMode mode) {
    // State'e yeni seçilen temayı atıyoruz
    state = mode;
  // setThemeMode metodunun kapanış parantezi
  }

  // Açık ve koyu tema arasında tek dokunuşla geçiş yapan fonksiyonumuz
  void toggleTheme() {
    // Eğer şu an koyu temadaysak açık temaya geçiriyoruz
    if (state == ThemeMode.dark) {
      // Açık tema ataması
      state = ThemeMode.light;
    // Açık temadaysak koyu temaya geçiriyoruz
    } else {
      // Koyu tema ataması
      state = ThemeMode.dark;
    // if-else kapanışı
    }
  // toggleTheme metodunun kapanış parantezi
  }

  // O anki temanın koyu olup olmadığını kontrol eden pratik getter
  bool get isDarkMode => state == ThemeMode.dark;
// ThemeModeNotifier sınıfının kapanış parantezi
}

// Uygulamanın her yerinden tema durumunu okumamızı ve değiştirmemizi sağlayan Riverpod sağlayıcısı
final themeModeProvider =
    NotifierProvider<ThemeModeNotifier, ThemeMode>(ThemeModeNotifier.new);

// Uygulamanın dil tercihini (TR / EN) yöneten Notifier sınıfımız
class LocaleNotifier extends Notifier<String> {
  // Varsayılan dili belirleyen build metodu
  @override
  // Varsayılan olarak Türkçe ('tr') dil kodunu veriyoruz
  String build() => 'tr';

  // Dili değiştiren fonksiyon
  void setLocale(String langCode) {
    // Yeni dil kodunu state'e atıyoruz
    state = langCode;
  // setLocale metodunun kapanış parantezi
  }
// LocaleNotifier sınıfının kapanış parantezi
}

// Dil durumunu uygulamanın geneline sunan Riverpod sağlayıcısı
final localeProvider =
    NotifierProvider<LocaleNotifier, String>(LocaleNotifier.new);

// Kullanıcının bildirim ve titreşim tercihlerini tutan değişmez ayar sınıfımız
class NotificationSettings {
  // Günlük yemek önerisi bildirimi açık mı
  final bool dailyMealReminder;
  // Akşam ilhamı ve alternatif tarif bildirimi açık mı
  final bool eveningInspiration;
  // Gümüş kubbe kapağı açılırken dokunsal titreşim (Haptics) verilsin mi
  final bool clocheHaptics;

  // NotificationSettings sınıfının değişmez kurucu metodu
  const NotificationSettings({
    // Günlük yemek hatırlatıcı varsayılan açık
    this.dailyMealReminder = true,
    // Akşam ilhamı varsayılan açık
    this.eveningInspiration = true,
    // Kubbe titreşimi varsayılan açık
    this.clocheHaptics = true,
  // Kurucu metodun kapanış parantezi
  });

  // Ayarları güncelleyip yeni kopya üreten copyWith yardımcı metodu
  NotificationSettings copyWith({
    // İsteğe bağlı yeni yemek hatırlatıcısı
    bool? dailyMealReminder,
    // İsteğe bağlı yeni akşam ilhamı
    bool? eveningInspiration,
    // İsteğe bağlı yeni titreşim ayarı
    bool? clocheHaptics,
  // copyWith parametreleri kapanışı
  }) {
    // Yeni değerler verilmişse onları, verilmemişse mevcut olanları koruyoruz
    return NotificationSettings(
      // dailyMealReminder güncellemesi
      dailyMealReminder: dailyMealReminder ?? this.dailyMealReminder,
      // eveningInspiration güncellemesi
      eveningInspiration: eveningInspiration ?? this.eveningInspiration,
      // clocheHaptics güncellemesi
      clocheHaptics: clocheHaptics ?? this.clocheHaptics,
    // NotificationSettings çağrısı kapanışı
    );
  // copyWith metodunun kapanış parantezi
  }
// NotificationSettings sınıfının kapanış parantezi
}

// Bildirim ayarları durumunu yöneten Riverpod Notifier sınıfımız
class NotificationSettingsNotifier extends Notifier<NotificationSettings> {
  // Başlangıç ayarlarını belirleyen build fonksiyonu
  @override
  // Varsayılan ayar nesnesini oluşturuyoruz
  NotificationSettings build() => const NotificationSettings();

  // Günlük yemek hatırlatıcısını açıp kapatan fonksiyon
  void toggleDailyMealReminder(bool value) {
    // State'i yeni değerle güncelliyoruz
    state = state.copyWith(dailyMealReminder: value);
  // toggleDailyMealReminder kapanışı
  }

  // Akşam ilhamı bildirimini açıp kapatan fonksiyon
  void toggleEveningInspiration(bool value) {
    // State'i yeni değerle güncelliyoruz
    state = state.copyWith(eveningInspiration: value);
  // toggleEveningInspiration kapanışı
  }

  // Kubbe titreşimini açıp kapatan fonksiyon
  void toggleClocheHaptics(bool value) {
    // State'i yeni değerle güncelliyoruz
    state = state.copyWith(clocheHaptics: value);
  // toggleClocheHaptics kapanışı
  }
// NotificationSettingsNotifier sınıfının kapanış parantezi
}

// Bildirim ayarları durumunu tüm ekranlara ulaştıran Riverpod sağlayıcımız
final notificationSettingsProvider =
    NotifierProvider<NotificationSettingsNotifier, NotificationSettings>(
  NotificationSettingsNotifier.new,
// notificationSettingsProvider kapanışı
);
