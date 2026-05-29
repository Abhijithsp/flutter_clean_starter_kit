import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/cart_item.dart';
import '../../domain/entities/product.dart';
import 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit() : super(const CartState());

  void addItem(Product product, {String? color, String? size, String? storage, int quantity = 1}) {
    final targetKey = '${product.id}_${color ?? ""}_${size ?? ""}_${storage ?? ""}';
    final existing = state.items.indexWhere((i) => i.uniqueKey == targetKey);
    
    if (existing != -1) {
      final updated = state.items[existing].copyWith(
        quantity: state.items[existing].quantity + quantity,
      );
      final newItems = List<CartItem>.from(state.items)..[existing] = updated;
      emit(state.copyWith(items: newItems));
    } else {
      emit(state.copyWith(
        items: [
          ...state.items,
          CartItem(
            product: product,
            quantity: quantity,
            selectedColor: color,
            selectedSize: size,
            selectedStorage: storage,
          ),
        ],
      ));
    }
  }

  void removeItem(String uniqueKey) {
    emit(state.copyWith(
      items: state.items.where((i) => i.uniqueKey != uniqueKey).toList(),
    ));
  }

  void updateQuantity(String uniqueKey, int qty) {
    if (qty <= 0) {
      removeItem(uniqueKey);
      return;
    }
    final updated = state.items.map((i) {
      return i.uniqueKey == uniqueKey ? i.copyWith(quantity: qty) : i;
    }).toList();
    emit(state.copyWith(items: updated));
  }

  void clearCart() => emit(const CartState());
}
