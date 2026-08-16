/// 紐づくアイテムが1件以上存在するマスタデータ（カテゴリー・単位など）を
/// 削除しようとした場合に投げる。
class MasterDataInUseException implements Exception {
  const MasterDataInUseException(this.name, this.itemCount);

  final String name;
  final int itemCount;

  @override
  String toString() => 'MasterDataInUseException: $name ($itemCount items)';
}
