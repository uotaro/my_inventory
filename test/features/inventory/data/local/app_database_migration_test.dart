import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite3/sqlite3.dart' as sqlite3;

import 'package:my_inventory/features/inventory/data/local/app_database.dart'
    as local;

/// schemaVersion 6時点の最小限のitemsテーブル（low_stock_thresholdがNULL許容）を
/// 直接SQLで構築し、アプリのマイグレーションが正しく既存データを
/// 引き継ぐかを検証する。
void main() {
  test('schemaVersion 6→7で、目安未入力（NULL）の既存アイテムは目安0に補正される', () async {
    final rawDb = sqlite3.sqlite3.openInMemory();
    rawDb.execute('''
      CREATE TABLE items (
        id INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
        category_id INTEGER NOT NULL,
        sub_category_id INTEGER NULL,
        color_id INTEGER NULL,
        unit_id INTEGER NOT NULL,
        barcode TEXT NULL UNIQUE,
        name TEXT NOT NULL,
        favorite_rating INTEGER NOT NULL DEFAULT 0,
        quantity REAL NOT NULL DEFAULT 0.0,
        low_stock_threshold REAL NULL,
        image_path TEXT NULL,
        memo TEXT NULL,
        created_at INTEGER NOT NULL,
        updated_at INTEGER NOT NULL
      );
    ''');
    rawDb.execute('''
      INSERT INTO items
        (category_id, unit_id, name, quantity, low_stock_threshold, created_at, updated_at)
      VALUES
        (1, 1, '目安未設定アイテム', 3.0, NULL, 0, 0),
        (1, 1, '目安設定済みアイテム', 3.0, 5.0, 0, 0);
    ''');
    rawDb.execute('PRAGMA user_version = 6;');

    final db = local.AppDatabase.forTesting(NativeDatabase.opened(rawDb));
    addTearDown(db.close);

    final rows =
        await (db.select(db.items)..orderBy([(t) => OrderingTerm(expression: t.id)]))
            .get();

    expect(rows, hasLength(2));
    expect(rows[0].name, '目安未設定アイテム');
    expect(rows[0].lowStockThreshold, 0.0);
    expect(rows[1].name, '目安設定済みアイテム');
    expect(rows[1].lowStockThreshold, 5.0);
  });
}
