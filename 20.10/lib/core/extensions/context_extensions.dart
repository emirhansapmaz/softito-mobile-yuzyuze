import 'package:flutter/material.dart';
import '../constants/app_colors.dart';

/// `BuildContext` üzerine eklenen kozmik tema, tipografi ve ekran ölçüsü yardımcıları.
/// 2. Kural gereği: UI katmanında doğrudan renk ve stil yazılmaz; bu uzantılar kullanılır.
extension BuildContextExt on BuildContext {
  /// Yörünge uzay renk paletine erişim (`context.spaceColors`)
  SpaceColors get spaceColors {
    final colors = Theme.of(this).extension<SpaceColors>();
    if (colors != null) return colors;
    return Theme.of(this).brightness == Brightness.dark
        ? SpaceColors.dark
        : SpaceColors.light;
  }

  /// Material 3 tipografi temasına erişim (`context.textTheme`)
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Aktif ThemeData nesnesine erişim
  ThemeData get theme => Theme.of(this);

  /// Koyu tema ("Derin Uzay") aktif mi?
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Ekran genişliği
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Ekran yüksekliği
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Cihaz çentik/güvenli alan boşlukları
  EdgeInsets get screenPadding => MediaQuery.paddingOf(this);
}
