// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_CartItem _$CartItemFromJson(Map<String, dynamic> json) => _CartItem(
  product: Product.fromJson(json['product'] as Map<String, dynamic>),
  quantity: (json['quantity'] as num).toInt(),
  selectedColor: json['selectedColor'] as String?,
  selectedSize: json['selectedSize'] as String?,
  selectedStorage: json['selectedStorage'] as String?,
);

Map<String, dynamic> _$CartItemToJson(_CartItem instance) => <String, dynamic>{
  'product': instance.product,
  'quantity': instance.quantity,
  'selectedColor': instance.selectedColor,
  'selectedSize': instance.selectedSize,
  'selectedStorage': instance.selectedStorage,
};
