/// 同じスコープ内に同名のマスタデータ（カテゴリー・色・単位など）が
/// 既に存在する場合に投げる。
class DuplicateNameException implements Exception {
  const DuplicateNameException(this.name);

  final String name;

  @override
  String toString() => 'DuplicateNameException: $name';
}
