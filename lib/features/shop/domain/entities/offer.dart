import 'package:freezed_annotation/freezed_annotation.dart';

part 'offer.freezed.dart';
part 'offer.g.dart';

@freezed
abstract class Offer with _$Offer {
  const factory Offer({
    required String id,
    required String title,
    required String subtitle,
    required int discountPercent,
    required String gradientStart,
    required String gradientEnd,
    required String imageUrl,
    required String validUntil,
    required String badgeText,
    required String category,
  }) = _Offer;

  factory Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);
}
