// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop_order.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ShopOrder {

 String get id; List<CartItem> get items; double get totalAmount; DateTime get orderDate; String get status;// 'processing', 'shipped', 'outForDelivery', 'delivered'
 String get deliveryAddress; String get paymentMethod;
/// Create a copy of ShopOrder
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShopOrderCopyWith<ShopOrder> get copyWith => _$ShopOrderCopyWithImpl<ShopOrder>(this as ShopOrder, _$identity);

  /// Serializes this ShopOrder to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShopOrder&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other.items, items)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.orderDate, orderDate) || other.orderDate == orderDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.deliveryAddress, deliveryAddress) || other.deliveryAddress == deliveryAddress)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(items),totalAmount,orderDate,status,deliveryAddress,paymentMethod);

@override
String toString() {
  return 'ShopOrder(id: $id, items: $items, totalAmount: $totalAmount, orderDate: $orderDate, status: $status, deliveryAddress: $deliveryAddress, paymentMethod: $paymentMethod)';
}


}

/// @nodoc
abstract mixin class $ShopOrderCopyWith<$Res>  {
  factory $ShopOrderCopyWith(ShopOrder value, $Res Function(ShopOrder) _then) = _$ShopOrderCopyWithImpl;
@useResult
$Res call({
 String id, List<CartItem> items, double totalAmount, DateTime orderDate, String status, String deliveryAddress, String paymentMethod
});




}
/// @nodoc
class _$ShopOrderCopyWithImpl<$Res>
    implements $ShopOrderCopyWith<$Res> {
  _$ShopOrderCopyWithImpl(this._self, this._then);

  final ShopOrder _self;
  final $Res Function(ShopOrder) _then;

/// Create a copy of ShopOrder
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? items = null,Object? totalAmount = null,Object? orderDate = null,Object? status = null,Object? deliveryAddress = null,Object? paymentMethod = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self.items : items // ignore: cast_nullable_to_non_nullable
as List<CartItem>,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,orderDate: null == orderDate ? _self.orderDate : orderDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,deliveryAddress: null == deliveryAddress ? _self.deliveryAddress : deliveryAddress // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [ShopOrder].
extension ShopOrderPatterns on ShopOrder {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShopOrder value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShopOrder() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShopOrder value)  $default,){
final _that = this;
switch (_that) {
case _ShopOrder():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShopOrder value)?  $default,){
final _that = this;
switch (_that) {
case _ShopOrder() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String id,  List<CartItem> items,  double totalAmount,  DateTime orderDate,  String status,  String deliveryAddress,  String paymentMethod)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShopOrder() when $default != null:
return $default(_that.id,_that.items,_that.totalAmount,_that.orderDate,_that.status,_that.deliveryAddress,_that.paymentMethod);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String id,  List<CartItem> items,  double totalAmount,  DateTime orderDate,  String status,  String deliveryAddress,  String paymentMethod)  $default,) {final _that = this;
switch (_that) {
case _ShopOrder():
return $default(_that.id,_that.items,_that.totalAmount,_that.orderDate,_that.status,_that.deliveryAddress,_that.paymentMethod);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String id,  List<CartItem> items,  double totalAmount,  DateTime orderDate,  String status,  String deliveryAddress,  String paymentMethod)?  $default,) {final _that = this;
switch (_that) {
case _ShopOrder() when $default != null:
return $default(_that.id,_that.items,_that.totalAmount,_that.orderDate,_that.status,_that.deliveryAddress,_that.paymentMethod);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ShopOrder implements ShopOrder {
  const _ShopOrder({required this.id, required final  List<CartItem> items, required this.totalAmount, required this.orderDate, required this.status, required this.deliveryAddress, required this.paymentMethod}): _items = items;
  factory _ShopOrder.fromJson(Map<String, dynamic> json) => _$ShopOrderFromJson(json);

@override final  String id;
 final  List<CartItem> _items;
@override List<CartItem> get items {
  if (_items is EqualUnmodifiableListView) return _items;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_items);
}

@override final  double totalAmount;
@override final  DateTime orderDate;
@override final  String status;
// 'processing', 'shipped', 'outForDelivery', 'delivered'
@override final  String deliveryAddress;
@override final  String paymentMethod;

/// Create a copy of ShopOrder
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShopOrderCopyWith<_ShopOrder> get copyWith => __$ShopOrderCopyWithImpl<_ShopOrder>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ShopOrderToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShopOrder&&(identical(other.id, id) || other.id == id)&&const DeepCollectionEquality().equals(other._items, _items)&&(identical(other.totalAmount, totalAmount) || other.totalAmount == totalAmount)&&(identical(other.orderDate, orderDate) || other.orderDate == orderDate)&&(identical(other.status, status) || other.status == status)&&(identical(other.deliveryAddress, deliveryAddress) || other.deliveryAddress == deliveryAddress)&&(identical(other.paymentMethod, paymentMethod) || other.paymentMethod == paymentMethod));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,id,const DeepCollectionEquality().hash(_items),totalAmount,orderDate,status,deliveryAddress,paymentMethod);

@override
String toString() {
  return 'ShopOrder(id: $id, items: $items, totalAmount: $totalAmount, orderDate: $orderDate, status: $status, deliveryAddress: $deliveryAddress, paymentMethod: $paymentMethod)';
}


}

/// @nodoc
abstract mixin class _$ShopOrderCopyWith<$Res> implements $ShopOrderCopyWith<$Res> {
  factory _$ShopOrderCopyWith(_ShopOrder value, $Res Function(_ShopOrder) _then) = __$ShopOrderCopyWithImpl;
@override @useResult
$Res call({
 String id, List<CartItem> items, double totalAmount, DateTime orderDate, String status, String deliveryAddress, String paymentMethod
});




}
/// @nodoc
class __$ShopOrderCopyWithImpl<$Res>
    implements _$ShopOrderCopyWith<$Res> {
  __$ShopOrderCopyWithImpl(this._self, this._then);

  final _ShopOrder _self;
  final $Res Function(_ShopOrder) _then;

/// Create a copy of ShopOrder
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? items = null,Object? totalAmount = null,Object? orderDate = null,Object? status = null,Object? deliveryAddress = null,Object? paymentMethod = null,}) {
  return _then(_ShopOrder(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String,items: null == items ? _self._items : items // ignore: cast_nullable_to_non_nullable
as List<CartItem>,totalAmount: null == totalAmount ? _self.totalAmount : totalAmount // ignore: cast_nullable_to_non_nullable
as double,orderDate: null == orderDate ? _self.orderDate : orderDate // ignore: cast_nullable_to_non_nullable
as DateTime,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as String,deliveryAddress: null == deliveryAddress ? _self.deliveryAddress : deliveryAddress // ignore: cast_nullable_to_non_nullable
as String,paymentMethod: null == paymentMethod ? _self.paymentMethod : paymentMethod // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
