import '../../domain/entities/offer.dart';
import '../../domain/entities/product.dart';
import '../../domain/repositories/shop_repository.dart';
import '../sources/shop_data_source.dart';

class ShopRepositoryImpl implements ShopRepository {
  final ShopDataSource dataSource;

  ShopRepositoryImpl(this.dataSource);

  @override
  Future<List<Product>> getProducts({String? category}) async {
    final raw = await dataSource.fetchProducts(category: category);
    return raw.map(Product.fromJson).toList();
  }

  @override
  Future<List<Offer>> getOffers() async {
    final raw = await dataSource.fetchOffers();
    return raw.map(Offer.fromJson).toList();
  }

  @override
  Future<Product?> getProductById(String id) async {
    final all = await getProducts();
    try {
      return all.firstWhere((p) => p.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<List<String>> getCategories() async {
    final all = await getProducts();
    final cats = all.map((p) => p.category).toSet().toList()..sort();
    return ['All', ...cats];
  }
}
