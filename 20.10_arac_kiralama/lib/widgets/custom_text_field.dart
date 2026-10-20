// Flutter materyal tasarım kütüphanesini içe aktarıyoruz.
import 'package:flutter/material.dart';
// Uygulama renk paletini içe aktarıyoruz.
import '../core/theme/app_colors.dart';

/// Form girişlerinde tutarlı bir görünüm ve tema uyumu sağlayan özel metin giriş kutusu (TextFormField) bileşeni.
class CustomTextField extends StatelessWidget {
  /// Giriş alanının metnini kontrol eden ve okuyan controller
  final TextEditingController controller;
  
  /// Giriş kutusu üzerinde/içinde görünen etiket başlığı (örn: 'E-posta', 'Şifre')
  final String labelText;
  
  /// Kullanıcıya ne yazması gerektiğini belirten silik ipucu metni
  final String? hintText;
  
  /// Giriş kutusunun sol tarafında görüntülenecek ikon
  final IconData? prefixIcon;
  
  /// Giriş kutusunun sağ tarafında görüntülenecek bileşen (örn: şifre gizleme/gösterme butonu)
  final Widget? suffixIcon;
  
  /// Şifre girişlerinde karakterlerin gizlenip gizlenmeyeceğini belirleyen bayrak
  final bool obscureText;
  
  /// Açılacak klavye türü (örn: e-posta, sayısal, standart metin)
  final TextInputType keyboardType;
  
  /// Form doğrulama (validation) fonksiyonu; hata varsa hata mesajı döndürür
  final String? Function(String?)? validator;
  
  /// Kullanıcı her karakter yazdığında veya sildiğinde tetiklenen geri çağırma fonksiyonu
  final void Function(String)? onChanged;
  
  /// Giriş alanının alabileceği maksimum satır sayısı (varsayılan: 1)
  final int maxLines;
  
  /// Alanın sadece okunabilir (düzenlenemez) olup olmadığını belirten bayrak
  final bool readOnly;
  
  /// Klavyedeki onay/tamam butonunun aksiyonu (örn: next, done, search)
  final TextInputAction? textInputAction;

  /// CustomTextField kurucu metodu (Constructor)
  const CustomTextField({
    super.key,
    required this.controller,
    required this.labelText,
    this.hintText,
    this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.validator,
    this.onChanged,
    this.maxLines = 1,
    this.readOnly = false,
    this.textInputAction,
  });

  @override
  Widget build(BuildContext context) {
    // Mevcut aktif temanın koyu mod olup olmadığını sorguluyoruz.
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      keyboardType: keyboardType,
      validator: validator,
      onChanged: onChanged,
      maxLines: maxLines,
      readOnly: readOnly,
      textInputAction: textInputAction,
      // Kullanıcının yazdığı metnin stili ve tema uyumlu yazı rengi
      style: TextStyle(
        fontSize: 15,
        color: isDark ? AppColors.textLight : AppColors.textDark,
        fontWeight: FontWeight.w500,
      ),
      // Giriş kutusunun görsel süslemesi
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        // Sol ikon verilmişse tema uyumlu renkte oluşturuyoruz.
        prefixIcon: prefixIcon != null
            ? Icon(
                prefixIcon,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                size: 20,
              )
            : null,
        // Sağ taraftaki widget (örn: göz ikonu)
        suffixIcon: suffixIcon,
      ),
    );
  }
}
