import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../extensions/context_extensions.dart';

/// Yörünge Platformu - Derin Uzay & Şafak Fırlatışı Yıldız Alanı Arka Planı.
/// 2. Kural: Renkler doğrudan `context.spaceColors` uzantısından alınır.
/// 3. Kural: Build metodu 40 satırı aşmaz.
class StarfieldBackground extends StatelessWidget {
  final Widget? child;
  final int starCount;

  const StarfieldBackground({
    super.key,
    this.child,
    this.starCount = 70,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final isDark = context.isDarkMode;

    return ColoredBox(
      color: colors.background,
      child: CustomPaint(
        painter: _StarfieldPainter(
          starColor: colors.starColor,
          glowColor: colors.glow,
          starCount: starCount,
          isDark: isDark,
        ),
        child: child ?? const SizedBox.expand(),
      ),
    );
  }
}

/// Yıldızları ve kozmik ışıltıyı çizen CustomPainter sınıfı
class _StarfieldPainter extends CustomPainter {
  final Color starColor;
  final Color glowColor;
  final int starCount;
  final bool isDark;

  const _StarfieldPainter({
    required this.starColor,
    required this.glowColor,
    required this.starCount,
    required this.isDark,
  });

  @override
  void paint(Canvas canvas, Size size) {
    _drawNebulaGlow(canvas, size);
    _drawStars(canvas, size);
  }

  void _drawNebulaGlow(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final glowPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0.6, -0.7),
        radius: 1.1,
        colors: [
          glowColor.withValues(alpha: isDark ? 0.22 : 0.08),
          Colors.transparent,
        ],
      ).createShader(rect);

    canvas.drawRect(rect, glowPaint);
  }

  void _drawStars(Canvas canvas, Size size) {
    final random = math.Random(42);
    final starPaint = Paint()..color = starColor;

    for (int i = 0; i < starCount; i++) {
      final dx = random.nextDouble() * size.width;
      final dy = random.nextDouble() * size.height;
      final radius = (random.nextDouble() * 1.6) + 0.5;
      final alpha = (random.nextDouble() * 0.5) + (isDark ? 0.35 : 0.15);

      starPaint.color = starColor.withValues(alpha: alpha);
      canvas.drawCircle(Offset(dx, dy), radius, starPaint);
    }
  }

  @override
  bool shouldRepaint(covariant _StarfieldPainter oldDelegate) {
    return oldDelegate.starColor != starColor ||
        oldDelegate.glowColor != glowColor ||
        oldDelegate.isDark != isDark;
  }
}
