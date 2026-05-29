// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Product _$ProductFromJson(Map<String, dynamic> json) => _Product(
  id: json['id'] as String,
  name: json['name'] as String,
  description: json['description'] as String,
  price: (json['price'] as num).toDouble(),
  originalPrice: (json['originalPrice'] as num).toDouble(),
  discount: (json['discount'] as num).toInt(),
  category: json['category'] as String,
  imageUrl: json['imageUrl'] as String,
  rating: (json['rating'] as num).toDouble(),
  reviewCount: (json['reviewCount'] as num).toInt(),
  inStock: json['inStock'] as bool,
  isFeatured: json['isFeatured'] as bool,
  tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
  colors:
      (json['colors'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  sizes:
      (json['sizes'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
  storage:
      (json['storage'] as List<dynamic>?)?.map((e) => e as String).toList() ??
      const [],
);

Map<String, dynamic> _$ProductToJson(_Product instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'description': instance.description,
  'price': instance.price,
  'originalPrice': instance.originalPrice,
  'discount': instance.discount,
  'category': instance.category,
  'imageUrl': instance.imageUrl,
  'rating': instance.rating,
  'reviewCount': instance.reviewCount,
  'inStock': instance.inStock,
  'isFeatured': instance.isFeatured,
  'tags': instance.tags,
  'colors': instance.colors,
  'sizes': instance.sizes,
  'storage': instance.storage,
};
