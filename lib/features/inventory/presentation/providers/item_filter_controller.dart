import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'item_filter_controller.freezed.dart';
part 'item_filter_controller.g.dart';

enum ItemSortKey { name, quantity, favorite, category }

@freezed
abstract class ItemFilter with _$ItemFilter {
  const factory ItemFilter({
    int? categoryId,
    int? subCategoryId,
    int? colorGroupId,
    @Default(false) bool inStockOnly,
    @Default('') String nameQuery,
    int? favoriteMin,
    int? favoriteMax,
    ItemSortKey? sortKey,
    @Default(true) bool sortAscending,
  }) = _ItemFilter;
}

@riverpod
class ItemFilterController extends _$ItemFilterController {
  @override
  ItemFilter build() => const ItemFilter();

  /// カテゴリーを切り替えたら、別カテゴリーのサブカテゴリーが
  /// 選択されたままにならないようリセットする。
  void setCategory(int? categoryId) {
    state = state.copyWith(categoryId: categoryId, subCategoryId: null);
  }

  void setSubCategory(int? subCategoryId) {
    state = state.copyWith(subCategoryId: subCategoryId);
  }

  void setColorGroup(int? colorGroupId) {
    state = state.copyWith(colorGroupId: colorGroupId);
  }

  void setInStockOnly(bool value) {
    state = state.copyWith(inStockOnly: value);
  }

  void setNameQuery(String value) {
    state = state.copyWith(nameQuery: value);
  }

  void setFavoriteRange(int? min, int? max) {
    state = state.copyWith(favoriteMin: min, favoriteMax: max);
  }

  void setSort(ItemSortKey key, {required bool ascending}) {
    state = state.copyWith(sortKey: key, sortAscending: ascending);
  }

  void clearSort() {
    state = state.copyWith(sortKey: null, sortAscending: true);
  }

  void clear() {
    state = const ItemFilter();
  }
}
