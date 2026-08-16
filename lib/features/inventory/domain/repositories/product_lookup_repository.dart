abstract class ProductLookupRepository {
  /// バーコードから商品名を検索する。ローカルキャッシュに無ければ外部APIに問い合わせる。
  /// 見つからない場合はnull（呼び出し側は手入力にフォールバックする）。
  Future<String?> lookupName(String barcode);

  /// バーコードと商品名の対応をローカルに保存する（同じバーコードは上書き）。
  /// 次回以降は外部APIを呼ばずにこのキャッシュから解決する。
  Future<void> saveName(String barcode, String name);
}
