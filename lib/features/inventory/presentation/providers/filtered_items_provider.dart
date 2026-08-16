import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../../../core/utils/natural_compare.dart';
import '../../data/repositories/item_repository_impl.dart';
import '../../domain/entities/item.dart';
import 'item_filter_controller.dart';

part 'filtered_items_provider.g.dart';

@riverpod
Stream<List<Item>> filteredItems(Ref ref) {
  final filter = ref.watch(itemFilterControllerProvider);
  final itemsStream = ref.watch(itemRepositoryProvider).watchItems(
        categoryId: filter.categoryId,
        subCategoryId: filter.subCategoryId,
        colorGroupId: filter.colorGroupId,
        minQuantity: filter.inStockOnly ? 1 : null,
      );

  final nameQuery = filter.nameQuery.trim().toLowerCase();
  final favoriteMin = filter.favoriteMin;
  final favoriteMax = filter.favoriteMax;
  final sortKey = filter.sortKey;

  return itemsStream.map((items) {
    Iterable<Item> result = items;
    if (nameQuery.isNotEmpty || favoriteMin != null || favoriteMax != null) {
      result = result.where((item) {
        final matchesName =
            nameQuery.isEmpty || item.name.toLowerCase().contains(nameQuery);
        final matchesFavorite =
            (favoriteMin == null || item.favoriteRating >= favoriteMin) &&
            (favoriteMax == null || item.favoriteRating <= favoriteMax);
        return matchesName && matchesFavorite;
      });
    }

    final sorted = result.toList();
    if (sortKey != null) {
      sorted.sort(_comparatorFor(sortKey));
      if (!filter.sortAscending) {
        return sorted.reversed.toList();
      }
    }
    return sorted;
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
      return (a, b) => naturalCompare(a.category.name, b.category.name);
  }
}
