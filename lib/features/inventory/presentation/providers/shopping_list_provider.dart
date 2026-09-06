import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/shopping_list_repository_impl.dart';
import '../../domain/entities/shopping_list_entry.dart';

part 'shopping_list_provider.g.dart';

@riverpod
Stream<List<ShoppingListEntry>> shoppingList(Ref ref) {
  return ref.watch(shoppingListRepositoryProvider).watchShoppingList();
}

/// 在庫一覧で「既に買い物リストに追加済みか」を判定するためのアイテムID集合。
@riverpod
Stream<Set<int>> shoppingListItemIds(Ref ref) {
  return ref
      .watch(shoppingListRepositoryProvider)
      .watchShoppingList()
      .map((entries) => entries.map((e) => e.item.id).toSet());
}
