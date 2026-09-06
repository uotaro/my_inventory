import 'package:freezed_annotation/freezed_annotation.dart';

import 'item.dart';

part 'shopping_list_entry.freezed.dart';

@freezed
abstract class ShoppingListEntry with _$ShoppingListEntry {
  const factory ShoppingListEntry({
    required int id,
    required Item item,
    required double purchaseQuantity,
    required DateTime createdAt,
  }) = _ShoppingListEntry;
}
