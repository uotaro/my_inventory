// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(shoppingList)
final shoppingListProvider = ShoppingListProvider._();

final class ShoppingListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ShoppingListEntry>>,
          List<ShoppingListEntry>,
          Stream<List<ShoppingListEntry>>
        >
    with
        $FutureModifier<List<ShoppingListEntry>>,
        $StreamProvider<List<ShoppingListEntry>> {
  ShoppingListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shoppingListProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shoppingListHash();

  @$internal
  @override
  $StreamProviderElement<List<ShoppingListEntry>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ShoppingListEntry>> create(Ref ref) {
    return shoppingList(ref);
  }
}

String _$shoppingListHash() => r'37846588151df03e19f704e3606b7320003438eb';

/// 在庫一覧で「既に買い物リストに追加済みか」を判定するためのアイテムID集合。

@ProviderFor(shoppingListItemIds)
final shoppingListItemIdsProvider = ShoppingListItemIdsProvider._();

/// 在庫一覧で「既に買い物リストに追加済みか」を判定するためのアイテムID集合。

final class ShoppingListItemIdsProvider
    extends
        $FunctionalProvider<AsyncValue<Set<int>>, Set<int>, Stream<Set<int>>>
    with $FutureModifier<Set<int>>, $StreamProvider<Set<int>> {
  /// 在庫一覧で「既に買い物リストに追加済みか」を判定するためのアイテムID集合。
  ShoppingListItemIdsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'shoppingListItemIdsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$shoppingListItemIdsHash();

  @$internal
  @override
  $StreamProviderElement<Set<int>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<Set<int>> create(Ref ref) {
    return shoppingListItemIds(ref);
  }
}

String _$shoppingListItemIdsHash() =>
    r'1181fa8c7cfb997db529714b5502cab788b07892';
