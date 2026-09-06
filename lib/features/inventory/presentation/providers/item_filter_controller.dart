import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'item_filter_controller.freezed.dart';
part 'item_filter_controller.g.dart';

enum ItemSortKey { name, quantity, favorite, category }

/// 在庫数による絞り込み。[lowStock] / [inStock] の判定基準は
/// アイテムの「在庫不足の目安」（未設定の場合は0とみなす）との比較による。
enum StockFilter { all, inStock, lowStock, zero }

/// 並べ替え設定を次回起動時にも引き継ぐためのSharedPreferencesキー。
const _sortKeyPrefKey = 'item_filter.sort_key';
const _sortAscendingPrefKey = 'item_filter.sort_ascending';

@freezed
abstract class ItemFilter with _$ItemFilter {
  const factory ItemFilter({
    int? inventoryTypeId,
    int? categoryId,
    int? subCategoryId,
    int? colorGroupId,
    @Default(StockFilter.all) StockFilter stockFilter,
    @Default('') String nameQuery,
    int? favoriteMin,
    int? favoriteMax,
    // デフォルト（未指定時）の実際の表示順は品名の昇順のため、
    // 並べ替え設定の初期値・リセット後の値もそれに揃える。
    @Default(ItemSortKey.name) ItemSortKey sortKey,
    @Default(true) bool sortAscending,
  }) = _ItemFilter;
}

@riverpod
class ItemFilterController extends _$ItemFilterController {
  @override
  ItemFilter build() {
    _loadPersistedSort();
    return const ItemFilter();
  }

  /// 前回起動時に保存された並べ替え設定を読み込んで反映する。
  /// 未保存（初回起動）の場合はデフォルト（品名の昇順）のままにする。
  Future<void> _loadPersistedSort() async {
    final prefs = await SharedPreferences.getInstance();
    final storedKeyName = prefs.getString(_sortKeyPrefKey);
    if (storedKeyName == null) return;

    final storedKey = ItemSortKey.values.asNameMap()[storedKeyName];
    if (storedKey == null) return;

    state = state.copyWith(
      sortKey: storedKey,
      sortAscending: prefs.getBool(_sortAscendingPrefKey) ?? true,
    );
  }

  Future<void> _persistSort(ItemSortKey key, bool ascending) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_sortKeyPrefKey, key.name);
    await prefs.setBool(_sortAscendingPrefKey, ascending);
  }

  /// 種別を切り替えたら、別種別のカテゴリー・サブカテゴリーが
  /// 選択されたままにならないようリセットする。
  void setInventoryType(int? inventoryTypeId) {
    state = state.copyWith(
      inventoryTypeId: inventoryTypeId,
      categoryId: null,
      subCategoryId: null,
    );
  }

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

  void setStockFilter(StockFilter value) {
    state = state.copyWith(stockFilter: value);
  }

  void setNameQuery(String value) {
    state = state.copyWith(nameQuery: value);
  }

  void setFavoriteRange(int? min, int? max) {
    state = state.copyWith(favoriteMin: min, favoriteMax: max);
  }

  void setSort(ItemSortKey key, {required bool ascending}) {
    state = state.copyWith(sortKey: key, sortAscending: ascending);
    _persistSort(key, ascending);
  }

  /// 並べ替え設定をデフォルト（品名の昇順）に戻す。
  void clearSort() {
    setSort(ItemSortKey.name, ascending: true);
  }

  void clear() {
    state = const ItemFilter();
  }

  /// 検索条件（品名・大中小分類・色系統・お気に入り・在庫）のみをリセットする。
  /// 並び順の指定は維持する。
  void resetSearchConditions() {
    state = state.copyWith(
      inventoryTypeId: null,
      categoryId: null,
      subCategoryId: null,
      colorGroupId: null,
      stockFilter: StockFilter.all,
      nameQuery: '',
      favoriteMin: null,
      favoriteMax: null,
    );
  }
}
