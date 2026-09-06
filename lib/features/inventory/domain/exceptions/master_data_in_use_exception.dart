/// 紐づくアイテムが1件以上存在するマスタデータ（カテゴリー・単位など）を
/// 削除しようとした場合に投げる。
class MasterDataInUseException implements Exception {
  const MasterDataInUseException(this.name, this.itemCount);

  final String name;
  final int itemCount;

  @override
  String toString() => 'MasterDataInUseException: $name ($itemCount items)';
}

/// 紐づくカテゴリーが1件以上存在する種別（InventoryType）を
/// 削除しようとした場合に投げる。
class TypeInUseByCategoriesException implements Exception {
  const TypeInUseByCategoriesException(this.name, this.categoryCount);

  final String name;
  final int categoryCount;

  @override
  String toString() =>
      'TypeInUseByCategoriesException: $name ($categoryCount categories)';
}

/// 大分類（InventoryType）が最後の1件しかない状態で削除しようとした場合に投げる。
class LastInventoryTypeException implements Exception {
  const LastInventoryTypeException();

  @override
  String toString() => 'LastInventoryTypeException';
}
