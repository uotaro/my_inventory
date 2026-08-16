import 'package:freezed_annotation/freezed_annotation.dart';

import 'category.dart';
import 'color_option.dart';
import 'sub_category.dart';
import 'unit.dart';

part 'item.freezed.dart';

@freezed
abstract class Item with _$Item {
  const factory Item({
    required int id,
    required Category category,
    SubCategory? subCategory,
    ColorOption? color,
    required Unit unit,
    String? barcode,
    required String name,
    @Default(0) int favoriteRating,
    required double quantity,
    double? lowStockThreshold,
    String? imagePath,
    String? memo,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Item;
}
