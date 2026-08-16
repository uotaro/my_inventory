// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'color_option.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ColorOption {

 int get id; int get colorGroupId; String get name; String? get hexCode; int get sortOrder;
/// Create a copy of ColorOption
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ColorOptionCopyWith<ColorOption> get copyWith => _$ColorOptionCopyWithImpl<ColorOption>(this as ColorOption, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ColorOption&&(identical(other.id, id) || other.id == id)&&(identical(other.colorGroupId, colorGroupId) || other.colorGroupId == colorGroupId)&&(identical(other.name, name) || other.name == name)&&(identical(other.hexCode, hexCode) || other.hexCode == hexCode)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,id,colorGroupId,name,hexCode,sortOrder);

@override
String toString() {
  return 'ColorOption(id: $id, colorGroupId: $colorGroupId, name: $name, hexCode: $hexCode, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class $ColorOptionCopyWith<$Res>  {
  factory $ColorOptionCopyWith(ColorOption value, $Res Function(ColorOption) _then) = _$ColorOptionCopyWithImpl;
@useResult
$Res call({
 int id, int colorGroupId, String name, String? hexCode, int sortOrder
});




}
/// @nodoc
class _$ColorOptionCopyWithImpl<$Res>
    implements $ColorOptionCopyWith<$Res> {
  _$ColorOptionCopyWithImpl(this._self, this._then);

  final ColorOption _self;
  final $Res Function(ColorOption) _then;

/// Create a copy of ColorOption
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? colorGroupId = null,Object? name = null,Object? hexCode = freezed,Object? sortOrder = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,colorGroupId: null == colorGroupId ? _self.colorGroupId : colorGroupId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hexCode: freezed == hexCode ? _self.hexCode : hexCode // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [ColorOption].
extension ColorOptionPatterns on ColorOption {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ColorOption value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ColorOption() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ColorOption value)  $default,){
final _that = this;
switch (_that) {
case _ColorOption():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ColorOption value)?  $default,){
final _that = this;
switch (_that) {
case _ColorOption() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  int colorGroupId,  String name,  String? hexCode,  int sortOrder)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ColorOption() when $default != null:
return $default(_that.id,_that.colorGroupId,_that.name,_that.hexCode,_that.sortOrder);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  int colorGroupId,  String name,  String? hexCode,  int sortOrder)  $default,) {final _that = this;
switch (_that) {
case _ColorOption():
return $default(_that.id,_that.colorGroupId,_that.name,_that.hexCode,_that.sortOrder);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  int colorGroupId,  String name,  String? hexCode,  int sortOrder)?  $default,) {final _that = this;
switch (_that) {
case _ColorOption() when $default != null:
return $default(_that.id,_that.colorGroupId,_that.name,_that.hexCode,_that.sortOrder);case _:
  return null;

}
}

}

/// @nodoc


class _ColorOption implements ColorOption {
  const _ColorOption({required this.id, required this.colorGroupId, required this.name, this.hexCode, required this.sortOrder});
  

@override final  int id;
@override final  int colorGroupId;
@override final  String name;
@override final  String? hexCode;
@override final  int sortOrder;

/// Create a copy of ColorOption
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ColorOptionCopyWith<_ColorOption> get copyWith => __$ColorOptionCopyWithImpl<_ColorOption>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ColorOption&&(identical(other.id, id) || other.id == id)&&(identical(other.colorGroupId, colorGroupId) || other.colorGroupId == colorGroupId)&&(identical(other.name, name) || other.name == name)&&(identical(other.hexCode, hexCode) || other.hexCode == hexCode)&&(identical(other.sortOrder, sortOrder) || other.sortOrder == sortOrder));
}


@override
int get hashCode => Object.hash(runtimeType,id,colorGroupId,name,hexCode,sortOrder);

@override
String toString() {
  return 'ColorOption(id: $id, colorGroupId: $colorGroupId, name: $name, hexCode: $hexCode, sortOrder: $sortOrder)';
}


}

/// @nodoc
abstract mixin class _$ColorOptionCopyWith<$Res> implements $ColorOptionCopyWith<$Res> {
  factory _$ColorOptionCopyWith(_ColorOption value, $Res Function(_ColorOption) _then) = __$ColorOptionCopyWithImpl;
@override @useResult
$Res call({
 int id, int colorGroupId, String name, String? hexCode, int sortOrder
});




}
/// @nodoc
class __$ColorOptionCopyWithImpl<$Res>
    implements _$ColorOptionCopyWith<$Res> {
  __$ColorOptionCopyWithImpl(this._self, this._then);

  final _ColorOption _self;
  final $Res Function(_ColorOption) _then;

/// Create a copy of ColorOption
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? colorGroupId = null,Object? name = null,Object? hexCode = freezed,Object? sortOrder = null,}) {
  return _then(_ColorOption(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,colorGroupId: null == colorGroupId ? _self.colorGroupId : colorGroupId // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,hexCode: freezed == hexCode ? _self.hexCode : hexCode // ignore: cast_nullable_to_non_nullable
as String?,sortOrder: null == sortOrder ? _self.sortOrder : sortOrder // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
