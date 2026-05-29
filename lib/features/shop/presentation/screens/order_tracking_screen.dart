import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../domain/entities/shop_order.dart';
import '../cubits/order_history_cubit.dart';
import '../cubits/order_history_state.dart';

// ═══════════════════════════════════════════════════════════════════════════
// RESPONSIVE FLIPKART-STYLE ORDER TRACKING SCREEN
// ═══════════════════════════════════════════════════════════════════════════

class OrderTrackingScreen extends StatelessWidget {
  final ShopOrder initialOrder;
  const OrderTrackingScreen({super.key, required this.initialOrder});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<OrderHistoryCubit, OrderHistoryState>(
      builder: (context, state) {
        // Retrieve the latest status of this order from the state
        final order = state.orders.firstWhere(
          (o) => o.id == initialOrder.id,
          orElse: () => initialOrder,
        );

        final w = MediaQuery.of(context).size.width;
        final isTablet = w >= 750;

        return Scaffold(
          backgroundColor: const Color(0xFFF1F3F6),
          appBar: AppBar(
            backgroundColor: const Color(0xFF2874F0),
            iconTheme: const IconThemeData(color: Colors.white),
            title: Text(
              'Track Shipment',
              style: GoogleFonts.outfit(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: isTablet ? _buildTabletLayout(context, order) : _buildMobileLayout(context, order),
        );
      },
    );
  }

  // Tablet/Desktop Split View
  Widget _buildTabletLayout(BuildContext context, ShopOrder order) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left Column: Progress Stepper
          Expanded(
            flex: 6,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(4),
                border: Border.all(color: Colors.grey.shade200),
              ),
              padding: const EdgeInsets.all(24),
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Shipment Journey',
                      style: GoogleFonts.outfit(fontSize: 18, fontWeight: FontWeight.bold, color: const Color(0xFF1A1A1A)),
                    ),
                    const SizedBox(height: 24),
                    _buildTrackingStepper(order),
                  ],
                ),
              ),
            ),
          ),
          const SizedBox(width: 24),
          // Right Column: Details & Items Preview
          Expanded(
            flex: 4,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  _buildShippingInfoCard(order),
                  const SizedBox(height: 16),
                  _buildOrderItemsCard(order),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // Mobile view
  Widget _buildMobileLayout(BuildContext context, ShopOrder order) {
    return SingleChildScrollView(
      physics: const BouncingScrollPhysics(),
      child: Column(
        children: [
          _buildShippingInfoCard(order),
          const SizedBox(height: 8),
          Container(
            color: Colors.white,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Shipment journey',
                  style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF1A1A1A)),
                ),
                const SizedBox(height: 16),
                _buildTrackingStepper(order),
              ],
            ),
          ),
          const SizedBox(height: 8),
          _buildOrderItemsCard(order),
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  // Shipping Info card
  Widget _buildShippingInfoCard(ShopOrder order) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'ORDER ID: ${order.id}',
                style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.grey.shade600),
              ),
              Text(
                'Placed: ${_formatDate(order.orderDate)}',
                style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey.shade500),
              ),
            ],
          ),
          const Divider(height: 20),
          Row(
            children: [
              const Icon(Icons.location_on_outlined, color: Color(0xFF2874F0), size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Delivery Address',
                      style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 13, color: const Color(0xFF1A1A1A)),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      order.deliveryAddress,
                      style: GoogleFonts.outfit(fontSize: 12, color: Colors.grey.shade600),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // Visual Tracker Timeline
  Widget _buildTrackingStepper(ShopOrder order) {
    final status = order.status;

    // Determine completion index
    // 0: ordered, 1: shipped, 2: outForDelivery, 3: delivered
    int currentStep = 0;
    if (status == 'shipped') {
      currentStep = 1;
    } else if (status == 'outForDelivery') {
      currentStep = 2;
    } else if (status == 'delivered') {
      currentStep = 3;
    }

    return Column(
      children: [
        _buildStep(
          title: 'Order Placed',
          desc: 'Your order was successfully placed and verified.',
          isCompleted: currentStep >= 0,
          isActive: currentStep == 0,
          time: _formatTime(order.orderDate),
        ),
        _buildDivider(currentStep > 0),
        _buildStep(
          title: 'Order Shipped',
          desc: 'Your package has been dispatched from our regional hub.',
          isCompleted: currentStep >= 1,
          isActive: currentStep == 1,
          time: currentStep >= 1 ? _formatTime(order.orderDate.add(const Duration(seconds: 8))) : '',
        ),
        _buildDivider(currentStep > 1),
        _buildStep(
          title: 'Out for Delivery',
          desc: 'A delivery agent is bringing your package today.',
          isCompleted: currentStep >= 2,
          isActive: currentStep == 2,
          time: currentStep >= 2 ? _formatTime(order.orderDate.add(const Duration(seconds: 18))) : '',
        ),
        _buildDivider(currentStep > 2),
        _buildStep(
          title: 'Delivered',
          desc: 'Your package has been successfully delivered.',
          isCompleted: currentStep >= 3,
          isActive: currentStep == 3,
          time: currentStep >= 3 ? _formatTime(order.orderDate.add(const Duration(seconds: 30))) : '',
        ),
      ],
    );
  }

  Widget _buildStep({
    required String title,
    required String desc,
    required bool isCompleted,
    required bool isActive,
    required String time,
  }) {
    Color stepColor = isCompleted ? const Color(0xFF388E3C) : Colors.grey.shade400;
    if (isActive) stepColor = const Color(0xFF2874F0);

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Indicator dot
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isCompleted ? const Color(0xFF388E3C) : Colors.white,
            border: Border.all(
              color: stepColor,
              width: isCompleted ? 0 : 2,
            ),
          ),
          child: Center(
            child: isCompleted
                ? const Icon(Icons.check, color: Colors.white, size: 14)
                : isActive
                    ? Container(
                        width: 8,
                        height: 8,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: Color(0xFF2874F0),
                        ),
                      )
                    : null,
          ),
        ),
        const SizedBox(width: 14),
        // Content
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: GoogleFonts.outfit(
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                  color: isActive ? const Color(0xFF2874F0) : const Color(0xFF1A1A1A),
                ),
              ),
              const SizedBox(height: 2),
              Text(
                desc,
                style: GoogleFonts.outfit(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
        if (time.isNotEmpty) ...[
          const SizedBox(width: 14),
          Text(
            time,
            style: GoogleFonts.outfit(color: Colors.grey.shade500, fontSize: 11),
          ),
        ],
      ],
    );
  }

  Widget _buildDivider(bool isCompleted) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(left: 11, top: 4, bottom: 4),
        width: 2,
        height: 36,
        color: isCompleted ? const Color(0xFF388E3C) : Colors.grey.shade300,
      ),
    );
  }

  Widget _buildOrderItemsCard(ShopOrder order) {
    return Container(
      color: Colors.white,
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Order Items',
            style: GoogleFonts.outfit(fontWeight: FontWeight.bold, fontSize: 14, color: const Color(0xFF1A1A1A)),
          ),
          const Divider(height: 20),
          ...order.items.map((item) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: CachedNetworkImage(
                      imageUrl: item.product.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                      errorWidget: (c, u, e) => Container(color: Colors.grey.shade100, child: const Icon(Icons.image, size: 20)),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.outfit(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: const Color(0xFF1A1A1A),
                          ),
                        ),
                        Text(
                          'Qty: ${item.quantity}'
                          '${item.selectedColor != null ? ' | Color: ${item.selectedColor}' : ''}'
                          '${item.selectedSize != null ? ' | Size: ${item.selectedSize}' : ''}'
                          '${item.selectedStorage != null ? ' | Storage: ${item.selectedStorage}' : ''}',
                          style: GoogleFonts.outfit(
                            color: Colors.grey.shade600,
                            fontSize: 11,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  String _formatTime(DateTime date) {
    final hr = date.hour % 12 == 0 ? 12 : date.hour % 12;
    final min = date.minute.toString().padLeft(2, '0');
    final sec = date.second.toString().padLeft(2, '0');
    final ampm = date.hour >= 12 ? 'PM' : 'AM';
    return '$hr:$min:$sec $ampm';
  }
}
