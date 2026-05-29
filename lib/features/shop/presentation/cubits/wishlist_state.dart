import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/product.dart';

part 'wishlist_state.freezed.dart';

@freezed
abstract class WishlistState with _$WishlistState {
  const factory WishlistState({
    @Default([]) List<Product> items,
  }) = _WishlistState;
}
