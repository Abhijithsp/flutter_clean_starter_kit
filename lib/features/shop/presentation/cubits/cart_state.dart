import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/cart_item.dart';

part 'cart_state.freezed.dart';

@freezed
abstract class CartState with _$CartState {
  const CartState._();

  const factory CartState({
    @Default([]) List<CartItem> items,
  }) = _CartState;

  int get totalItems => items.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal =>
      items.fold(0.0, (sum, item) => sum + item.totalPrice);

  double get discountAmount =>
      items.fold(
        0.0,
        (sum, item) =>
            sum +
            (item.product.originalPrice - item.product.price) * item.quantity,
      );

  double get deliveryFee => subtotal > 99 ? 0.0 : 9.99;

  double get total => subtotal + deliveryFee;

  bool get isEmpty => items.isEmpty;

  bool containsProduct(String productId) =>
      items.any((i) => i.product.id == productId);

  int quantityOf(String productId) {
    try {
      return items.firstWhere((i) => i.product.id == productId).quantity;
    } catch (_) {
      return 0;
    }
  }

  bool containsVariant(String uniqueKey) =>
      items.any((i) => i.uniqueKey == uniqueKey);

  int quantityOfVariant(String uniqueKey) {
    try {
      return items.firstWhere((i) => i.uniqueKey == uniqueKey).quantity;
    } catch (_) {
      return 0;
    }
  }
}
