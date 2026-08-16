// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Item {

 int get id; Category get category; SubCategory? get subCategory; ColorOption? get color; Unit get unit; String? get barcode; String get name; int get favoriteRating; double get quantity; double? get lowStockThreshold; String? get imagePath; String? get memo; DateTime get createdAt; DateTime get updatedAt;
/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ItemCopyWith<Item> get copyWith => _$ItemCopyWithImpl<Item>(this as Item, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Item&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.subCategory, subCategory) || other.subCategory == subCategory)&&(identical(other.color, color) || other.color == color)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.name, name) || other.name == name)&&(identical(other.favoriteRating, favoriteRating) || other.favoriteRating == favoriteRating)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lowStockThreshold, lowStockThreshold) || other.lowStockThreshold == lowStockThreshold)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.memo, memo) || other.memo == memo)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,category,subCategory,color,unit,barcode,name,favoriteRating,quantity,lowStockThreshold,imagePath,memo,createdAt,updatedAt);

@override
String toString() {
  return 'Item(id: $id, category: $category, subCategory: $subCategory, color: $color, unit: $unit, barcode: $barcode, name: $name, favoriteRating: $favoriteRating, quantity: $quantity, lowStockThreshold: $lowStockThreshold, imagePath: $imagePath, memo: $memo, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class $ItemCopyWith<$Res>  {
  factory $ItemCopyWith(Item value, $Res Function(Item) _then) = _$ItemCopyWithImpl;
@useResult
$Res call({
 int id, Category category, SubCategory? subCategory, ColorOption? color, Unit unit, String? barcode, String name, int favoriteRating, double quantity, double? lowStockThreshold, String? imagePath, String? memo, DateTime createdAt, DateTime updatedAt
});


$CategoryCopyWith<$Res> get category;$SubCategoryCopyWith<$Res>? get subCategory;$ColorOptionCopyWith<$Res>? get color;$UnitCopyWith<$Res> get unit;

}
/// @nodoc
class _$ItemCopyWithImpl<$Res>
    implements $ItemCopyWith<$Res> {
  _$ItemCopyWithImpl(this._self, this._then);

  final Item _self;
  final $Res Function(Item) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? category = null,Object? subCategory = freezed,Object? color = freezed,Object? unit = null,Object? barcode = freezed,Object? name = null,Object? favoriteRating = null,Object? quantity = null,Object? lowStockThreshold = freezed,Object? imagePath = freezed,Object? memo = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,subCategory: freezed == subCategory ? _self.subCategory : subCategory // ignore: cast_nullable_to_non_nullable
as SubCategory?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as ColorOption?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as Unit,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,favoriteRating: null == favoriteRating ? _self.favoriteRating : favoriteRating // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,lowStockThreshold: freezed == lowStockThreshold ? _self.lowStockThreshold : lowStockThreshold // ignore: cast_nullable_to_non_nullable
as double?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,memo: freezed == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res> get category {
  
  return $CategoryCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubCategoryCopyWith<$Res>? get subCategory {
    if (_self.subCategory == null) {
    return null;
  }

  return $SubCategoryCopyWith<$Res>(_self.subCategory!, (value) {
    return _then(_self.copyWith(subCategory: value));
  });
}/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ColorOptionCopyWith<$Res>? get color {
    if (_self.color == null) {
    return null;
  }

  return $ColorOptionCopyWith<$Res>(_self.color!, (value) {
    return _then(_self.copyWith(color: value));
  });
}/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnitCopyWith<$Res> get unit {
  
  return $UnitCopyWith<$Res>(_self.unit, (value) {
    return _then(_self.copyWith(unit: value));
  });
}
}


/// Adds pattern-matching-related methods to [Item].
extension ItemPatterns on Item {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Item value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Item() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Item value)  $default,){
final _that = this;
switch (_that) {
case _Item():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Item value)?  $default,){
final _that = this;
switch (_that) {
case _Item() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  Category category,  SubCategory? subCategory,  ColorOption? color,  Unit unit,  String? barcode,  String name,  int favoriteRating,  double quantity,  double? lowStockThreshold,  String? imagePath,  String? memo,  DateTime createdAt,  DateTime updatedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Item() when $default != null:
return $default(_that.id,_that.category,_that.subCategory,_that.color,_that.unit,_that.barcode,_that.name,_that.favoriteRating,_that.quantity,_that.lowStockThreshold,_that.imagePath,_that.memo,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  Category category,  SubCategory? subCategory,  ColorOption? color,  Unit unit,  String? barcode,  String name,  int favoriteRating,  double quantity,  double? lowStockThreshold,  String? imagePath,  String? memo,  DateTime createdAt,  DateTime updatedAt)  $default,) {final _that = this;
switch (_that) {
case _Item():
return $default(_that.id,_that.category,_that.subCategory,_that.color,_that.unit,_that.barcode,_that.name,_that.favoriteRating,_that.quantity,_that.lowStockThreshold,_that.imagePath,_that.memo,_that.createdAt,_that.updatedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  Category category,  SubCategory? subCategory,  ColorOption? color,  Unit unit,  String? barcode,  String name,  int favoriteRating,  double quantity,  double? lowStockThreshold,  String? imagePath,  String? memo,  DateTime createdAt,  DateTime updatedAt)?  $default,) {final _that = this;
switch (_that) {
case _Item() when $default != null:
return $default(_that.id,_that.category,_that.subCategory,_that.color,_that.unit,_that.barcode,_that.name,_that.favoriteRating,_that.quantity,_that.lowStockThreshold,_that.imagePath,_that.memo,_that.createdAt,_that.updatedAt);case _:
  return null;

}
}

}

/// @nodoc


class _Item implements Item {
  const _Item({required this.id, required this.category, this.subCategory, this.color, required this.unit, this.barcode, required this.name, this.favoriteRating = 0, required this.quantity, this.lowStockThreshold, this.imagePath, this.memo, required this.createdAt, required this.updatedAt});
  

@override final  int id;
@override final  Category category;
@override final  SubCategory? subCategory;
@override final  ColorOption? color;
@override final  Unit unit;
@override final  String? barcode;
@override final  String name;
@override@JsonKey() final  int favoriteRating;
@override final  double quantity;
@override final  double? lowStockThreshold;
@override final  String? imagePath;
@override final  String? memo;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ItemCopyWith<_Item> get copyWith => __$ItemCopyWithImpl<_Item>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Item&&(identical(other.id, id) || other.id == id)&&(identical(other.category, category) || other.category == category)&&(identical(other.subCategory, subCategory) || other.subCategory == subCategory)&&(identical(other.color, color) || other.color == color)&&(identical(other.unit, unit) || other.unit == unit)&&(identical(other.barcode, barcode) || other.barcode == barcode)&&(identical(other.name, name) || other.name == name)&&(identical(other.favoriteRating, favoriteRating) || other.favoriteRating == favoriteRating)&&(identical(other.quantity, quantity) || other.quantity == quantity)&&(identical(other.lowStockThreshold, lowStockThreshold) || other.lowStockThreshold == lowStockThreshold)&&(identical(other.imagePath, imagePath) || other.imagePath == imagePath)&&(identical(other.memo, memo) || other.memo == memo)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,category,subCategory,color,unit,barcode,name,favoriteRating,quantity,lowStockThreshold,imagePath,memo,createdAt,updatedAt);

@override
String toString() {
  return 'Item(id: $id, category: $category, subCategory: $subCategory, color: $color, unit: $unit, barcode: $barcode, name: $name, favoriteRating: $favoriteRating, quantity: $quantity, lowStockThreshold: $lowStockThreshold, imagePath: $imagePath, memo: $memo, createdAt: $createdAt, updatedAt: $updatedAt)';
}


}

/// @nodoc
abstract mixin class _$ItemCopyWith<$Res> implements $ItemCopyWith<$Res> {
  factory _$ItemCopyWith(_Item value, $Res Function(_Item) _then) = __$ItemCopyWithImpl;
@override @useResult
$Res call({
 int id, Category category, SubCategory? subCategory, ColorOption? color, Unit unit, String? barcode, String name, int favoriteRating, double quantity, double? lowStockThreshold, String? imagePath, String? memo, DateTime createdAt, DateTime updatedAt
});


@override $CategoryCopyWith<$Res> get category;@override $SubCategoryCopyWith<$Res>? get subCategory;@override $ColorOptionCopyWith<$Res>? get color;@override $UnitCopyWith<$Res> get unit;

}
/// @nodoc
class __$ItemCopyWithImpl<$Res>
    implements _$ItemCopyWith<$Res> {
  __$ItemCopyWithImpl(this._self, this._then);

  final _Item _self;
  final $Res Function(_Item) _then;

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? category = null,Object? subCategory = freezed,Object? color = freezed,Object? unit = null,Object? barcode = freezed,Object? name = null,Object? favoriteRating = null,Object? quantity = null,Object? lowStockThreshold = freezed,Object? imagePath = freezed,Object? memo = freezed,Object? createdAt = null,Object? updatedAt = null,}) {
  return _then(_Item(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,subCategory: freezed == subCategory ? _self.subCategory : subCategory // ignore: cast_nullable_to_non_nullable
as SubCategory?,color: freezed == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as ColorOption?,unit: null == unit ? _self.unit : unit // ignore: cast_nullable_to_non_nullable
as Unit,barcode: freezed == barcode ? _self.barcode : barcode // ignore: cast_nullable_to_non_nullable
as String?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,favoriteRating: null == favoriteRating ? _self.favoriteRating : favoriteRating // ignore: cast_nullable_to_non_nullable
as int,quantity: null == quantity ? _self.quantity : quantity // ignore: cast_nullable_to_non_nullable
as double,lowStockThreshold: freezed == lowStockThreshold ? _self.lowStockThreshold : lowStockThreshold // ignore: cast_nullable_to_non_nullable
as double?,imagePath: freezed == imagePath ? _self.imagePath : imagePath // ignore: cast_nullable_to_non_nullable
as String?,memo: freezed == memo ? _self.memo : memo // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res> get category {
  
  return $CategoryCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$SubCategoryCopyWith<$Res>? get subCategory {
    if (_self.subCategory == null) {
    return null;
  }

  return $SubCategoryCopyWith<$Res>(_self.subCategory!, (value) {
    return _then(_self.copyWith(subCategory: value));
  });
}/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ColorOptionCopyWith<$Res>? get color {
    if (_self.color == null) {
    return null;
  }

  return $ColorOptionCopyWith<$Res>(_self.color!, (value) {
    return _then(_self.copyWith(color: value));
  });
}/// Create a copy of Item
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$UnitCopyWith<$Res> get unit {
  
  return $UnitCopyWith<$Res>(_self.unit, (value) {
    return _then(_self.copyWith(unit: value));
  });
}
}

// dart format on
