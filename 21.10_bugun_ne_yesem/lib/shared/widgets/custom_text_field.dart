// Flutter Material temel bileşenler kütüphanesini içe aktarıyoruz
import 'package:flutter/material.dart';
// Uygulama tema renklerini içe aktarıyoruz
import '../../core/theme/app_colors.dart';

// Formlarda ve arama ekranlarında kullandığımız, etiketli ve modern metin giriş kutusu bileşenimiz
class CustomTextField extends StatelessWidget {
  // Metin kutusunun içeriğini yöneten kontrolcü
  final TextEditingController? controller;
  // Metin kutusunun üzerinde yer alan başlık etiketi
  final String label;
  // Kutunun içinde silik görünen ipucu metni
  final String? hint;
  // Kutunun sol başında belirecek ikon
  final IconData? prefixIcon;
  // Kutunun sağ tarafında belirecek opsiyonel widget (örn: şifre göster/gizle ikonu)
  final Widget? suffixIcon;
  // Şifre girişlerinde karakterleri gizleme durumu (true ise noktalarla gizler)
  final bool obscureText;
  // Klavye türü (e-posta, sayısal, standart metin vb.)
  final TextInputType keyboardType;
  // Form doğrulama (validation) kural fonksiyonu
  final String? Function(String?)? validator;
  // Metin kutusunun maksimum satır sayısı
  final int maxLines;
  // Metin değiştikçe tetiklenen fonksiyon
  final void Function(String)? onChanged;

  // CustomTextField sınıfının değişmez kurucu metodu
  const CustomTextField({
    // Widget ağacı anahtarı
    super.key,
    // Kontrolcü parametresi
    this.controller,
    // Etiket alanının zorunlu olduğunu belirtiyoruz
    required this.label,
    // İpucu metni parametresi
    this.hint,
    // Sol ikon parametresi
    this.prefixIcon,
    // Sağ ikon parametresi
    this.suffixIcon,
    // Şifre gizleme varsayılan false
    this.obscureText = false,
    // Klavye türü varsayılan metin
    this.keyboardType = TextInputType.text,
    // Doğrulayıcı fonksiyon parametresi
    this.validator,
    // Satır sayısı varsayılan 1
    this.maxLines = 1,
    // Değişim dinleyici fonksiyonu
    this.onChanged,
  // Kurucu metodun kapanış parantezi
  });

  // Ekranın görsel yapısını inşa eden build fonksiyonu
  @override
  // BuildContext parametresini alan ve Widget döndüren build metodu
  Widget build(BuildContext context) {
    // Aktif temanın koyu tema olup olmadığını kontrol ediyoruz
    final isDark = Theme.of(context).brightness == Brightness.dark;

    // Etiket ve metin kutusunu dikeyde alt alta dizen Column
    return Column(
      // Elemanları sola hizalıyoruz
      crossAxisAlignment: CrossAxisAlignment.start,
      // Sütun elemanları listesi
      children: [
        // Metin kutusunun üstündeki açıklayıcı etiket metni
        Text(
          // Etiket başlığı
          label,
          // Etiket yazı stili
          style: TextStyle(
            // 14 punto boyut
            fontSize: 14,
            // Yarı kalın font
            fontWeight: FontWeight.w600,
            // Temaya göre açık veya koyu ikincil metin rengi
            color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
          // TextStyle kapanışı
          ),
        // Text kapanışı
        ),
        // Etiket ile metin kutusu arasına 8 piksel boşluk
        const SizedBox(height: 8),

        // Form işlemlerini ve doğrulamayı destekleyen TextFormField
        TextFormField(
          // Metin kontrolcümüzü bağlıyoruz
          controller: controller,
          // Şifre gizleme özelliğini uyguluyoruz
          obscureText: obscureText,
          // Klavye türünü ayarlıyoruz
          keyboardType: keyboardType,
          // Satır sayısını uyguluyoruz
          maxLines: maxLines,
          // Doğrulama kuralını bağlıyoruz
          validator: validator,
          // Metin değiştikçe çalışan fonksiyonu bağlıyoruz
          onChanged: onChanged,
          // Metin kutusu görsel dekorasyon ayarları
          decoration: InputDecoration(
            // İpucu metni
            hintText: hint,
            // İpucu yazı stili
            hintStyle: TextStyle(
              // Temaya göre hafif silik ipucu rengi
              color: isDark ? Colors.white30 : Colors.black26,
              // 14 punto boyut
              fontSize: 14,
            // TextStyle kapanışı
            ),
            // Sol taraftaki ikon
            prefixIcon: prefixIcon != null
                // Verilmişse ana renkte ikon çiziyoruz
                ? Icon(prefixIcon, color: AppColors.primary, size: 22)
                // Verilmemişse null
                : null,
            // Sağ taraftaki widget
            suffixIcon: suffixIcon,
            // Arka planın dolgulu olmasını sağlıyoruz
            filled: true,
            // Koyu temada koyu kart rengi, açık temada beyaz arka plan
            fillColor: isDark ? AppColors.cardDark : Colors.white,
          // InputDecoration kapanışı
          ),
        // TextFormField kapanışı
        ),
      // Column çocukları kapanışı
      ],
    // Column kapanışı
    );
  // build metodu kapanış parantezi
  }
// CustomTextField sınıfının kapanış parantezi
}
