// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shop_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShopState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShopState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ShopState()';
}


}

/// @nodoc
class $ShopStateCopyWith<$Res>  {
$ShopStateCopyWith(ShopState _, $Res Function(ShopState) __);
}


/// Adds pattern-matching-related methods to [ShopState].
extension ShopStatePatterns on ShopState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ShopInitial value)?  initial,TResult Function( ShopLoading value)?  loading,TResult Function( ShopLoaded value)?  success,TResult Function( ShopError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ShopInitial() when initial != null:
return initial(_that);case ShopLoading() when loading != null:
return loading(_that);case ShopLoaded() when success != null:
return success(_that);case ShopError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ShopInitial value)  initial,required TResult Function( ShopLoading value)  loading,required TResult Function( ShopLoaded value)  success,required TResult Function( ShopError value)  error,}){
final _that = this;
switch (_that) {
case ShopInitial():
return initial(_that);case ShopLoading():
return loading(_that);case ShopLoaded():
return success(_that);case ShopError():
return error(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ShopInitial value)?  initial,TResult? Function( ShopLoading value)?  loading,TResult? Function( ShopLoaded value)?  success,TResult? Function( ShopError value)?  error,}){
final _that = this;
switch (_that) {
case ShopInitial() when initial != null:
return initial(_that);case ShopLoading() when loading != null:
return loading(_that);case ShopLoaded() when success != null:
return success(_that);case ShopError() when error != null:
return error(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Product> products,  List<Product> filteredProducts,  List<Offer> offers,  List<String> categories,  String selectedCategory,  String searchQuery,  String sortBy,  double minPrice,  double maxPrice,  double minRating,  bool onlyInStock)?  success,TResult Function( String message)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ShopInitial() when initial != null:
return initial();case ShopLoading() when loading != null:
return loading();case ShopLoaded() when success != null:
return success(_that.products,_that.filteredProducts,_that.offers,_that.categories,_that.selectedCategory,_that.searchQuery,_that.sortBy,_that.minPrice,_that.maxPrice,_that.minRating,_that.onlyInStock);case ShopError() when error != null:
return error(_that.message);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Product> products,  List<Product> filteredProducts,  List<Offer> offers,  List<String> categories,  String selectedCategory,  String searchQuery,  String sortBy,  double minPrice,  double maxPrice,  double minRating,  bool onlyInStock)  success,required TResult Function( String message)  error,}) {final _that = this;
switch (_that) {
case ShopInitial():
return initial();case ShopLoading():
return loading();case ShopLoaded():
return success(_that.products,_that.filteredProducts,_that.offers,_that.categories,_that.selectedCategory,_that.searchQuery,_that.sortBy,_that.minPrice,_that.maxPrice,_that.minRating,_that.onlyInStock);case ShopError():
return error(_that.message);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Product> products,  List<Product> filteredProducts,  List<Offer> offers,  List<String> categories,  String selectedCategory,  String searchQuery,  String sortBy,  double minPrice,  double maxPrice,  double minRating,  bool onlyInStock)?  success,TResult? Function( String message)?  error,}) {final _that = this;
switch (_that) {
case ShopInitial() when initial != null:
return initial();case ShopLoading() when loading != null:
return loading();case ShopLoaded() when success != null:
return success(_that.products,_that.filteredProducts,_that.offers,_that.categories,_that.selectedCategory,_that.searchQuery,_that.sortBy,_that.minPrice,_that.maxPrice,_that.minRating,_that.onlyInStock);case ShopError() when error != null:
return error(_that.message);case _:
  return null;

}
}

}

/// @nodoc


class ShopInitial implements ShopState {
  const ShopInitial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShopInitial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ShopState.initial()';
}


}




/// @nodoc


class ShopLoading implements ShopState {
  const ShopLoading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShopLoading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ShopState.loading()';
}


}




/// @nodoc


class ShopLoaded implements ShopState {
  const ShopLoaded({required final  List<Product> products, required final  List<Product> filteredProducts, required final  List<Offer> offers, required final  List<String> categories, required this.selectedCategory, required this.searchQuery, this.sortBy = 'relevance', this.minPrice = 0.0, this.maxPrice = 2000.0, this.minRating = 0.0, this.onlyInStock = false}): _products = products,_filteredProducts = filteredProducts,_offers = offers,_categories = categories;
  

 final  List<Product> _products;
 List<Product> get products {
  if (_products is EqualUnmodifiableListView) return _products;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_products);
}

 final  List<Product> _filteredProducts;
 List<Product> get filteredProducts {
  if (_filteredProducts is EqualUnmodifiableListView) return _filteredProducts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_filteredProducts);
}

 final  List<Offer> _offers;
 List<Offer> get offers {
  if (_offers is EqualUnmodifiableListView) return _offers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_offers);
}

 final  List<String> _categories;
 List<String> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

 final  String selectedCategory;
 final  String searchQuery;
@JsonKey() final  String sortBy;
@JsonKey() final  double minPrice;
@JsonKey() final  double maxPrice;
@JsonKey() final  double minRating;
@JsonKey() final  bool onlyInStock;

/// Create a copy of ShopState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShopLoadedCopyWith<ShopLoaded> get copyWith => _$ShopLoadedCopyWithImpl<ShopLoaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShopLoaded&&const DeepCollectionEquality().equals(other._products, _products)&&const DeepCollectionEquality().equals(other._filteredProducts, _filteredProducts)&&const DeepCollectionEquality().equals(other._offers, _offers)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.selectedCategory, selectedCategory) || other.selectedCategory == selectedCategory)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery)&&(identical(other.sortBy, sortBy) || other.sortBy == sortBy)&&(identical(other.minPrice, minPrice) || other.minPrice == minPrice)&&(identical(other.maxPrice, maxPrice) || other.maxPrice == maxPrice)&&(identical(other.minRating, minRating) || other.minRating == minRating)&&(identical(other.onlyInStock, onlyInStock) || other.onlyInStock == onlyInStock));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_products),const DeepCollectionEquality().hash(_filteredProducts),const DeepCollectionEquality().hash(_offers),const DeepCollectionEquality().hash(_categories),selectedCategory,searchQuery,sortBy,minPrice,maxPrice,minRating,onlyInStock);

@override
String toString() {
  return 'ShopState.success(products: $products, filteredProducts: $filteredProducts, offers: $offers, categories: $categories, selectedCategory: $selectedCategory, searchQuery: $searchQuery, sortBy: $sortBy, minPrice: $minPrice, maxPrice: $maxPrice, minRating: $minRating, onlyInStock: $onlyInStock)';
}


}

/// @nodoc
abstract mixin class $ShopLoadedCopyWith<$Res> implements $ShopStateCopyWith<$Res> {
  factory $ShopLoadedCopyWith(ShopLoaded value, $Res Function(ShopLoaded) _then) = _$ShopLoadedCopyWithImpl;
@useResult
$Res call({
 List<Product> products, List<Product> filteredProducts, List<Offer> offers, List<String> categories, String selectedCategory, String searchQuery, String sortBy, double minPrice, double maxPrice, double minRating, bool onlyInStock
});




}
/// @nodoc
class _$ShopLoadedCopyWithImpl<$Res>
    implements $ShopLoadedCopyWith<$Res> {
  _$ShopLoadedCopyWithImpl(this._self, this._then);

  final ShopLoaded _self;
  final $Res Function(ShopLoaded) _then;

/// Create a copy of ShopState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? products = null,Object? filteredProducts = null,Object? offers = null,Object? categories = null,Object? selectedCategory = null,Object? searchQuery = null,Object? sortBy = null,Object? minPrice = null,Object? maxPrice = null,Object? minRating = null,Object? onlyInStock = null,}) {
  return _then(ShopLoaded(
products: null == products ? _self._products : products // ignore: cast_nullable_to_non_nullable
as List<Product>,filteredProducts: null == filteredProducts ? _self._filteredProducts : filteredProducts // ignore: cast_nullable_to_non_nullable
as List<Product>,offers: null == offers ? _self._offers : offers // ignore: cast_nullable_to_non_nullable
as List<Offer>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<String>,selectedCategory: null == selectedCategory ? _self.selectedCategory : selectedCategory // ignore: cast_nullable_to_non_nullable
as String,searchQuery: null == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String,sortBy: null == sortBy ? _self.sortBy : sortBy // ignore: cast_nullable_to_non_nullable
as String,minPrice: null == minPrice ? _self.minPrice : minPrice // ignore: cast_nullable_to_non_nullable
as double,maxPrice: null == maxPrice ? _self.maxPrice : maxPrice // ignore: cast_nullable_to_non_nullable
as double,minRating: null == minRating ? _self.minRating : minRating // ignore: cast_nullable_to_non_nullable
as double,onlyInStock: null == onlyInStock ? _self.onlyInStock : onlyInStock // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

/// @nodoc


class ShopError implements ShopState {
  const ShopError(this.message);
  

 final  String message;

/// Create a copy of ShopState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShopErrorCopyWith<ShopError> get copyWith => _$ShopErrorCopyWithImpl<ShopError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShopError&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ShopState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class $ShopErrorCopyWith<$Res> implements $ShopStateCopyWith<$Res> {
  factory $ShopErrorCopyWith(ShopError value, $Res Function(ShopError) _then) = _$ShopErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ShopErrorCopyWithImpl<$Res>
    implements $ShopErrorCopyWith<$Res> {
  _$ShopErrorCopyWithImpl(this._self, this._then);

  final ShopError _self;
  final $Res Function(ShopError) _then;

/// Create a copy of ShopState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ShopError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
