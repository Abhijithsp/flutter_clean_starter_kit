import 'package:freezed_annotation/freezed_annotation.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
abstract class Product with _$Product {
  const factory Product({
    required String id,
    required String name,
    required String description,
    required double price,
    required double originalPrice,
    required int discount,
    required String category,
    required String imageUrl,
    required double rating,
    required int reviewCount,
    required bool inStock,
    required bool isFeatured,
    required List<String> tags,
    @Default([]) List<String> colors,
    @Default([]) List<String> sizes,
    @Default([]) List<String> storage,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}
