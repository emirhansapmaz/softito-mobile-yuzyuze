import 'package:flutter/foundation.dart';

/// Yörünge Platformu - Shell (Ana Navigasyon) Denetleyicisi.
/// 1. Kural: Saf Dart ve foundation API'si (ValueNotifier) kullanılır.
class ShellController {
  /// Aktif sekme indeksini tutan reaktif bildirimci (0: Mentor, 1: Yatırımcı, 2: Programlar, 3: Topluluk)
  final ValueNotifier<int> currentIndex = ValueNotifier<int>(0);

  /// Aktif sekme indeksi değeri
  int get tabIndex => currentIndex.value;

  /// Sekme değiştirme işlevi
  void changeTab(int index) {
    if (index >= 0 && index <= 3 && currentIndex.value != index) {
      currentIndex.value = index;
    }
  }

  /// Denetleyiciyi ve bildirimcileri bellekten temizler
  void dispose() {
    currentIndex.dispose();
  }
}
