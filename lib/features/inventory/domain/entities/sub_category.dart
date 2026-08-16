import 'package:freezed_annotation/freezed_annotation.dart';

part 'sub_category.freezed.dart';

@freezed
abstract class SubCategory with _$SubCategory {
  const factory SubCategory({
    required int id,
    required int categoryId,
    required String name,
    required int sortOrder,
  }) = _SubCategory;
}
