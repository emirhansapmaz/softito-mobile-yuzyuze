// Flutter'ın temel materyal arayüz kütüphanesini içeri alıyoruz
import 'package:flutter/material.dart';
// Standart boşluk ve kenarlık yarıçapı değerlerini içeri alıyoruz
import '../../../core/constants/app_spacing.dart';
// BuildContext tema ve tipografi yardımcı uzantılarını içeri alıyoruz
import '../../../core/extensions/context_extensions.dart';

/// Yörünge Platformu - Özel Giriş Alanı (Email / Şifre).
/// 2. Kural: Sabit renk ve stil kullanılmaz.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class AuthTextField extends StatefulWidget {
  // Metin kontrolcüsü
  final TextEditingController controller;
  // Alan etiketi (başlığı)
  final String label;
  // İpucu metni (placeholder)
  final String hint;
  // Sol tarafta gösterilecek simge
  final IconData prefixIcon;
  // Şifre alanı mı gizlenecek mi bayrağı
  final bool isPassword;
  // Açılacak klavye tipi
  final TextInputType keyboardType;

  // AuthTextField kurucu metodu
  const AuthTextField({
    super.key,
    required this.controller,
    required this.label,
    required this.hint,
    required this.prefixIcon,
    this.isPassword = false,
    this.keyboardType = TextInputType.text,
  }); // Kurucu metod kapanışı

  // Durum nesnesini bağlayan metot
  @override
  State<AuthTextField> createState() => _AuthTextFieldState();
} // AuthTextField sınıfı kapanışı

// Giriş alanının durum sınıfı
class _AuthTextFieldState extends State<AuthTextField> {
  // Şifrenin gizli mi açık mı olduğunu tutan bayrak
  bool _obscureText = true;

  // Arayüzü inşa eden build metodu
  @override
  Widget build(BuildContext context) {
    // Uzay renk paleti
    final colors = context.spaceColors;
    // Tipografi teması
    final textTheme = context.textTheme;

    // Etiket ve metin kutusunu alt alta dizen kolon
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Alan başlığı etiketi
        Text(
          widget.label,
          style: textTheme.labelMedium?.copyWith(
            color: colors.textSecondary,
            fontWeight: FontWeight.w600,
          ), // copyWith kapanışı
        ), // Text kapanışı
        // 8 piksel dikey boşluk
        AppSpacing.gapH8,
        // Metin giriş kutusu
        TextField(
          controller: widget.controller,
          obscureText: widget.isPassword && _obscureText,
          keyboardType: widget.keyboardType,
          style: textTheme.bodyMedium?.copyWith(color: colors.textPrimary),
          decoration: _buildInputDecoration(colors, textTheme),
        ), // TextField kapanışı
      ], // Column çocukları kapanışı
    ); // Column kapanışı
  } // build metodu kapanışı

  // Giriş kutusunun görsel dekorasyonunu üreten yardımcı metot
  InputDecoration _buildInputDecoration(dynamic colors, TextTheme textTheme) {
    return InputDecoration(
      // İpucu metni
      hintText: widget.hint,
      // İpucu stili
      hintStyle: textTheme.bodyMedium?.copyWith(
        color: colors.textSecondary.withValues(alpha: 0.5),
      ), // copyWith kapanışı
      // Sol ikon
      prefixIcon: Icon(widget.prefixIcon, color: colors.textSecondary, size: 20),
      // Şifre alanıysa göz ikonu, değilse null
      suffixIcon: widget.isPassword
          ? IconButton(
              icon: Icon(
                _obscureText ? Icons.visibility_off : Icons.visibility,
                color: colors.textSecondary,
                size: 20,
              ), // Icon kapanışı
              onPressed: () => setState(() => _obscureText = !_obscureText),
            ) // IconButton kapanışı
          : null,
      // Dolgu rengi aktif
      filled: true,
      fillColor: colors.cardBackground,
      // İç boşluk
      contentPadding: AppSpacing.paddingHorizontalMd.add(AppSpacing.paddingVerticalSm),
      // Normal kenarlık
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        borderSide: BorderSide(color: colors.border),
      ), // OutlineInputBorder kapanışı
      // Odaklanılmış mavi kenarlık
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        borderSide: BorderSide(color: colors.primary, width: 1.5),
      ), // OutlineInputBorder kapanışı
    ); // InputDecoration kapanışı
  } // _buildInputDecoration metodu kapanışı
} // _AuthTextFieldState sınıfı kapanışı
