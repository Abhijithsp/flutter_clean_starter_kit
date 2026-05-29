import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/services/notification_service.dart';
import '../../domain/entities/shop_order.dart';
import 'order_history_state.dart';

class OrderHistoryCubit extends Cubit<OrderHistoryState> {
  OrderHistoryCubit() : super(const OrderHistoryState());

  void addOrder(ShopOrder order) {
    emit(state.copyWith(orders: [order, ...state.orders]));
    _startOrderStatusSimulations(order.id);
  }

  void updateOrderStatus(String orderId, String newStatus) {
    final updated = state.orders.map((o) {
      return o.id == orderId ? o.copyWith(status: newStatus) : o;
    }).toList();
    emit(state.copyWith(orders: updated));
  }

  void _startOrderStatusSimulations(String orderId) {
    // 8 seconds -> Shipped
    Timer(const Duration(seconds: 8), () {
      updateOrderStatus(orderId, 'shipped');
      NotificationService.showNotification(
        title: 'Order Shipped! 🚀',
        body: 'Great news! Your package for Order $orderId has been shipped and is on its way.',
      );
    });

    // 18 seconds -> Out for Delivery
    Timer(const Duration(seconds: 18), () {
      updateOrderStatus(orderId, 'outForDelivery');
      NotificationService.showNotification(
        title: 'Out for Delivery! 📦',
        body: 'Your package for Order $orderId is with the delivery agent and will arrive shortly.',
      );
    });

    // 30 seconds -> Delivered
    Timer(const Duration(seconds: 30), () {
      updateOrderStatus(orderId, 'delivered');
      NotificationService.showNotification(
        title: 'Order Delivered! 🎉',
        body: 'Package for Order $orderId has been successfully delivered. Enjoy your purchase!',
      );
    });
  }
}
