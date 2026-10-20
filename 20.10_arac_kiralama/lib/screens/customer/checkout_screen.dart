import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/theme/app_colors.dart';
import '../../models/reservation.dart';
import '../../providers/auth_provider.dart';
import '../../providers/vehicle_provider.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_text_field.dart';
import '../../widgets/sem_logo.dart';
import 'customer_main_screen.dart';

class CheckoutScreen extends StatefulWidget {
  final Reservation reservation;

  const CheckoutScreen({
    super.key,
    required this.reservation,
  });

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();

  final _cardHolderController = TextEditingController();
  final _cardNumberController = TextEditingController();
  final _expiryDateController = TextEditingController();
  final _cvvController = TextEditingController();

  bool _isProcessing = false;

  @override
  void initState() {
    super.initState();
    final auth = Provider.of<AuthProvider>(context, listen: false);
    _cardHolderController.text = auth.currentUser?.fullName ?? 'MÜŞTERİ ADI';
  }

  @override
  void dispose() {
    _cardHolderController.dispose();
    _cardNumberController.dispose();
    _expiryDateController.dispose();
    _cvvController.dispose();
    super.dispose();
  }

  // Ödeme ve Rezervasyon Tamamlama
  Future<void> _processPayment() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() => _isProcessing = true);

    final vehicleProvider = Provider.of<VehicleProvider>(context, listen: false);

    // Mock rezervasyonu ekle ve bekle
    await vehicleProvider.addReservation(widget.reservation);

    if (!mounted) return;
    setState(() => _isProcessing = false);

    // Başarılı Diyaloğu
    _showSuccessDialog();
  }

  void _showSuccessDialog() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: AppColors.success.withValues(alpha: 0.15),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.check_circle_rounded,
                color: AppColors.success,
                size: 64,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'Rezervasyon Başarılı!',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: isDark ? AppColors.textLight : AppColors.textDark,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '${widget.reservation.carName} aracınız rezerve edildi.\nTeslimat bilgileri SMS ve e-posta ile iletilmiştir.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13.5,
                color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: isDark ? AppColors.surfaceDarkElevated : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text('Ödenen Toplam:', style: TextStyle(fontWeight: FontWeight.w600)),
                  Text(
                    '${widget.reservation.totalAmount.toStringAsFixed(0)} ₺',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                      color: AppColors.primaryBlue,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            CustomElevatedButton(
              text: 'Ana Sayfaya Dön',
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                  MaterialPageRoute(builder: (_) => const CustomerMainScreen()),
                  (route) => false,
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const SemLogo(fontSize: 20),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Güvenli Ödeme',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: isDark ? AppColors.textLight : AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'Kart bilgilerinizi girerek rezervasyonu tamamlayın.',
                  style: TextStyle(
                    fontSize: 13.5,
                    color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                  ),
                ),
                const SizedBox(height: 20),

                // Rezervasyon Özet Kartı
                _buildSummaryCard(isDark),
                const SizedBox(height: 24),

                // Sanal Kredi Kartı Görseli
                _buildVirtualCreditCard(isDark),
                const SizedBox(height: 24),

                // Kart Üzerindeki İsim
                CustomTextField(
                  controller: _cardHolderController,
                  labelText: 'Kart Sahibinin Adı Soyadı',
                  prefixIcon: Icons.person_outline_rounded,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Kart sahibi adı zorunludur';
                    return null;
                  },
                ),
                const SizedBox(height: 16),

                // Kart Numarası (16 Hane)
                CustomTextField(
                  controller: _cardNumberController,
                  labelText: 'Kart Numarası',
                  hintText: '4543 2198 7654 3210',
                  prefixIcon: Icons.credit_card_rounded,
                  keyboardType: TextInputType.number,
                  textInputAction: TextInputAction.next,
                  validator: (val) {
                    if (val == null || val.trim().isEmpty) return 'Kart numarası zorunludur';
                    final clean = val.replaceAll(RegExp(r'\s+'), '');
                    if (!RegExp(r'^[0-9]{16}$').hasMatch(clean)) {
                      return 'Geçerli 16 haneli kart numarası giriniz';
                    }
                    return null;
                  },
                  onChanged: (val) => setState(() {}),
                ),
                const SizedBox(height: 16),

                // SKT ve CVV
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        controller: _expiryDateController,
                        labelText: 'Son Kullanma (AA/YY)',
                        hintText: '12/28',
                        prefixIcon: Icons.calendar_today_outlined,
                        keyboardType: TextInputType.datetime,
                        textInputAction: TextInputAction.next,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'SKT zorunludur';
                          if (!RegExp(r'^(0[1-9]|1[0-2])\/?([0-9]{2})$').hasMatch(val.trim())) {
                            return 'Format: AA/YY';
                          }
                          return null;
                        },
                        onChanged: (val) => setState(() {}),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: CustomTextField(
                        controller: _cvvController,
                        labelText: 'CVV / CVC',
                        hintText: '321',
                        prefixIcon: Icons.lock_outline_rounded,
                        keyboardType: TextInputType.number,
                        obscureText: true,
                        textInputAction: TextInputAction.done,
                        validator: (val) {
                          if (val == null || val.trim().isEmpty) return 'CVV zorunludur';
                          if (!RegExp(r'^[0-9]{3}$').hasMatch(val.trim())) {
                            return '3 haneli olmalıdır';
                          }
                          return null;
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // Ödeme Yap Butonu
                CustomElevatedButton(
                  text: '${widget.reservation.totalAmount.toStringAsFixed(0)} ₺ Ödemeyi Onayla',
                  isLoading: _isProcessing,
                  onPressed: _processPayment,
                  icon: Icons.lock_rounded,
                ),
                const SizedBox(height: 16),

                // Güvenlik Rozeti
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.security_rounded, size: 16, color: AppColors.success),
                      const SizedBox(width: 6),
                      Text(
                        '256-Bit SSL Mock Güvenli Ödeme Protokolü',
                        style: TextStyle(
                          fontSize: 12,
                          color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSummaryCard(bool isDark) {
    final res = widget.reservation;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? AppColors.surfaceDarkElevated : AppColors.backgroundLight,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isDark ? AppColors.borderDark : AppColors.borderLight,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                  res.carImageUrl,
                  width: 70,
                  height: 50,
                  fit: BoxFit.cover,
                  errorBuilder: (c, e, s) => Container(
                    width: 70,
                    height: 50,
                    color: Colors.grey.shade300,
                    child: const Icon(Icons.directions_car),
                  ),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      res.carName,
                      style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                    Text(
                      '${res.totalDays} Günlük Kiralama',
                      style: const TextStyle(fontSize: 13, color: AppColors.primaryBlue),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const Divider(height: 24),
          _buildSummaryRow('Günlük Kira Bedeli:', '${res.dailyPrice.toStringAsFixed(0)} ₺ x ${res.totalDays} gün', isDark),
          if (res.isIntercity) ...[
            const SizedBox(height: 6),
            _buildSummaryRow(
              'Şehir Dışı Ekstra Gün Bedeli (${res.destinationCity}):',
              '+${res.extraDistanceCharge.toStringAsFixed(0)} ₺',
              isDark,
              isHighlight: true,
            ),
          ],
          const Divider(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Toplam Tutar:',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                '${res.totalAmount.toStringAsFixed(0)} ₺',
                style: const TextStyle(
                  fontWeight: FontWeight.w900,
                  fontSize: 20,
                  color: AppColors.primaryBlue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryRow(String label, String value, bool isDark, {bool isHighlight = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            label,
            style: TextStyle(
              fontSize: 13,
              color: isDark ? AppColors.textMutedDark : AppColors.textMutedLight,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Text(
          value,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: isHighlight ? AppColors.warning : (isDark ? AppColors.textLight : AppColors.textDark),
          ),
        ),
      ],
    );
  }

  Widget _buildVirtualCreditCard(bool isDark) {
    final rawNumber = _cardNumberController.text.replaceAll(' ', '');
    final displayNum = rawNumber.isEmpty
        ? '•••• •••• •••• ••••'
        : rawNumber.padRight(16, '•').replaceAllMapped(RegExp(r'.{4}'), (match) => '${match.group(0)} ');

    final expiry = _expiryDateController.text.isEmpty ? 'AA/YY' : _expiryDateController.text;
    final holder = _cardHolderController.text.isEmpty ? 'AD SOYAD' : _cardHolderController.text.toUpperCase();

    return Container(
      width: double.infinity,
      height: 190,
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF0052D4), Color(0xFF4364F7), Color(0xFF6FB1FC)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF0052D4).withValues(alpha: 0.35),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'SEM Auto Pay',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                  letterSpacing: 1,
                ),
              ),
              Icon(
                Icons.contactless_rounded,
                color: Colors.white.withValues(alpha: 0.9),
                size: 28,
              ),
            ],
          ),
          Text(
            displayNum,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              letterSpacing: 2.5,
              fontFamily: 'Courier',
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'KART SAHİBİ',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    holder,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'GEÇERLİLİK',
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.7),
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    expiry,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
