// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'offer.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Offer {

 String get id; String get title; String get subtitle; int get discountPercent; String get gradientStart; String get gradientEnd; String get imageUrl; String get validUntil; String get badgeText; String get category;
/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OfferCopyWith<Offer> get copyWith => _$OfferCopyWithImpl<Offer>(this as Offer, _$identity);

  /// Serializes this Offer to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Offer&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&(identical(other.gradientStart, gradientStart) || other.gradientStart == gradientStart)&&(identical(other.gradientEnd, gradientEnd) || other.gradientEnd == gradientEnd)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.validUntil, validUntil) || other.validUntil == validUntil)&&(identical(other.badgeText, badgeText) || other.badgeText == badgeText)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,discountPercent,gradientStart,gradientEnd,imageUrl,validUntil,badgeText,category);

@override
String toString() {
  return 'Offer(id: $id, title: $title, subtitle: $subtitle, discountPercent: $discountPercent, gradientStart: $gradientStart, gradientEnd: $gradientEnd, imageUrl: $imageUrl, validUntil: $validUntil, badgeText: $badgeText, category: $category)';
}


}

/// @nodoc
abstract mixin class $OfferCopyWith<$Res>  {
  factory $OfferCopyWith(Offer value, $Res Function(Offer) _then) = _$OfferCopyWithImpl;
@useResult
$Res call({
 String id, String title, String subtitle, int discountPercent, String gradientStart, String gradientEnd, String imageUrl, String validUntil, String badgeText, String category
});




}
/// @nodoc
class _$OfferCopyWithImpl<$Res>
    implements $OfferCopyWith<$Res> {
  _$OfferCopyWithImpl(this._self, this._then);

  final Offer _self;
  final $Res Function(Offer) _then;

/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? subtitle = null,Object? discountPercent = null,Object? gradientStart = null,Object? gradientEnd = null,Object? imageUrl = null,Object? validUntil = null,Object? badgeText = null,Object? category = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,discountPercent: null == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as int,gradientStart: null == gradientStart ? _self.gradientStart : gradientStart // ignore: cast_nullable_to_non_nullable
as String,gradientEnd: null == gradientEnd ? _self.gradientEnd : gradientEnd // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,validUntil: null == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as String,badgeText: null == badgeText ? _self.badgeText : badgeText // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Offer].
extension OfferPatterns on Offer {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Offer value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Offer() when $default != null:
return $default(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Offer value)  $default,){
final _that = this;
switch (_that) {
case _Offer():
return $default(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Offer value)?  $default,){
final _that = this;
switch (_that) {
case _Offer() when $default != null:
return $default(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  String title,  String subtitle,  int discountPercent,  String gradientStart,  String gradientEnd,  String imageUrl,  String validUntil,  String badgeText,  String category)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Offer() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.discountPercent,_that.gradientStart,_that.gradientEnd,_that.imageUrl,_that.validUntil,_that.badgeText,_that.category);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  String title,  String subtitle,  int discountPercent,  String gradientStart,  String gradientEnd,  String imageUrl,  String validUntil,  String badgeText,  String category)  $default,) {final _that = this;
switch (_that) {
case _Offer():
return $default(_that.id,_that.title,_that.subtitle,_that.discountPercent,_that.gradientStart,_that.gradientEnd,_that.imageUrl,_that.validUntil,_that.badgeText,_that.category);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  String title,  String subtitle,  int discountPercent,  String gradientStart,  String gradientEnd,  String imageUrl,  String validUntil,  String badgeText,  String category)?  $default,) {final _that = this;
switch (_that) {
case _Offer() when $default != null:
return $default(_that.id,_that.title,_that.subtitle,_that.discountPercent,_that.gradientStart,_that.gradientEnd,_that.imageUrl,_that.validUntil,_that.badgeText,_that.category);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Offer implements Offer {
  const _Offer({required this.id, required this.title, required this.subtitle, required this.discountPercent, required this.gradientStart, required this.gradientEnd, required this.imageUrl, required this.validUntil, required this.badgeText, required this.category});
  factory _Offer.fromJson(Map<String, dynamic> json) => _$OfferFromJson(json);

@override final  String id;
@override final  String title;
@override final  String subtitle;
@override final  int discountPercent;
@override final  String gradientStart;
@override final  String gradientEnd;
@override final  String imageUrl;
@override final  String validUntil;
@override final  String badgeText;
@override final  String category;

/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OfferCopyWith<_Offer> get copyWith => __$OfferCopyWithImpl<_Offer>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OfferToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Offer&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.subtitle, subtitle) || other.subtitle == subtitle)&&(identical(other.discountPercent, discountPercent) || other.discountPercent == discountPercent)&&(identical(other.gradientStart, gradientStart) || other.gradientStart == gradientStart)&&(identical(other.gradientEnd, gradientEnd) || other.gradientEnd == gradientEnd)&&(identical(other.imageUrl, imageUrl) || other.imageUrl == imageUrl)&&(identical(other.validUntil, validUntil) || other.validUntil == validUntil)&&(identical(other.badgeText, badgeText) || other.badgeText == badgeText)&&(identical(other.category, category) || other.category == category));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,title,subtitle,discountPercent,gradientStart,gradientEnd,imageUrl,validUntil,badgeText,category);

@override
String toString() {
  return 'Offer(id: $id, title: $title, subtitle: $subtitle, discountPercent: $discountPercent, gradientStart: $gradientStart, gradientEnd: $gradientEnd, imageUrl: $imageUrl, validUntil: $validUntil, badgeText: $badgeText, category: $category)';
}


}

/// @nodoc
abstract mixin class _$OfferCopyWith<$Res> implements $OfferCopyWith<$Res> {
  factory _$OfferCopyWith(_Offer value, $Res Function(_Offer) _then) = __$OfferCopyWithImpl;
@override @useResult
$Res call({
 String id, String title, String subtitle, int discountPercent, String gradientStart, String gradientEnd, String imageUrl, String validUntil, String badgeText, String category
});




}
/// @nodoc
class __$OfferCopyWithImpl<$Res>
    implements _$OfferCopyWith<$Res> {
  __$OfferCopyWithImpl(this._self, this._then);

  final _Offer _self;
  final $Res Function(_Offer) _then;

/// Create a copy of Offer
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? subtitle = null,Object? discountPercent = null,Object? gradientStart = null,Object? gradientEnd = null,Object? imageUrl = null,Object? validUntil = null,Object? badgeText = null,Object? category = null,}) {
  return _then(_Offer(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,subtitle: null == subtitle ? _self.subtitle : subtitle // ignore: cast_nullable_to_non_nullable
as String,discountPercent: null == discountPercent ? _self.discountPercent : discountPercent // ignore: cast_nullable_to_non_nullable
as int,gradientStart: null == gradientStart ? _self.gradientStart : gradientStart // ignore: cast_nullable_to_non_nullable
as String,gradientEnd: null == gradientEnd ? _self.gradientEnd : gradientEnd // ignore: cast_nullable_to_non_nullable
as String,imageUrl: null == imageUrl ? _self.imageUrl : imageUrl // ignore: cast_nullable_to_non_nullable
as String,validUntil: null == validUntil ? _self.validUntil : validUntil // ignore: cast_nullable_to_non_nullable
as String,badgeText: null == badgeText ? _self.badgeText : badgeText // ignore: cast_nullable_to_non_nullable
as String,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
