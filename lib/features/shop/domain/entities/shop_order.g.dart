// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shop_order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ShopOrder _$ShopOrderFromJson(Map<String, dynamic> json) => _ShopOrder(
  id: json['id'] as String,
  items: (json['items'] as List<dynamic>)
      .map((e) => CartItem.fromJson(e as Map<String, dynamic>))
      .toList(),
  totalAmount: (json['totalAmount'] as num).toDouble(),
  orderDate: DateTime.parse(json['orderDate'] as String),
  status: json['status'] as String,
  deliveryAddress: json['deliveryAddress'] as String,
  paymentMethod: json['paymentMethod'] as String,
);

Map<String, dynamic> _$ShopOrderToJson(_ShopOrder instance) =>
    <String, dynamic>{
      'id': instance.id,
      'items': instance.items,
      'totalAmount': instance.totalAmount,
      'orderDate': instance.orderDate.toIso8601String(),
      'status': instance.status,
      'deliveryAddress': instance.deliveryAddress,
      'paymentMethod': instance.paymentMethod,
    };
