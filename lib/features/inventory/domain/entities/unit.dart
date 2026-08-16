import 'package:freezed_annotation/freezed_annotation.dart';

part 'unit.freezed.dart';

@freezed
abstract class Unit with _$Unit {
  const factory Unit({
    required int id,
    required String name,
    required int sortOrder,
  }) = _Unit;
}
