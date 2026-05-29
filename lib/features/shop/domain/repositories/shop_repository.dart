import '../entities/product.dart';
import '../entities/offer.dart';

abstract class ShopRepository {
  /// Fetch all products, optionally filtered by [category].
  /// Replace [ShopLocalDataSource] with [ShopRemoteDataSource] to go live.
  Future<List<Product>> getProducts({String? category});

  /// Fetch all promotional offer banners.
  Future<List<Offer>> getOffers();

  /// Fetch a single product by its [id].
  Future<Product?> getProductById(String id);

  /// Fetch all distinct product categories.
  Future<List<String>> getCategories();
}
