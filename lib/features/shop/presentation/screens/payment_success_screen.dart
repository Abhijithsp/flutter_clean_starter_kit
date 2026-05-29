import 'dart:math';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../core/services/notification_service.dart';
import '../../domain/entities/shop_order.dart';

// ═══════════════════════════════════════════════════════════════════════════
// RESPONSIVE FLIPKART-STYLE PAYMENT SUCCESS SCREEN (Clean & Light UI)
// ═══════════════════════════════════════════════════════════════════════════

class PaymentSuccessScreen extends StatefulWidget {
  final ShopOrder? order;
  const PaymentSuccessScreen({super.key, this.order});

  @override
  State<PaymentSuccessScreen> createState() => _PaymentSuccessScreenState();
}

class _PaymentSuccessScreenState extends State<PaymentSuccessScreen>
    with TickerProviderStateMixin {
  late AnimationController _checkCtrl;
  late AnimationController _contentCtrl;
  late AnimationController _confettiCtrl;
  late AnimationController _pulseCtrl;

  late Animation<double> _checkScale;
  late Animation<double> _checkOpacity;
  late Animation<double> _contentSlide;
  late Animation<double> _contentOpacity;
  late Animation<double> _confettiProgress;

  late String _orderId;
  late String _deliveryDate;

  static String _getDeliveryDate() {
    final d = DateTime.now().add(const Duration(days: 5));
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${d.day} ${months[d.month - 1]} ${d.year}';
  }

  @override
  void initState() {
    super.initState();
    _orderId = widget.order?.id ?? 'OD${10000 + Random().nextInt(90000)}';
    _deliveryDate = _getDeliveryDate();

    _checkCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 700));
    _contentCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 600));
    _confettiCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 2500))
      ..repeat();
    _pulseCtrl = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 1200))
      ..repeat(reverse: true);

    _checkScale = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _checkCtrl, curve: Curves.elasticOut));
    _checkOpacity = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
            parent: _checkCtrl, curve: const Interval(0, 0.3)));
    _contentSlide = Tween<double>(begin: 50, end: 0).animate(
        CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOutCubic));
    _contentOpacity = Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(parent: _contentCtrl, curve: Curves.easeOut));
    _confettiProgress = Tween<double>(begin: 0, end: 1).animate(_confettiCtrl);

    Future.delayed(const Duration(milliseconds: 200),
        () => _checkCtrl.forward());
    Future.delayed(const Duration(milliseconds: 800),
        () => _contentCtrl.forward());

    // Show immediate order confirmation alert (the subsequent shipping, out-of-delivery 
    // notifications are triggered asynchronously by the OrderHistoryCubit)
    NotificationService.showNotification(
      title: 'Order Confirmed! 🛍️',
      body: 'Your payment was successful and Order $_orderId is being processed.',
    );
  }

  @override
  void dispose() {
    _checkCtrl.dispose();
    _contentCtrl.dispose();
    _confettiCtrl.dispose();
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6), // Clean Flipkart light grey bg
      body: Stack(
        children: [
          // Soft colorful decorative shapes
          Positioned(
            top: -60,
            left: -60,
            child: Container(
              width: 220,
              height: 220,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFF2874F0).withValues(alpha: 0.05),
              ),
            ),
          ),
          Positioned(
            bottom: 80,
            right: -40,
            child: Container(
              width: 180,
              height: 180,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: const Color(0xFFFB641B).withValues(alpha: 0.04),
              ),
            ),
          ),
          // Colorful Confetti
          AnimatedBuilder(
            animation: _confettiProgress,
            builder: (context, child) => CustomPaint(
              painter: _RainbowConfettiPainter(_confettiProgress.value),
              size: Size.infinite,
            ),
          ),
          // Content
          SafeArea(
            child: Center(
              child: Container(
                constraints: const BoxConstraints(maxWidth: 550),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const SizedBox(height: 20),
                      // Check circle with soft green pulsing glow
                      ScaleTransition(
                        scale: _checkScale,
                        child: FadeTransition(
                          opacity: _checkOpacity,
                          child: AnimatedBuilder(
                            animation: _pulseCtrl,
                            builder: (context, child) => Transform.scale(
                              scale: 1.0 + _pulseCtrl.value * 0.05,
                              child: child,
                            ),
                            child: Stack(
                              alignment: Alignment.center,
                              children: [
                                // Outer green ring
                                Container(
                                  width: 130,
                                  height: 130,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: const Color(0xFF388E3C).withValues(alpha: 0.1),
                                  ),
                                ),
                                // Inner solid green circle
                                Container(
                                  width: 90,
                                  height: 90,
                                  decoration: const BoxDecoration(
                                    shape: BoxShape.circle,
                                    color: Color(0xFF388E3C), // Flipkart Green
                                  ),
                                  child: const Icon(
                                    Icons.check_rounded,
                                    color: Colors.white,
                                    size: 48,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 28),
                      // Animated card & text details
                      AnimatedBuilder(
                        animation: _contentCtrl,
                        builder: (context, child) => Transform.translate(
                          offset: Offset(0, _contentSlide.value),
                          child: Opacity(
                            opacity: _contentOpacity.value.clamp(0.0, 1.0),
                            child: child,
                          ),
                        ),
                        child: Column(
                          children: [
                            Text(
                              'Payment Successful!',
                              style: GoogleFonts.outfit(
                                color: const Color(0xFF388E3C),
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 6),
                            Text(
                              'Your order has been confirmed 🎉',
                              style: GoogleFonts.outfit(
                                color: Colors.grey.shade600,
                                fontSize: 14,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Order details card (Clean white style)
                            Container(
                              padding: const EdgeInsets.all(20),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(color: Colors.grey.shade200),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withValues(alpha: 0.04),
                                    blurRadius: 10,
                                    offset: const Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  _DetailRow(
                                    emoji: '🧾',
                                    label: 'Order ID',
                                    value: _orderId,
                                    iconBgColor: const Color(0xFF2874F0).withValues(alpha: 0.1),
                                    textColor: const Color(0xFF2874F0),
                                  ),
                                  const SizedBox(height: 16),
                                  _DetailRow(
                                    emoji: '📦',
                                    label: 'Estimated Delivery',
                                    value: _deliveryDate,
                                    iconBgColor: const Color(0xFFFB641B).withValues(alpha: 0.1),
                                    textColor: const Color(0xFFFB641B),
                                  ),
                                  const SizedBox(height: 16),
                                   _DetailRow(
                                     emoji: '📍',
                                     label: 'Deliver to',
                                     value: widget.order?.deliveryAddress ?? 'Default Shipping Address',
                                     iconBgColor: const Color(0xFF388E3C).withValues(alpha: 0.1),
                                     textColor: const Color(0xFF388E3C),
                                   ),
                                  const Divider(height: 32),
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF388E3C).withValues(alpha: 0.08),
                                      borderRadius: BorderRadius.circular(4),
                                      border: Border.all(color: const Color(0xFF388E3C).withValues(alpha: 0.15)),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        const Icon(Icons.check_circle_rounded, color: Color(0xFF388E3C), size: 16),
                                        const SizedBox(width: 8),
                                        Text(
                                          'Payment Confirmed ✓',
                                          style: GoogleFonts.outfit(
                                            color: const Color(0xFF388E3C),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 12,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(height: 24),
                            // Pinned action buttons
                            ElevatedButton.icon(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFFB641B), // Flipkart Orange
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                elevation: 0,
                                minimumSize: const Size.fromHeight(50),
                              ),
                               onPressed: () {
                                 if (widget.order != null) {
                                   context.push('/shop/order-tracking', extra: widget.order);
                                 } else {
                                   context.push('/shop/order-history');
                                 }
                               },
                              icon: const Icon(Icons.local_shipping, size: 18),
                              label: Text(
                                'Track My Order',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            OutlinedButton.icon(
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF2874F0), // Flipkart Blue
                                side: const BorderSide(color: Color(0xFF2874F0), width: 1.5),
                                padding: const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                                minimumSize: const Size.fromHeight(50),
                              ),
                              onPressed: () => context.go('/shop'),
                              icon: const Icon(Icons.shopping_bag_outlined, size: 18),
                              label: Text(
                                'Continue Shopping',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 20),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Detail Row Widget ───────────────────────────────────────────────────────
class _DetailRow extends StatelessWidget {
  final String emoji;
  final String label;
  final String value;
  final Color iconBgColor;
  final Color textColor;

  const _DetailRow({
    required this.emoji,
    required this.label,
    required this.value,
    required this.iconBgColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: iconBgColor,
            borderRadius: BorderRadius.circular(4),
          ),
          child: Center(
            child: Text(emoji, style: const TextStyle(fontSize: 16)),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.outfit(color: Colors.grey.shade500, fontSize: 11),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: GoogleFonts.outfit(
                  color: const Color(0xFF1A1A1A),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ─── Rainbow Confetti Painter ────────────────────────────────────────────────
class _RainbowConfettiPainter extends CustomPainter {
  final double progress;
  final Random _rand = Random(42);

  static const _colors = [
    Color(0xFF2874F0), // Flipkart Blue
    Color(0xFF388E3C), // Flipkart Green
    Color(0xFFFFBE00), // Flipkart Yellow
    Color(0xFFFB641B), // Flipkart Orange
    Color(0xFFFA709A), // Pink
    Color(0xFF4FACFE), // Cyan
  ];
  static const _shapes = ['circle', 'square', 'triangle'];

  _RainbowConfettiPainter(this.progress);

  @override
  void paint(Canvas canvas, Size size) {
    for (int i = 0; i < 50; i++) {
      final x = _rand.nextDouble() * size.width;
      final fallOffset = ((progress + i * 0.02) % 1.0);
      final y = -20 + (size.height + 40) * fallOffset;
      final color = _colors[i % _colors.length];
      final paint = Paint()
        ..color = color.withValues(alpha: 0.65)
        ..style = PaintingStyle.fill;

      final angle = progress * pi * 4 + i * 0.7;
      final sz = 4.0 + _rand.nextDouble() * 6;

      canvas.save();
      canvas.translate(x, y);
      canvas.rotate(angle);

      final shape = _shapes[i % _shapes.length];
      if (shape == 'circle') {
        canvas.drawCircle(Offset.zero, sz / 2, paint);
      } else if (shape == 'square') {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
              Rect.fromCenter(center: Offset.zero, width: sz, height: sz),
              const Radius.circular(1.5)),
          paint,
        );
      } else {
        final path = Path()
          ..moveTo(0, -sz / 2)
          ..lineTo(sz / 2, sz / 2)
          ..lineTo(-sz / 2, sz / 2)
          ..close();
        canvas.drawPath(path, paint);
      }
      canvas.restore();
    }
  }

  @override
  bool shouldRepaint(_RainbowConfettiPainter old) => old.progress != progress;
}
