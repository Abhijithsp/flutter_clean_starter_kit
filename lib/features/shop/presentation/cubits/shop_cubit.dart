import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/repositories/shop_repository.dart';
import '../../domain/entities/product.dart';
import 'shop_state.dart';

class ShopCubit extends Cubit<ShopState> {
  final ShopRepository shopRepository;

  ShopCubit({required this.shopRepository}) : super(const ShopState.initial());

  Future<void> loadAll() async {
    emit(const ShopState.loading());
    try {
      final results = await Future.wait([
        shopRepository.getProducts(),
        shopRepository.getOffers(),
        shopRepository.getCategories(),
      ]);

      final products = results[0] as dynamic;
      final offers = results[1] as dynamic;
      final categories = results[2] as dynamic;

      emit(ShopState.success(
        products: products,
        filteredProducts: products,
        offers: offers,
        categories: categories,
        selectedCategory: 'All',
        searchQuery: '',
      ));
    } catch (e) {
      emit(ShopState.error(e.toString()));
    }
  }

  void filterByCategory(String category) {
    applyFilters(category: category);
  }

  void searchProducts(String query) {
    applyFilters(query: query);
  }

  void applyFilters({
    String? sortBy,
    double? minPrice,
    double? maxPrice,
    double? minRating,
    bool? onlyInStock,
    String? category,
    String? query,
  }) {
    final current = state;
    if (current is! ShopLoaded) return;

    final newSortBy = sortBy ?? current.sortBy;
    final newMinPrice = minPrice ?? current.minPrice;
    final newMaxPrice = maxPrice ?? current.maxPrice;
    final newMinRating = minRating ?? current.minRating;
    final newOnlyInStock = onlyInStock ?? current.onlyInStock;
    final newCategory = category ?? current.selectedCategory;
    final newQuery = query ?? current.searchQuery;

    List<Product> temp = List<Product>.from(current.products);

    // 1. Category Filter
    if (newCategory != 'All') {
      temp = temp.where((p) => p.category == newCategory).toList();
    }

    // 2. Search query filter
    if (newQuery.isNotEmpty) {
      temp = temp.where((p) =>
        p.name.toLowerCase().contains(newQuery.toLowerCase()) ||
        p.description.toLowerCase().contains(newQuery.toLowerCase()) ||
        p.category.toLowerCase().contains(newQuery.toLowerCase())
      ).toList();
    }

    // 3. Price Filter
    temp = temp.where((p) => p.price >= newMinPrice && p.price <= newMaxPrice).toList();

    // 4. Rating Filter
    if (newMinRating > 0) {
      temp = temp.where((p) => p.rating >= newMinRating).toList();
    }

    // 5. Stock Filter
    if (newOnlyInStock) {
      temp = temp.where((p) => p.inStock).toList();
    }

    // 6. Sorting
    if (newSortBy == 'priceLowHigh') {
      temp.sort((a, b) => a.price.compareTo(b.price));
    } else if (newSortBy == 'priceHighLow') {
      temp.sort((a, b) => b.price.compareTo(a.price));
    } else if (newSortBy == 'ratingHighLow') {
      temp.sort((a, b) => b.rating.compareTo(a.rating));
    } else if (newSortBy == 'nameAZ') {
      temp.sort((a, b) => a.name.compareTo(b.name));
    }

    emit(current.copyWith(
      filteredProducts: temp,
      sortBy: newSortBy,
      minPrice: newMinPrice,
      maxPrice: newMaxPrice,
      minRating: newMinRating,
      onlyInStock: newOnlyInStock,
      selectedCategory: newCategory,
      searchQuery: newQuery,
    ));
  }

  void resetFilters() {
    final current = state;
    if (current is! ShopLoaded) return;
    
    emit(current.copyWith(
      filteredProducts: List<Product>.from(current.products),
      sortBy: 'relevance',
      minPrice: 0.0,
      maxPrice: 2000.0,
      minRating: 0.0,
      onlyInStock: false,
      selectedCategory: 'All',
      searchQuery: '',
    ));
  }
}
