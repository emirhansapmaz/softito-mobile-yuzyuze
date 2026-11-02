// Flutter'ın temel materyal arayüz kütüphanesini içeri alıyoruz
import 'package:flutter/material.dart';
// Uygulama tema renk uzantısı olan SpaceColors sınıfını içeri alıyoruz
import '../constants/app_colors.dart';

/// `BuildContext` üzerine eklenen kozmik tema, tipografi ve ekran ölçüsü yardımcıları.
/// 2. Kural gereği: UI katmanında doğrudan renk ve stil yazılmaz; bu uzantılar kullanılır.
extension BuildContextExt on BuildContext {
  /// Yörünge uzay renk paletine erişim (`context.spaceColors`)
  SpaceColors get spaceColors {
    // Mevcut temadan SpaceColors uzantısını okuyoruz
    final colors = Theme.of(this).extension<SpaceColors>();
    // Eğer uzantı tanımlıysa doğrudan onu döndür
    if (colors != null) return colors;
    // Tanımlı değilse parlaklığa göre varsayılan dark veya light renk setini dön
    return Theme.of(this).brightness == Brightness.dark
        ? SpaceColors.dark
        : SpaceColors.light;
  } // spaceColors getter kapanışı

  /// Material 3 tipografi temasına kolay erişim (`context.textTheme`)
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// Aktif ThemeData nesnesine doğrudan erişim (`context.theme`)
  ThemeData get theme => Theme.of(this);

  /// Koyu tema ("Derin Uzay") aktif mi kontrolü (`context.isDarkMode`)
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;

  /// Cihazın ekran genişliğini piksel olarak döndürür (`context.screenWidth`)
  double get screenWidth => MediaQuery.sizeOf(this).width;

  /// Cihazın ekran yüksekliğini piksel olarak döndürür (`context.screenHeight`)
  double get screenHeight => MediaQuery.sizeOf(this).height;

  /// Cihaz çentik ve sistem çubuğu güvenli alan boşlukları (`context.screenPadding`)
  EdgeInsets get screenPadding => MediaQuery.paddingOf(this);
} // BuildContextExt extension kapanışı
