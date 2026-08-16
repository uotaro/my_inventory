// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item_filter_controller.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ItemFilter {

 int? get categoryId; int? get subCategoryId; int? get colorGroupId; bool get inStockOnly; String get nameQuery; int? get favoriteMin; int? get favoriteMax; ItemSortKey? get sortKey; bool get sortAscending;
/// Create a copy of ItemFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemFilterCopyWith<ItemFilter> get copyWith => _$ItemFilterCopyWithImpl<ItemFilter>(this as ItemFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ItemFilter&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.subCategoryId, subCategoryId) || other.subCategoryId == subCategoryId)&&(identical(other.colorGroupId, colorGroupId) || other.colorGroupId == colorGroupId)&&(identical(other.inStockOnly, inStockOnly) || other.inStockOnly == inStockOnly)&&(identical(other.nameQuery, nameQuery) || other.nameQuery == nameQuery)&&(identical(other.favoriteMin, favoriteMin) || other.favoriteMin == favoriteMin)&&(identical(other.favoriteMax, favoriteMax) || other.favoriteMax == favoriteMax)&&(identical(other.sortKey, sortKey) || other.sortKey == sortKey)&&(identical(other.sortAscending, sortAscending) || other.sortAscending == sortAscending));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,subCategoryId,colorGroupId,inStockOnly,nameQuery,favoriteMin,favoriteMax,sortKey,sortAscending);

@override
String toString() {
  return 'ItemFilter(categoryId: $categoryId, subCategoryId: $subCategoryId, colorGroupId: $colorGroupId, inStockOnly: $inStockOnly, nameQuery: $nameQuery, favoriteMin: $favoriteMin, favoriteMax: $favoriteMax, sortKey: $sortKey, sortAscending: $sortAscending)';
}


}

/// @nodoc
abstract mixin class $ItemFilterCopyWith<$Res>  {
  factory $ItemFilterCopyWith(ItemFilter value, $Res Function(ItemFilter) _then) = _$ItemFilterCopyWithImpl;
@useResult
$Res call({
 int? categoryId, int? subCategoryId, int? colorGroupId, bool inStockOnly, String nameQuery, int? favoriteMin, int? favoriteMax, ItemSortKey? sortKey, bool sortAscending
});




}
/// @nodoc
class _$ItemFilterCopyWithImpl<$Res>
    implements $ItemFilterCopyWith<$Res> {
  _$ItemFilterCopyWithImpl(this._self, this._then);

  final ItemFilter _self;
  final $Res Function(ItemFilter) _then;

/// Create a copy of ItemFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = freezed,Object? subCategoryId = freezed,Object? colorGroupId = freezed,Object? inStockOnly = null,Object? nameQuery = null,Object? favoriteMin = freezed,Object? favoriteMax = freezed,Object? sortKey = freezed,Object? sortAscending = null,}) {
  return _then(_self.copyWith(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,subCategoryId: freezed == subCategoryId ? _self.subCategoryId : subCategoryId // ignore: cast_nullable_to_non_nullable
as int?,colorGroupId: freezed == colorGroupId ? _self.colorGroupId : colorGroupId // ignore: cast_nullable_to_non_nullable
as int?,inStockOnly: null == inStockOnly ? _self.inStockOnly : inStockOnly // ignore: cast_nullable_to_non_nullable
as bool,nameQuery: null == nameQuery ? _self.nameQuery : nameQuery // ignore: cast_nullable_to_non_nullable
as String,favoriteMin: freezed == favoriteMin ? _self.favoriteMin : favoriteMin // ignore: cast_nullable_to_non_nullable
as int?,favoriteMax: freezed == favoriteMax ? _self.favoriteMax : favoriteMax // ignore: cast_nullable_to_non_nullable
as int?,sortKey: freezed == sortKey ? _self.sortKey : sortKey // ignore: cast_nullable_to_non_nullable
as ItemSortKey?,sortAscending: null == sortAscending ? _self.sortAscending : sortAscending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// Adds pattern-matching-related methods to [ItemFilter].
extension ItemFilterPatterns on ItemFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ItemFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ItemFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ItemFilter value)  $default,){
final _that = this;
switch (_that) {
case _ItemFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ItemFilter value)?  $default,){
final _that = this;
switch (_that) {
case _ItemFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int? categoryId,  int? subCategoryId,  int? colorGroupId,  bool inStockOnly,  String nameQuery,  int? favoriteMin,  int? favoriteMax,  ItemSortKey? sortKey,  bool sortAscending)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ItemFilter() when $default != null:
return $default(_that.categoryId,_that.subCategoryId,_that.colorGroupId,_that.inStockOnly,_that.nameQuery,_that.favoriteMin,_that.favoriteMax,_that.sortKey,_that.sortAscending);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int? categoryId,  int? subCategoryId,  int? colorGroupId,  bool inStockOnly,  String nameQuery,  int? favoriteMin,  int? favoriteMax,  ItemSortKey? sortKey,  bool sortAscending)  $default,) {final _that = this;
switch (_that) {
case _ItemFilter():
return $default(_that.categoryId,_that.subCategoryId,_that.colorGroupId,_that.inStockOnly,_that.nameQuery,_that.favoriteMin,_that.favoriteMax,_that.sortKey,_that.sortAscending);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int? categoryId,  int? subCategoryId,  int? colorGroupId,  bool inStockOnly,  String nameQuery,  int? favoriteMin,  int? favoriteMax,  ItemSortKey? sortKey,  bool sortAscending)?  $default,) {final _that = this;
switch (_that) {
case _ItemFilter() when $default != null:
return $default(_that.categoryId,_that.subCategoryId,_that.colorGroupId,_that.inStockOnly,_that.nameQuery,_that.favoriteMin,_that.favoriteMax,_that.sortKey,_that.sortAscending);case _:
  return null;

}
}

}

/// @nodoc


class _ItemFilter implements ItemFilter {
  const _ItemFilter({this.categoryId, this.subCategoryId, this.colorGroupId, this.inStockOnly = false, this.nameQuery = '', this.favoriteMin, this.favoriteMax, this.sortKey, this.sortAscending = true});
  

@override final  int? categoryId;
@override final  int? subCategoryId;
@override final  int? colorGroupId;
@override@JsonKey() final  bool inStockOnly;
@override@JsonKey() final  String nameQuery;
@override final  int? favoriteMin;
@override final  int? favoriteMax;
@override final  ItemSortKey? sortKey;
@override@JsonKey() final  bool sortAscending;

/// Create a copy of ItemFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemFilterCopyWith<_ItemFilter> get copyWith => __$ItemFilterCopyWithImpl<_ItemFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ItemFilter&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.subCategoryId, subCategoryId) || other.subCategoryId == subCategoryId)&&(identical(other.colorGroupId, colorGroupId) || other.colorGroupId == colorGroupId)&&(identical(other.inStockOnly, inStockOnly) || other.inStockOnly == inStockOnly)&&(identical(other.nameQuery, nameQuery) || other.nameQuery == nameQuery)&&(identical(other.favoriteMin, favoriteMin) || other.favoriteMin == favoriteMin)&&(identical(other.favoriteMax, favoriteMax) || other.favoriteMax == favoriteMax)&&(identical(other.sortKey, sortKey) || other.sortKey == sortKey)&&(identical(other.sortAscending, sortAscending) || other.sortAscending == sortAscending));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,subCategoryId,colorGroupId,inStockOnly,nameQuery,favoriteMin,favoriteMax,sortKey,sortAscending);

@override
String toString() {
  return 'ItemFilter(categoryId: $categoryId, subCategoryId: $subCategoryId, colorGroupId: $colorGroupId, inStockOnly: $inStockOnly, nameQuery: $nameQuery, favoriteMin: $favoriteMin, favoriteMax: $favoriteMax, sortKey: $sortKey, sortAscending: $sortAscending)';
}


}

/// @nodoc
abstract mixin class _$ItemFilterCopyWith<$Res> implements $ItemFilterCopyWith<$Res> {
  factory _$ItemFilterCopyWith(_ItemFilter value, $Res Function(_ItemFilter) _then) = __$ItemFilterCopyWithImpl;
@override @useResult
$Res call({
 int? categoryId, int? subCategoryId, int? colorGroupId, bool inStockOnly, String nameQuery, int? favoriteMin, int? favoriteMax, ItemSortKey? sortKey, bool sortAscending
});




}
/// @nodoc
class __$ItemFilterCopyWithImpl<$Res>
    implements _$ItemFilterCopyWith<$Res> {
  __$ItemFilterCopyWithImpl(this._self, this._then);

  final _ItemFilter _self;
  final $Res Function(_ItemFilter) _then;

/// Create a copy of ItemFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = freezed,Object? subCategoryId = freezed,Object? colorGroupId = freezed,Object? inStockOnly = null,Object? nameQuery = null,Object? favoriteMin = freezed,Object? favoriteMax = freezed,Object? sortKey = freezed,Object? sortAscending = null,}) {
  return _then(_ItemFilter(
categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,subCategoryId: freezed == subCategoryId ? _self.subCategoryId : subCategoryId // ignore: cast_nullable_to_non_nullable
as int?,colorGroupId: freezed == colorGroupId ? _self.colorGroupId : colorGroupId // ignore: cast_nullable_to_non_nullable
as int?,inStockOnly: null == inStockOnly ? _self.inStockOnly : inStockOnly // ignore: cast_nullable_to_non_nullable
as bool,nameQuery: null == nameQuery ? _self.nameQuery : nameQuery // ignore: cast_nullable_to_non_nullable
as String,favoriteMin: freezed == favoriteMin ? _self.favoriteMin : favoriteMin // ignore: cast_nullable_to_non_nullable
as int?,favoriteMax: freezed == favoriteMax ? _self.favoriteMax : favoriteMax // ignore: cast_nullable_to_non_nullable
as int?,sortKey: freezed == sortKey ? _self.sortKey : sortKey // ignore: cast_nullable_to_non_nullable
as ItemSortKey?,sortAscending: null == sortAscending ? _self.sortAscending : sortAscending // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
