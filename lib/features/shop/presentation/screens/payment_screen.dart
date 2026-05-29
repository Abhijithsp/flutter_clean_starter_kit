import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../cubits/cart_cubit.dart';
import '../cubits/cart_state.dart';
import '../cubits/order_history_cubit.dart';
import '../../domain/entities/shop_order.dart';
import '../../domain/entities/cart_item.dart';

enum PaymentMethod { creditCard, upi, wallet, cod }

// ═══════════════════════════════════════════════════════════════════════════
// RESPONSIVE FLIPKART-STYLE PAYMENT SCREEN
// ═══════════════════════════════════════════════════════════════════════════

class PaymentScreen extends StatefulWidget {
  const PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  PaymentMethod _selected = PaymentMethod.creditCard;
  bool _isProcessing = false;

  final _cardNumber = TextEditingController();
  final _cardName = TextEditingController();
  final _expiry = TextEditingController();
  final _cvv = TextEditingController();
  final _upiId = TextEditingController();

  @override
  void dispose() {
    _cardNumber.dispose();
    _cardName.dispose();
    _expiry.dispose();
    _cvv.dispose();
    _upiId.dispose();
    super.dispose();
  }

  Future<void> _processPayment(BuildContext context) async {
    setState(() => _isProcessing = true);
    final cartCubit = context.read<CartCubit>();
    final orderHistoryCubit = context.read<OrderHistoryCubit>();
    final router = GoRouter.of(context);
    
    final orderId = 'OD${DateTime.now().millisecondsSinceEpoch.toString().substring(5)}';
    final order = ShopOrder(
      id: orderId,
      items: List<CartItem>.from(cartCubit.state.items),
      totalAmount: cartCubit.state.total,
      orderDate: DateTime.now(),
      status: 'processing',
      deliveryAddress: '123 Tech Avenue, Silicon Valley, CA 94025',
      paymentMethod: _selected.toString().split('.').last.toUpperCase(),
    );

    await Future.delayed(const Duration(seconds: 2));
    if (!mounted) return;
    
    orderHistoryCubit.addOrder(order);
    cartCubit.clearCart();
    setState(() => _isProcessing = false);
    router.go('/shop/success', extra: order);
  }

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;
    final isTablet = w >= 750;

    return Scaffold(
      backgroundColor: const Color(0xFFF1F3F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFF2874F0),
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          'Secure Payment',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, cartState) {
          if (isTablet) {
            return _buildTabletLayout(context, cartState);
          }
          return _buildMobileLayout(context, cartState);
        },
      ),
      bottomNavigationBar: isTablet ? null : _buildMobileBottomBar(context),
    );
  }

  // Tablet/Desktop Split View
  Widget _buildTabletLayout(BuildContext context, CartState cartState) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column: Payment Options & Active Form
          Expanded(
            flex: 6,
            child: SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Select Payment Method',
                    style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A1A)),
                  ),
                  const SizedBox(height: 12),
                  ..._buildPaymentOptions(),
                  const SizedBox(height: 16),
                  // Render active form
                  _buildSelectedMethodForm(),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
          const SizedBox(width: 24),
          // Right Column: Price Details & Pay button
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildPriceSummary(cartState),
                  const SizedBox(height: 16),
                  _buildPayButton(context, cartState, isFullWidth: true),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mobile layout
  Widget _buildMobileLayout(BuildContext context, CartState cartState) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Payment Methods',
            style: GoogleFonts.outfit(fontSize: 16, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A1A)),
          ),
          const SizedBox(height: 12),
          ..._buildPaymentOptions(),
          const SizedBox(height: 12),
          _buildSelectedMethodForm(),
          const SizedBox(height: 16),
          _buildPriceSummary(cartState),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Mobile Bottom Bar Pinned Action
  Widget _buildMobileBottomBar(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, cartState) {
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.05),
                blurRadius: 10,
                offset: const Offset(0, -4),
              ),
            ],
          ),
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SafeArea(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '\$${cartState.total.toStringAsFixed(2)}',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    Text(
                      'Grand Total',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
                _buildPayButton(context, cartState, isFullWidth: false),
              ],
            ),
          ),
        );
      },
    );
  }

  // Pay Button Widget
  Widget _buildPayButton(BuildContext context, CartState cartState, {required bool isFullWidth}) {
    final button = ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFFB641B), // Flipkart Orange
        foregroundColor: Colors.white,
        padding: EdgeInsets.symmetric(horizontal: isFullWidth ? 20 : 32, vertical: 16),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        elevation: 0,
        minimumSize: isFullWidth ? const Size.fromHeight(56) : null,
      ),
      onPressed: _isProcessing ? null : () => _processPayment(context),
      child: _isProcessing
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 2,
              ),
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
              children: [
                const Icon(Icons.security, size: 16),
                const SizedBox(width: 8),
                Text(
                  _selected == PaymentMethod.cod ? 'CONFIRM ORDER' : 'PAY SECURELY',
                  style: GoogleFonts.outfit(
                    fontWeight: FontWeight.bold,
                    fontSize: 14,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
    );

    return button;
  }

  // Build Payment Options List
  List<Widget> _buildPaymentOptions() {
    final methods = [
      (PaymentMethod.creditCard, Icons.credit_card, 'Credit / Debit Card', 'Visa, Mastercard, Amex'),
      (PaymentMethod.upi, Icons.account_balance, 'UPI Payment', 'Google Pay, PhonePe, BHIM'),
      (PaymentMethod.wallet, Icons.account_balance_wallet, 'Digital Wallet', 'PayPal, Apple Pay'),
      (PaymentMethod.cod, Icons.local_shipping, 'Cash on Delivery', 'Pay when you receive'),
    ];

    return methods.map((m) {
      final (method, icon, label, sub) = m;
      final isSelected = _selected == method;
      return GestureDetector(
        onTap: () => setState(() => _selected = method),
        child: Container(
          margin: const EdgeInsets.only(bottom: 8),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(
              color: isSelected ? const Color(0xFF2874F0) : Colors.grey.shade200,
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                width: 18,
                height: 18,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: isSelected ? const Color(0xFF2874F0) : Colors.grey.shade400,
                    width: 2,
                  ),
                ),
                padding: const EdgeInsets.all(3),
                child: isSelected
                    ? Container(
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF2874F0),
                        ),
                      )
                    : null,
              ),
              Icon(icon, color: isSelected ? const Color(0xFF2874F0) : Colors.grey.shade600, size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    Text(
                      sub,
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    }).toList();
  }

  // Render Selected Method Fields
  Widget _buildSelectedMethodForm() {
    switch (_selected) {
      case PaymentMethod.creditCard:
        return Column(
          children: [
            _buildCardPreview(),
            const SizedBox(height: 16),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Card details',
                    style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF1A1A1A)),
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    'Card Number',
                    _cardNumber,
                    TextInputType.number,
                    formatters: [FilteringTextInputFormatter.digitsOnly, _CardNumberFormatter()],
                    hint: '1234 5678 9012 3456',
                    icon: Icons.credit_card,
                  ),
                  const SizedBox(height: 12),
                  _buildTextField(
                    'Cardholder Name',
                    _cardName,
                    TextInputType.name,
                    hint: 'John Doe',
                    icon: Icons.person_outline,
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: _buildTextField(
                          'Expiry',
                          _expiry,
                          TextInputType.datetime,
                          formatters: [FilteringTextInputFormatter.digitsOnly, _ExpiryFormatter()],
                          hint: 'MM/YY',
                          icon: Icons.calendar_today,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _buildTextField(
                          'CVV',
                          _cvv,
                          TextInputType.number,
                          formatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(3)],
                          hint: '•••',
                          obscure: true,
                          icon: Icons.lock_outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        );
      case PaymentMethod.upi:
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade200),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Enter UPI ID',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF1A1A1A)),
              ),
              const SizedBox(height: 12),
              _buildTextField(
                'UPI ID',
                _upiId,
                TextInputType.emailAddress,
                hint: 'john@ybl',
                icon: Icons.account_balance,
              ),
            ],
          ),
        );
      case PaymentMethod.wallet:
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade200),
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Select Digital Wallet',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF1A1A1A)),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: ['PayPal', 'Apple Pay', 'Google Pay', 'Amazon Pay'].map((w) {
                  return ChoiceChip(
                    label: Text(w, style: GoogleFonts.outfit(fontSize: 12)),
                    selected: false,
                    onSelected: (_) {},
                    backgroundColor: const Color(0xFFF1F3F6),
                    side: BorderSide.none,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                  );
                }).toList(),
              ),
            ],
          ),
        );
      case PaymentMethod.cod:
        return Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: Colors.grey.shade200),
          ),
          padding: const EdgeInsets.all(16),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.info_outline, color: Color(0xFF388E3C), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Cash on Delivery',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF1A1A1A)),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'You can pay with cash or card when your order is delivered to your doorstep. No extra charge.',
                      style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey.shade600, height: 1.4),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
    }
  }

  // Credit Card Preview Card
  Widget _buildCardPreview() {
    return AnimatedBuilder(
      animation: Listenable.merge([_cardNumber, _cardName, _expiry]),
      builder: (_, child) {
        final num = _cardNumber.text.isEmpty ? '•••• •••• •••• ••••' : _cardNumber.text;
        final name = _cardName.text.isEmpty ? 'YOUR NAME' : _cardName.text.toUpperCase();
        final exp = _expiry.text.isEmpty ? 'MM/YY' : _expiry.text;

        return Container(
          height: 180,
          width: double.infinity,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF2874F0), Color(0xFF1B4F93)], // Flipkart themed blue gradient
            ),
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF2874F0).withValues(alpha: 0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(Icons.payment, color: Colors.white, size: 24),
                  Text(
                    'PREMIUM CARD',
                    style: GoogleFonts.outfit(
                      color: Colors.white70,
                      fontWeight: FontWeight.bold,
                      fontSize: 10,
                      letterSpacing: 1.5,
                    ),
                  ),
                ],
              ),
              const Spacer(),
              Text(
                num,
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'CARD HOLDER',
                        style: GoogleFonts.outfit(color: Colors.white54, fontSize: 8, letterSpacing: 1),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        name,
                        style: GoogleFonts.outfit(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'EXPIRES',
                        style: GoogleFonts.outfit(color: Colors.white54, fontSize: 8, letterSpacing: 1),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        exp,
                        style: GoogleFonts.outfit(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  // Helper TextField widget
  Widget _buildTextField(
    String label,
    TextEditingController controller,
    TextInputType type, {
    List<TextInputFormatter>? formatters,
    String? hint,
    bool obscure = false,
    IconData? icon,
  }) {
    return TextField(
      controller: controller,
      keyboardType: type,
      obscureText: obscure,
      inputFormatters: formatters,
      onChanged: (_) => setState(() {}),
      style: GoogleFonts.outfit(fontSize: 14),
      decoration: InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: icon != null ? Icon(icon, color: Colors.grey.shade500, size: 18) : null,
        filled: true,
        fillColor: const Color(0xFFF1F3F6),
        labelStyle: GoogleFonts.outfit(color: Colors.grey.shade600, fontSize: 13),
        hintStyle: GoogleFonts.outfit(color: Colors.grey.shade400, fontSize: 13),
        isDense: true,
        contentPadding: const EdgeInsets.all(12),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: BorderSide(color: Colors.grey.shade300),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(4),
          borderSide: const BorderSide(color: Color(0xFF2874F0), width: 1.5),
        ),
      ),
    );
  }

  // Price details section
  Widget _buildPriceSummary(CartState state) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Text(
              'PRICE DETAILS',
              style: GoogleFonts.outfit(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.grey.shade600,
                letterSpacing: 0.5,
              ),
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.all(14.0),
            child: Column(
              children: [
                _buildRow('Price (${state.totalItems} items)', '\$${state.subtotal.toStringAsFixed(2)}'),
                const SizedBox(height: 10),
                _buildRow(
                  'Discount',
                  '−\$${state.discountAmount.toStringAsFixed(2)}',
                  valueColor: const Color(0xFF388E3C),
                ),
                const SizedBox(height: 10),
                _buildRow(
                  'Delivery Charges',
                  state.deliveryFee == 0 ? 'FREE' : '\$${state.deliveryFee.toStringAsFixed(2)}',
                  valueColor: state.deliveryFee == 0 ? const Color(0xFF388E3C) : null,
                ),
                const Divider(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    Text(
                      '\$${state.total.toStringAsFixed(2)}',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRow(String label, String value, {Color? valueColor}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.outfit(color: Colors.black87, fontSize: 12),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w500,
            fontSize: 12,
            color: valueColor ?? const Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }
}

// ─── Text input formatters ──────────────────────────────────────────────────
class _CardNumberFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue old, TextEditingValue nw) {
    final digits = nw.text.replaceAll(' ', '');
    if (digits.length > 16) return old;
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i > 0 && i % 4 == 0) buffer.write(' ');
      buffer.write(digits[i]);
    }
    final str = buffer.toString();
    return nw.copyWith(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}

class _ExpiryFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(TextEditingValue old, TextEditingValue nw) {
    final digits = nw.text.replaceAll('/', '');
    if (digits.length > 4) return old;
    final buffer = StringBuffer();
    for (int i = 0; i < digits.length; i++) {
      if (i == 2) buffer.write('/');
      buffer.write(digits[i]);
    }
    final str = buffer.toString();
    return nw.copyWith(
      text: str,
      selection: TextSelection.collapsed(offset: str.length),
    );
  }
}
