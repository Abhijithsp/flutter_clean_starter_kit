import 'package:freezed_annotation/freezed_annotation.dart';
import '../../domain/entities/offer.dart';
import '../../domain/entities/product.dart';

part 'shop_state.freezed.dart';

@freezed
class ShopState with _$ShopState {
  const factory ShopState.initial() = ShopInitial;
  const factory ShopState.loading() = ShopLoading;
  const factory ShopState.success({
    required List<Product> products,
    required List<Product> filteredProducts,
    required List<Offer> offers,
    required List<String> categories,
    required String selectedCategory,
    required String searchQuery,
    @Default('relevance') String sortBy,
    @Default(0.0) double minPrice,
    @Default(2000.0) double maxPrice,
    @Default(0.0) double minRating,
    @Default(false) bool onlyInStock,
  }) = ShopLoaded;
  const factory ShopState.error(String message) = ShopError;
}
