import 'package:drift/drift.dart';

/// バーコード(JANコード)と商品名の対応を保存するローカルキャッシュ。
/// 手入力・外部API取得を問わず、確定した商品名を保存し次回以降の
/// 外部API呼び出しを減らすために使う。
@DataClassName('ProductNameCacheEntry')
class ProductNameCache extends Table {
  TextColumn get barcode => text()();
  TextColumn get name => text()();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();

  @override
  Set<Column> get primaryKey => {barcode};
}
