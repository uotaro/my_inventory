import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/natural_compare.dart';
import '../../data/repositories/item_repository_impl.dart';
import '../../domain/entities/item.dart';
import 'item_filter_controller.dart';

part 'filtered_items_provider.g.dart';

@riverpod
Stream<List<Item>> filteredItems(Ref ref) {
  final filter = ref.watch(itemFilterControllerProvider);
  final itemsStream = ref
      .watch(itemRepositoryProvider)
      .watchItems(
        inventoryTypeId: filter.inventoryTypeId,
        categoryId: filter.categoryId,
        subCategoryId: filter.subCategoryId,
        colorGroupId: filter.colorGroupId,
      );

  final nameQuery = filter.nameQuery.trim().toLowerCase();
  final favoriteMin = filter.favoriteMin;
  final favoriteMax = filter.favoriteMax;
  final stockFilter = filter.stockFilter;
  final sortKey = filter.sortKey;

  return itemsStream.map((items) {
    Iterable<Item> result = items;
    if (nameQuery.isNotEmpty ||
        favoriteMin != null ||
        favoriteMax != null ||
        stockFilter != StockFilter.all) {
      result = result.where((item) {
        final matchesName =
            nameQuery.isEmpty || item.name.toLowerCase().contains(nameQuery);
        final matchesFavorite =
            (favoriteMin == null || item.favoriteRating >= favoriteMin) &&
            (favoriteMax == null || item.favoriteRating <= favoriteMax);
        final matchesStock = switch (stockFilter) {
          StockFilter.all => true,
          StockFilter.inStock => item.quantity > item.lowStockThreshold,
          StockFilter.lowStock => item.quantity <= item.lowStockThreshold,
          StockFilter.zero => item.quantity == 0,
        };
        return matchesName && matchesFavorite && matchesStock;
      });
    }

    final sorted = result.toList()..sort(_comparatorFor(sortKey));
    return filter.sortAscending ? sorted : sorted.reversed.toList();
  });
}

int Function(Item, Item) _comparatorFor(ItemSortKey key) {
  switch (key) {
    case ItemSortKey.name:
      return (a, b) => naturalCompare(a.name, b.name);
    case ItemSortKey.quantity:
      return (a, b) => a.quantity.compareTo(b.quantity);
    case ItemSortKey.favorite:
      return (a, b) => a.favoriteRating.compareTo(b.favoriteRating);
    case ItemSortKey.category:
      // 大分類→中分類→小分類の順に階層的に並べ替える
      // （小分類が未設定のアイテムは、同じ中分類内で先頭にまとめる）。
      return (a, b) {
        final byInventoryType = naturalCompare(
          a.inventoryType.name,
          b.inventoryType.name,
        );
        if (byInventoryType != 0) return byInventoryType;

        final byCategory = naturalCompare(a.category.name, b.category.name);
        if (byCategory != 0) return byCategory;

        return naturalCompare(
          a.subCategory?.name ?? '',
          b.subCategory?.name ?? '',
        );
      };
  }
}
