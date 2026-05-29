import 'dart:convert';
import 'package:flutter/services.dart';

// ─────────────────────────────────────────────────────────────────────────────
// Abstract contract — swap [ShopLocalDataSource] with [ShopRemoteDataSource]
// (Dio-based) without changing the repository or any Cubit.
// Both implementations must produce the same JSON structure as assets/data/.
// ─────────────────────────────────────────────────────────────────────────────
abstract class ShopDataSource {
  Future<List<Map<String, dynamic>>> fetchProducts({String? category});
  Future<List<Map<String, dynamic>>> fetchOffers();
}

// ─────────────────────────────────────────────────────────────────────────────
// Local implementation — reads from bundled JSON assets.
// Replace with ShopRemoteDataSource (Dio) to connect to a real backend.
// ─────────────────────────────────────────────────────────────────────────────
class ShopLocalDataSource implements ShopDataSource {
  static const _productsAsset = 'assets/data/products.json';
  static const _offersAsset = 'assets/data/offers.json';

  @override
  Future<List<Map<String, dynamic>>> fetchProducts({String? category}) async {
    final jsonStr = await rootBundle.loadString(_productsAsset);
    final decoded = json.decode(jsonStr) as Map<String, dynamic>;
    final list = (decoded['products'] as List)
        .cast<Map<String, dynamic>>();

    if (category != null && category != 'All') {
      return list.where((p) => p['category'] == category).toList();
    }
    return list;
  }

  @override
  Future<List<Map<String, dynamic>>> fetchOffers() async {
    final jsonStr = await rootBundle.loadString(_offersAsset);
    final decoded = json.decode(jsonStr) as Map<String, dynamic>;
    return (decoded['offers'] as List).cast<Map<String, dynamic>>();
  }
}

// ─────────────────────────────────────────────────────────────────────────────
// Example skeleton for a future remote data source using Dio.
// Uncomment and replace ShopLocalDataSource in main.dart when backend is ready.
// ─────────────────────────────────────────────────────────────────────────────
// class ShopRemoteDataSource implements ShopDataSource {
//   final Dio dio;
//   ShopRemoteDataSource(this.dio);
//
//   @override
//   Future<List<Map<String, dynamic>>> fetchProducts({String? category}) async {
//     final response = await dio.get(
//       'https://api.yourbackend.com/products',
//       queryParameters: category != null ? {'category': category} : null,
//     );
//     return (response.data['products'] as List).cast<Map<String, dynamic>>();
//   }
//
//   @override
//   Future<List<Map<String, dynamic>>> fetchOffers() async {
//     final response = await dio.get('https://api.yourbackend.com/offers');
//     return (response.data['offers'] as List).cast<Map<String, dynamic>>();
//   }
// }
