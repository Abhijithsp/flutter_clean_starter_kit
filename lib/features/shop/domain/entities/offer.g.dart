// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'offer.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Offer _$OfferFromJson(Map<String, dynamic> json) => _Offer(
  id: json['id'] as String,
  title: json['title'] as String,
  subtitle: json['subtitle'] as String,
  discountPercent: (json['discountPercent'] as num).toInt(),
  gradientStart: json['gradientStart'] as String,
  gradientEnd: json['gradientEnd'] as String,
  imageUrl: json['imageUrl'] as String,
  validUntil: json['validUntil'] as String,
  badgeText: json['badgeText'] as String,
  category: json['category'] as String,
);

Map<String, dynamic> _$OfferToJson(_Offer instance) => <String, dynamic>{
  'id': instance.id,
  'title': instance.title,
  'subtitle': instance.subtitle,
  'discountPercent': instance.discountPercent,
  'gradientStart': instance.gradientStart,
  'gradientEnd': instance.gradientEnd,
  'imageUrl': instance.imageUrl,
  'validUntil': instance.validUntil,
  'badgeText': instance.badgeText,
  'category': instance.category,
};
