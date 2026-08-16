// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'stock_log.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StockLog {

 int get id; int get itemId; double get changeAmount; String? get reason; DateTime get createdAt;
/// Create a copy of StockLog
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StockLogCopyWith<StockLog> get copyWith => _$StockLogCopyWithImpl<StockLog>(this as StockLog, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StockLog&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.changeAmount, changeAmount) || other.changeAmount == changeAmount)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,itemId,changeAmount,reason,createdAt);

@override
String toString() {
  return 'StockLog(id: $id, itemId: $itemId, changeAmount: $changeAmount, reason: $reason, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class $StockLogCopyWith<$Res>  {
  factory $StockLogCopyWith(StockLog value, $Res Function(StockLog) _then) = _$StockLogCopyWithImpl;
@useResult
$Res call({
 int id, int itemId, double changeAmount, String? reason, DateTime createdAt
});




}
/// @nodoc
class _$StockLogCopyWithImpl<$Res>
    implements $StockLogCopyWith<$Res> {
  _$StockLogCopyWithImpl(this._self, this._then);

  final StockLog _self;
  final $Res Function(StockLog) _then;

/// Create a copy of StockLog
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? itemId = null,Object? changeAmount = null,Object? reason = freezed,Object? createdAt = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int,changeAmount: null == changeAmount ? _self.changeAmount : changeAmount // ignore: cast_nullable_to_non_nullable
as double,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}

}


/// Adds pattern-matching-related methods to [StockLog].
extension StockLogPatterns on StockLog {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _StockLog value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _StockLog() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _StockLog value)  $default,){
final _that = this;
switch (_that) {
case _StockLog():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _StockLog value)?  $default,){
final _that = this;
switch (_that) {
case _StockLog() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int itemId,  double changeAmount,  String? reason,  DateTime createdAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _StockLog() when $default != null:
return $default(_that.id,_that.itemId,_that.changeAmount,_that.reason,_that.createdAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int itemId,  double changeAmount,  String? reason,  DateTime createdAt)  $default,) {final _that = this;
switch (_that) {
case _StockLog():
return $default(_that.id,_that.itemId,_that.changeAmount,_that.reason,_that.createdAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int itemId,  double changeAmount,  String? reason,  DateTime createdAt)?  $default,) {final _that = this;
switch (_that) {
case _StockLog() when $default != null:
return $default(_that.id,_that.itemId,_that.changeAmount,_that.reason,_that.createdAt);case _:
  return null;

}
}

}

/// @nodoc


class _StockLog implements StockLog {
  const _StockLog({required this.id, required this.itemId, required this.changeAmount, this.reason, required this.createdAt});
  

@override final  int id;
@override final  int itemId;
@override final  double changeAmount;
@override final  String? reason;
@override final  DateTime createdAt;

/// Create a copy of StockLog
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StockLogCopyWith<_StockLog> get copyWith => __$StockLogCopyWithImpl<_StockLog>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StockLog&&(identical(other.id, id) || other.id == id)&&(identical(other.itemId, itemId) || other.itemId == itemId)&&(identical(other.changeAmount, changeAmount) || other.changeAmount == changeAmount)&&(identical(other.reason, reason) || other.reason == reason)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt));
}


@override
int get hashCode => Object.hash(runtimeType,id,itemId,changeAmount,reason,createdAt);

@override
String toString() {
  return 'StockLog(id: $id, itemId: $itemId, changeAmount: $changeAmount, reason: $reason, createdAt: $createdAt)';
}


}

/// @nodoc
abstract mixin class _$StockLogCopyWith<$Res> implements $StockLogCopyWith<$Res> {
  factory _$StockLogCopyWith(_StockLog value, $Res Function(_StockLog) _then) = __$StockLogCopyWithImpl;
@override @useResult
$Res call({
 int id, int itemId, double changeAmount, String? reason, DateTime createdAt
});




}
/// @nodoc
class __$StockLogCopyWithImpl<$Res>
    implements _$StockLogCopyWith<$Res> {
  __$StockLogCopyWithImpl(this._self, this._then);

  final _StockLog _self;
  final $Res Function(_StockLog) _then;

/// Create a copy of StockLog
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? itemId = null,Object? changeAmount = null,Object? reason = freezed,Object? createdAt = null,}) {
  return _then(_StockLog(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,itemId: null == itemId ? _self.itemId : itemId // ignore: cast_nullable_to_non_nullable
as int,changeAmount: null == changeAmount ? _self.changeAmount : changeAmount // ignore: cast_nullable_to_non_nullable
as double,reason: freezed == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as String?,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,
  ));
}


}

// dart format on
