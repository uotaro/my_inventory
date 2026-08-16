import 'package:freezed_annotation/freezed_annotation.dart';

part 'inventory_type.freezed.dart';

@freezed
abstract class InventoryType with _$InventoryType {
  const factory InventoryType({
    required int id,
    required String name,
    required int sortOrder,
  }) = _InventoryType;
}
