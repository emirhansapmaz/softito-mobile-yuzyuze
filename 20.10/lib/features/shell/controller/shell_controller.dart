// Temel reaktif bildirimciler için Flutter foundation kütüphanesini içeri alıyoruz
import 'package:flutter/foundation.dart';

/// Yörünge Platformu - Shell (Ana Navigasyon) Denetleyicisi.
/// 1. Kural: Saf Dart ve foundation API'si (ValueNotifier) kullanılır.
class ShellController {
  /// Aktif sekme indeksini tutan reaktif bildirimci (0: Mentor, 1: Yatırımcı, 2: Programlar, 3: Topluluk)
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  /// Aktif sekme indeksi değerini okuyan getter
  int get tabIndex => currentIndex.value;

  /// Sekme değiştirme işlevi fonksiyonu
  void changeTab(int index) {
    // İndeks 0 ile 3 arasındaysa ve mevcut sekmeden farklıysa güncelle
    if (index >= 0 && index <= 3 && currentIndex.value != index) {
      // Yeni aktif sekme indeksini ata
      currentIndex.value = index;
    } // if sonu
  } // changeTab metodu kapanışı

  /// Denetleyiciyi ve bildirimcileri bellekten temizler
  void dispose() {
    // İndeks bildirimcisini serbest bırakıyoruz
    currentIndex.dispose();
  } // dispose metodu kapanışı
} // ShellController sınıfı kapanışı
