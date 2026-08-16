import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';

@freezed
abstract class Category with _$Category {
  const factory Category({
    required int id,
    required int inventoryTypeId,
    required String name,
    required int sortOrder,
  }) = _Category;
}
