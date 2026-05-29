import 'package:freezed_annotation/freezed_annotation.dart';
import 'product.dart';

part 'cart_item.freezed.dart';
part 'cart_item.g.dart';

@freezed
abstract class CartItem with _$CartItem {
  const factory CartItem({
    required Product product,
    required int quantity,
    String? selectedColor,
    String? selectedSize,
    String? selectedStorage,
  }) = _CartItem;

  const CartItem._();

  double get totalPrice => product.price * quantity;

  String get uniqueKey => '${product.id}_${selectedColor ?? ""}_${selectedSize ?? ""}_${selectedStorage ?? ""}';

  factory CartItem.fromJson(Map<String, dynamic> json) => _$CartItemFromJson(json);
}
