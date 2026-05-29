import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/entities/product.dart';
import 'cart_cubit.dart';
import 'wishlist_state.dart';

class WishlistCubit extends Cubit<WishlistState> {
  WishlistCubit() : super(const WishlistState());

  void toggleProduct(Product product) {
    final exists = state.items.any((i) => i.id == product.id);
    if (exists) {
      final updated = state.items.where((i) => i.id != product.id).toList();
      emit(state.copyWith(items: updated));
    } else {
      emit(state.copyWith(items: [...state.items, product]));
    }
  }

  bool containsProduct(String id) {
    return state.items.any((i) => i.id == id);
  }

  void moveToCart(Product product, CartCubit cartCubit, {String? color, String? size, String? storage}) {
    // Add to cart with selected variants
    cartCubit.addItem(product, color: color, size: size, storage: storage);
    
    // Remove from wishlist
    final updated = state.items.where((i) => i.id != product.id).toList();
    emit(state.copyWith(items: updated));
  }
}
