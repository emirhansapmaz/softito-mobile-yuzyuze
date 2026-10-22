import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../models/habit_model.dart';
import '../../services/firebase/habit_service.dart';
import '../../widgets/common/custom_button.dart';
import '../../widgets/common/custom_text_field.dart';

class AddHabitBottomSheet extends StatefulWidget {
  final String uid;

  const AddHabitBottomSheet({
    super.key,
    required this.uid,
  });

  static Future<void> show(BuildContext context, {required String uid}) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => AddHabitBottomSheet(uid: uid),
    );
  }

  @override
  State<AddHabitBottomSheet> createState() => _AddHabitBottomSheetState();
}

class _AddHabitBottomSheetState extends State<AddHabitBottomSheet> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _costController = TextEditingController();
  final _habitService = HabitService();

  HabitType _selectedType = HabitType.saglikli;
  bool _isLoading = false;

  @override
  void dispose() {
    _titleController.dispose();
    _costController.dispose();
    super.dispose();
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      final double cost = _selectedType == HabitType.zararli
          ? double.tryParse(_costController.text.trim()) ?? 0.0
          : 0.0;

      await _habitService.addHabit(
        uid: widget.uid,
        baslik: _titleController.text.trim(),
        tip: _selectedType,
        gunlukMaliyet: cost,
      );

      if (!mounted) return;
      Navigator.of(context).pop();

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(_selectedType == HabitType.zararli
              ? 'Bırakma hedefiniz başarıyla eklendi! İradenizle yanınızdayız.'
              : 'Yeni alışkanlığınız başarıyla eklendi!'),
          backgroundColor: AppColors.success,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Hata oluştu: $e'),
          backgroundColor: AppColors.danger,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
      ),
      padding: EdgeInsets.only(
        top: 20,
        left: 24,
        right: 24,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Tutamaç Çubuğu
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.borderDark : AppColors.borderLight,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 18),

              // Başlık
              Text(
                'Yeni Alışkanlık Ekle',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w700),
              ),
              const SizedBox(height: 18),

              // Alışkanlık Türü Seçimi (Segmented Kontrol)
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: isDark ? AppColors.surfaceVariantDark : AppColors.surfaceVariantLight,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _buildTypeButton(
                        title: 'Sağlıklı Alışkanlık',
                        icon: Icons.favorite_border_rounded,
                        type: HabitType.saglikli,
                        isDark: isDark,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: _buildTypeButton(
                        title: 'Zararlı Bırakma',
                        icon: Icons.smoke_free_rounded,
                        type: HabitType.zararli,
                        isDark: isDark,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),

              // Alışkanlık Başlığı
              CustomTextField(
                controller: _titleController,
                label: 'Alışkanlık Adı',
                hintText: _selectedType == HabitType.saglikli
                    ? 'Örn: Kitap Oku, 2 Litre Su İç'
                    : 'Örn: Sigarayı Bırak, Şekerli İçecekler',
                prefixIcon: _selectedType == HabitType.saglikli
                    ? Icons.spa_rounded
                    : Icons.block_rounded,
                validator: (val) {
                  if (val == null || val.trim().isEmpty) {
                    return 'Lütfen bir alışkanlık adı girin.';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),

              // Zararlı İse Günlük Maliyet Form Alanı (Zorunlu)
              if (_selectedType == HabitType.zararli) ...[
                CustomTextField(
                  controller: _costController,
                  label: 'Günde Kaç TL Harcıyorsun?',
                  hintText: 'Örn: 80',
                  prefixIcon: Icons.currency_lira_rounded,
                  keyboardType: const TextInputType.numberWithOptions(decimal: true),
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) {
                      return 'Tasarrufunuzu hesaplayabilmemiz için günlük harcamanızı giriniz.';
                    }
                    final num = double.tryParse(val.trim());
                    if (num == null || num <= 0) {
                      return 'Lütfen 0\'dan büyük geçerli bir tutar girin.';
                    }
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Text(
                  '💡 Bu tutar, zinciri kırmadığınız her gün için toplam tasarrufunuza eklenecektir.',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight,
                  ),
                ),
                const SizedBox(height: 16),
              ],

              const SizedBox(height: 8),

              // Kaydet Butonu
              CustomButton(
                text: 'Hedefi Başlat',
                isLoading: _isLoading,
                onPressed: _handleSave,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTypeButton({
    required String title,
    required IconData icon,
    required HabitType type,
    required bool isDark,
  }) {
    final isSelected = _selectedType == type;

    return GestureDetector(
      onTap: () => setState(() => _selectedType = type),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected
              ? (isDark ? AppColors.surfaceDark : Colors.white)
              : Colors.transparent,
          borderRadius: BorderRadius.circular(10),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.05),
                    blurRadius: 4,
                    offset: const Offset(0, 2),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected
                  ? (type == HabitType.zararli ? AppColors.terracottaSoft : AppColors.deepSage)
                  : (isDark ? AppColors.textMutedDark : AppColors.textMutedLight),
            ),
            const SizedBox(width: 6),
            Flexible(
              child: Text(
                title,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                  color: isSelected
                      ? (isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight)
                      : (isDark ? AppColors.textMutedDark : AppColors.textSecondaryLight),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
