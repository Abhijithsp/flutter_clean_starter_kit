import 'package:freezed_annotation/freezed_annotation.dart';
import 'cart_item.dart';

part 'shop_order.freezed.dart';
part 'shop_order.g.dart';

@freezed
abstract class ShopOrder with _$ShopOrder {
  const factory ShopOrder({
    required String id,
    required List<CartItem> items,
    required double totalAmount,
    required DateTime orderDate,
    required String status, // 'processing', 'shipped', 'outForDelivery', 'delivered'
    required String deliveryAddress,
    required String paymentMethod,
  }) = _ShopOrder;

  factory ShopOrder.fromJson(Map<String, dynamic> json) => _$ShopOrderFromJson(json);
}
