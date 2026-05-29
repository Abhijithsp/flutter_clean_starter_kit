import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/cart_item.dart';
import '../cubits/cart_cubit.dart';
import '../cubits/cart_state.dart';

// ═══════════════════════════════════════════════════════════════════════════
// RESPONSIVE FLIPKART-STYLE CART SCREEN
// ═══════════════════════════════════════════════════════════════════════════

class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

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
          'My Cart',
          style: GoogleFonts.outfit(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          BlocBuilder<CartCubit, CartState>(
            builder: (context, state) {
              if (state.isEmpty) return const SizedBox.shrink();
              return TextButton(
                onPressed: () => _showClearDialog(context),
                child: Text(
                  'CLEAR ALL',
                  style: GoogleFonts.outfit(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              );
            },
          ),
          const SizedBox(width: 8),
        ],
      ),
      body: BlocBuilder<CartCubit, CartState>(
        builder: (context, state) {
          if (state.isEmpty) {
            return _buildEmptyCart(context);
          }
          return isTablet ? _buildTabletLayout(context, state) : _buildMobileLayout(context, state);
        },
      ),
      bottomNavigationBar: isTablet ? null : _buildMobileBottomBar(context),
    );
  }

  // Tablet/Desktop Split View
  Widget _buildTabletLayout(BuildContext context, CartState state) {
    return Padding(
      padding: const EdgeInsets.all(24),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column: Scrollable List of Cart Items
          Expanded(
            flex: 6,
            child: ListView.builder(
              physics: const BouncingScrollPhysics(),
              itemCount: state.items.length + (state.deliveryFee > 0 ? 1 : 0),
              itemBuilder: (context, i) {
                if (i < state.items.length) {
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 12),
                    child: _CartItemCard(item: state.items[i]),
                  );
                } else {
                  return _buildFreeShippingBanner(state);
                }
              },
            ),
          ),
          const SizedBox(width: 24),
          // Right Column: Price Details & Place Order Action
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _PriceSummaryCard(state: state),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFFB641B), // Flipkart Orange
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 20),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                      elevation: 0,
                      minimumSize: const Size.fromHeight(60),
                    ),
                    onPressed: () => context.push('/shop/payment'),
                    child: Text(
                      'PLACE ORDER',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        letterSpacing: 0.5,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mobile layout
  Widget _buildMobileLayout(BuildContext context, CartState state) {
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        // Free shipping banner
        if (state.deliveryFee > 0)
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: _buildFreeShippingBanner(state),
            ),
          ),
        // Cart items
        SliverPadding(
          padding: const EdgeInsets.all(8.0),
          sliver: SliverList(
            delegate: SliverChildBuilderDelegate(
              (context, i) => Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: _CartItemCard(item: state.items[i]),
              ),
              childCount: state.items.length,
            ),
          ),
        ),
        // Price Summary
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 32),
            child: _PriceSummaryCard(state: state),
          ),
        ),
      ],
    );
  }

  // Mobile Bottom Bar Pinned Action
  Widget _buildMobileBottomBar(BuildContext context) {
    return BlocBuilder<CartCubit, CartState>(
      builder: (context, state) {
        if (state.isEmpty) return const SizedBox.shrink();
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
                      '\$${state.total.toStringAsFixed(2)}',
                      style: GoogleFonts.outfit(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    Text(
                      'View Price Details',
                      style: GoogleFonts.outfit(
                        fontSize: 11,
                        color: const Color(0xFF2874F0),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFFB641B), // Flipkart Orange
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
                    elevation: 0,
                  ),
                  onPressed: () => context.push('/shop/payment'),
                  child: Text(
                    'PLACE ORDER',
                    style: GoogleFonts.outfit(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildFreeShippingBanner(CartState state) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF388E3C).withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFF388E3C).withValues(alpha: 0.2)),
      ),
      child: Row(
        children: [
          const Icon(Icons.flash_on, color: Color(0xFF388E3C), size: 18),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Add \$${(99 - state.subtotal).toStringAsFixed(2)} more to get FREE delivery!',
              style: GoogleFonts.outfit(
                color: const Color(0xFF388E3C),
                fontWeight: FontWeight.w600,
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyCart(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.shopping_cart_outlined,
            size: 80,
            color: Colors.grey,
          ),
          const SizedBox(height: 16),
          Text(
            'Your Cart is empty!',
            style: GoogleFonts.outfit(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF1A1A1A),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Add items to it now.',
            style: GoogleFonts.outfit(
              color: Colors.grey.shade500,
              fontSize: 14,
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2874F0), // Flipkart Blue
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 14),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              elevation: 0,
            ),
            onPressed: () => context.go('/shop'),
            child: Text(
              'Shop Now',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14),
            ),
          ),
        ],
      ),
    );
  }

  void _showClearDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
        title: Text(
          'Clear Cart?',
          style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
        ),
        content: Text(
          'Are you sure you want to remove all items from your cart?',
          style: GoogleFonts.outfit(color: Colors.grey.shade700),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(
              'CANCEL',
              style: GoogleFonts.outfit(color: Colors.grey.shade600, fontWeight: FontWeight.bold),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
              elevation: 0,
            ),
            onPressed: () {
              context.read<CartCubit>().clearCart();
              Navigator.pop(ctx);
            },
            child: Text(
              'CLEAR',
              style: GoogleFonts.outfit(fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Cart Item Card ──────────────────────────────────────────────────────────
class _CartItemCard extends StatelessWidget {
  final CartItem item;
  const _CartItemCard({required this.item});

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<CartCubit>();

    return Dismissible(
      key: ValueKey(item.uniqueKey),
      direction: DismissDirection.endToStart,
      onDismissed: (_) => cubit.removeItem(item.uniqueKey),
      background: Container(
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 24),
        decoration: BoxDecoration(
          color: Colors.red.shade700,
          borderRadius: BorderRadius.circular(4),
        ),
        child: const Icon(Icons.delete_outline_rounded, color: Colors.white, size: 28),
      ),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: Colors.grey.shade200),
        ),
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Product Image (tappable)
            GestureDetector(
              onTap: () => context.push('/shop/products', extra: item.product),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: CachedNetworkImage(
                  imageUrl: item.product.imageUrl,
                  width: 80,
                  height: 90,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Container(
                    width: 80,
                    height: 90,
                    color: Colors.grey.shade100,
                    child: const Icon(Icons.image_outlined, color: Colors.grey),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Info Column
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title (tappable)
                  GestureDetector(
                    onTap: () => context.push('/shop/products', extra: item.product),
                    child: Text(
                      item.product.name,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                        color: const Color(0xFF1A1A1A),
                        height: 1.3,
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      Text(
                        item.product.category,
                        style: GoogleFonts.outfit(
                          color: Colors.grey.shade500,
                          fontSize: 11,
                        ),
                      ),
                      if (item.selectedColor != null || item.selectedSize != null || item.selectedStorage != null) ...[
                        Text(' | ', style: TextStyle(color: Colors.grey.shade300, fontSize: 11)),
                        Expanded(
                          child: Text(
                            '${item.selectedColor ?? ""}${item.selectedSize != null ? " / ${item.selectedSize}" : ""}${item.selectedStorage != null ? " / ${item.selectedStorage}" : ""}',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.outfit(
                              color: const Color(0xFF2874F0),
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 8),
                  // Price and Stepper Row
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '\$${item.totalPrice.toStringAsFixed(2)}',
                            style: GoogleFonts.outfit(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                              color: const Color(0xFF1A1A1A),
                            ),
                          ),
                          if (item.product.discount > 0)
                            Text(
                              '${item.product.discount}% Off Applied',
                              style: GoogleFonts.outfit(
                                color: const Color(0xFF388E3C),
                                fontSize: 10,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
                      ),
                      // Stepper
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(4),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            InkWell(
                              onTap: () => cubit.updateQuantity(item.uniqueKey, item.quantity - 1),
                              child: const Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Icon(Icons.remove, size: 14, color: Colors.black87),
                              ),
                            ),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10),
                              child: Text(
                                '${item.quantity}',
                                style: GoogleFonts.outfit(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black87,
                                ),
                              ),
                            ),
                            InkWell(
                              onTap: () => cubit.updateQuantity(item.uniqueKey, item.quantity + 1),
                              child: const Padding(
                                padding: EdgeInsets.all(6.0),
                                child: Icon(Icons.add, size: 14, color: Colors.black87),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Price Details Summary Card ──────────────────────────────────────────────
class _PriceSummaryCard extends StatelessWidget {
  final CartState state;
  const _PriceSummaryCard({required this.state});

  @override
  Widget build(BuildContext context) {
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
            padding: const EdgeInsets.all(16.0),
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
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                _buildRow('Price (${state.totalItems} items)', '\$${state.subtotal.toStringAsFixed(2)}'),
                const SizedBox(height: 12),
                _buildRow(
                  'Discount',
                  '−\$${state.discountAmount.toStringAsFixed(2)}',
                  valueColor: const Color(0xFF388E3C),
                ),
                const SizedBox(height: 12),
                _buildRow(
                  'Delivery Charges',
                  state.deliveryFee == 0 ? 'FREE' : '\$${state.deliveryFee.toStringAsFixed(2)}',
                  valueColor: state.deliveryFee == 0 ? const Color(0xFF388E3C) : null,
                ),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total Amount',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                    Text(
                      '\$${state.total.toStringAsFixed(2)}',
                      style: GoogleFonts.outfit(
                        fontWeight: FontWeight.bold,
                        fontSize: 18,
                        color: const Color(0xFF1A1A1A),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),
          if (state.discountAmount > 0)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(14),
              color: const Color(0xFF388E3C).withValues(alpha: 0.08),
              child: Text(
                'You will save \$${state.discountAmount.toStringAsFixed(2)} on this order 🎉',
                style: GoogleFonts.outfit(
                  color: const Color(0xFF388E3C),
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
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
          style: GoogleFonts.outfit(color: Colors.black87, fontSize: 13),
        ),
        Text(
          value,
          style: GoogleFonts.outfit(
            fontWeight: FontWeight.w500,
            fontSize: 13,
            color: valueColor ?? const Color(0xFF1A1A1A),
          ),
        ),
      ],
    );
  }
}
