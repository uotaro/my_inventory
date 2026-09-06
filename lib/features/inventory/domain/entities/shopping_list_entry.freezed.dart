// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shopping_list_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ShoppingListEntry {

 int get id; Item get item; double get purchaseQuantity; DateTime get createdAt;
/// Create a copy of ShoppingListEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ShoppingListEntryCopyWith<ShoppingListEntry> get copyWith => _$ShoppingListEntryCopyWithImpl<ShoppingListEntry>(this as ShoppingListEntry, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ShoppingListEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.item, item) || other.item == item)&&(identical(other.purchaseQuantity, purchaseQuantity) || other.purchaseQuantity == purchaseQuantity)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,item,purchaseQuantity,createdAt);

@override
String toString() {
  return 'ShoppingListEntry(id: $id, item: $item, purchaseQuantity: $purchaseQuantity, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $ShoppingListEntryCopyWith<$Res>  {
  factory $ShoppingListEntryCopyWith(ShoppingListEntry value, $Res Function(ShoppingListEntry) _then) = _$ShoppingListEntryCopyWithImpl;
@useResult
$Res call({
 int id, Item item, double purchaseQuantity, DateTime createdAt
});


$ItemCopyWith<$Res> get item;

}
/// @nodoc
class _$ShoppingListEntryCopyWithImpl<$Res>
    implements $ShoppingListEntryCopyWith<$Res> {
  _$ShoppingListEntryCopyWithImpl(this._self, this._then);

  final ShoppingListEntry _self;
  final $Res Function(ShoppingListEntry) _then;

/// Create a copy of ShoppingListEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? item = null,Object? purchaseQuantity = null,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as Item,purchaseQuantity: null == purchaseQuantity ? _self.purchaseQuantity : purchaseQuantity // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}
/// Create a copy of ShoppingListEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res> get item {
  
  return $ItemCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}


/// Adds pattern-matching-related methods to [ShoppingListEntry].
extension ShoppingListEntryPatterns on ShoppingListEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ShoppingListEntry value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ShoppingListEntry() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ShoppingListEntry value)  $default,){
final _that = this;
switch (_that) {
case _ShoppingListEntry():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ShoppingListEntry value)?  $default,){
final _that = this;
switch (_that) {
case _ShoppingListEntry() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  Item item,  double purchaseQuantity,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ShoppingListEntry() when $default != null:
return $default(_that.id,_that.item,_that.purchaseQuantity,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  Item item,  double purchaseQuantity,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _ShoppingListEntry():
return $default(_that.id,_that.item,_that.purchaseQuantity,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  Item item,  double purchaseQuantity,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _ShoppingListEntry() when $default != null:
return $default(_that.id,_that.item,_that.purchaseQuantity,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _ShoppingListEntry implements ShoppingListEntry {
  const _ShoppingListEntry({required this.id, required this.item, required this.purchaseQuantity, required this.createdAt});
  

@override final  int id;
@override final  Item item;
@override final  double purchaseQuantity;
@override final  DateTime createdAt;

/// Create a copy of ShoppingListEntry
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ShoppingListEntryCopyWith<_ShoppingListEntry> get copyWith => __$ShoppingListEntryCopyWithImpl<_ShoppingListEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ShoppingListEntry&&(identical(other.id, id) || other.id == id)&&(identical(other.item, item) || other.item == item)&&(identical(other.purchaseQuantity, purchaseQuantity) || other.purchaseQuantity == purchaseQuantity)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,item,purchaseQuantity,createdAt);

@override
String toString() {
  return 'ShoppingListEntry(id: $id, item: $item, purchaseQuantity: $purchaseQuantity, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$ShoppingListEntryCopyWith<$Res> implements $ShoppingListEntryCopyWith<$Res> {
  factory _$ShoppingListEntryCopyWith(_ShoppingListEntry value, $Res Function(_ShoppingListEntry) _then) = __$ShoppingListEntryCopyWithImpl;
@override @useResult
$Res call({
 int id, Item item, double purchaseQuantity, DateTime createdAt
});


@override $ItemCopyWith<$Res> get item;

}
/// @nodoc
class __$ShoppingListEntryCopyWithImpl<$Res>
    implements _$ShoppingListEntryCopyWith<$Res> {
  __$ShoppingListEntryCopyWithImpl(this._self, this._then);

  final _ShoppingListEntry _self;
  final $Res Function(_ShoppingListEntry) _then;

/// Create a copy of ShoppingListEntry
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? item = null,Object? purchaseQuantity = null,Object? createdAt = null,}) {
  return _then(_ShoppingListEntry(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,item: null == item ? _self.item : item // ignore: cast_nullable_to_non_nullable
as Item,purchaseQuantity: null == purchaseQuantity ? _self.purchaseQuantity : purchaseQuantity // ignore: cast_nullable_to_non_nullable
as double,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

/// Create a copy of ShoppingListEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ItemCopyWith<$Res> get item {
  
  return $ItemCopyWith<$Res>(_self.item, (value) {
    return _then(_self.copyWith(item: value));
  });
}
}

// dart format on
