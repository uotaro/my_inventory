import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_inventory/features/inventory/data/local/app_database.dart'
    as local;
import 'package:my_inventory/features/inventory/data/repositories/item_repository_impl.dart';
import 'package:my_inventory/features/inventory/data/repositories/stock_log_repository_impl.dart';

void main() {
  late local.AppDatabase db;
  late ItemRepositoryImpl itemRepository;
  late StockLogRepositoryImpl stockLogRepository;
  late int categoryId;
  late int unitId;

  setUp(() async {
    db = local.AppDatabase.forTesting(NativeDatabase.memory());
    itemRepository = ItemRepositoryImpl(db);
    stockLogRepository = StockLogRepositoryImpl(db);

    final inventoryTypeId = await db
        .into(db.inventoryTypes)
        .insert(local.InventoryTypesCompanion.insert(name: 'テスト種別'));
    categoryId = await db.into(db.categories).insert(
          local.CategoriesCompanion.insert(
            inventoryTypeId: inventoryTypeId,
            name: 'テストカテゴリー',
          ),
        );
    unitId = await db
        .into(db.units)
        .insert(local.UnitsCompanion.insert(name: 'テスト単位'));
  });

  tearDown(() async {
    await db.close();
  });

  Future<int> createItem({double quantity = 0}) {
    return itemRepository.addItem(
      categoryId: categoryId,
      unitId: unitId,
      name: 'テストアイテム',
      quantity: quantity,
    );
  }

  Future<local.Item> readItem(int itemId) {
    return (db.select(
      db.items,
    )..where((t) => t.id.equals(itemId))).getSingle();
  }

  Future<List<local.StockLog>> readLogs(int itemId) {
    return (db.select(
      db.stockLogs,
    )..where((t) => t.itemId.equals(itemId))).get();
  }

  group('adjustQuantity', () {
    test('正の変化量を指定すると在庫が増加し、履歴が1件記録される', () async {
      final itemId = await createItem(quantity: 10);

      await itemRepository.adjustQuantity(itemId, 5, reason: '仕入れ');

      final item = await readItem(itemId);
      expect(item.quantity, 15);

      final logs = await readLogs(itemId);
      expect(logs, hasLength(1));
      expect(logs.single.changeAmount, 5);
      expect(logs.single.reason, '仕入れ');
    });

    test('負の変化量を指定すると在庫が減少し、履歴が1件記録される', () async {
      final itemId = await createItem(quantity: 10);

      await itemRepository.adjustQuantity(itemId, -3, reason: '消費');

      final item = await readItem(itemId);
      expect(item.quantity, 7);

      final logs = await readLogs(itemId);
      expect(logs, hasLength(1));
      expect(logs.single.changeAmount, -3);
      expect(logs.single.reason, '消費');
    });

    test('現在庫を超える減少要求は0で頭打ちになる', () async {
      final itemId = await createItem(quantity: 3);

      await itemRepository.adjustQuantity(itemId, -10);

      final item = await readItem(itemId);
      expect(item.quantity, 0);
    });

    test('クランプが発生した場合、履歴には要求量ではなく実際に適用された変化量が記録される', () async {
      final itemId = await createItem(quantity: 3);

      await itemRepository.adjustQuantity(itemId, -10, reason: '大量消費');

      final logs = await readLogs(itemId);
      expect(logs, hasLength(1));
      expect(logs.single.changeAmount, -3); // 3 -> 0 の実変化量（要求値-10ではない）
    });

    test('在庫が既に0の状態でさらに減少しようとした場合、更新も履歴追加も行われない', () async {
      final itemId = await createItem(quantity: 0);

      await itemRepository.adjustQuantity(itemId, -5);

      final item = await readItem(itemId);
      expect(item.quantity, 0);
      expect(await readLogs(itemId), isEmpty);
    });

    test('changeAmountが0の場合、更新も履歴追加も行われない', () async {
      final itemId = await createItem(quantity: 5);

      await itemRepository.adjustQuantity(itemId, 0);

      expect(await readLogs(itemId), isEmpty);
    });

    test('reasonを指定しない場合はnullとして履歴に保存される', () async {
      final itemId = await createItem(quantity: 5);

      await itemRepository.adjustQuantity(itemId, 2);

      final logs = await readLogs(itemId);
      expect(logs.single.reason, isNull);
    });

    test('増減を繰り返すと在庫数が累積し、履歴も件数分記録される', () async {
      final itemId = await createItem(quantity: 0);

      await itemRepository.adjustQuantity(itemId, 10, reason: '入荷');
      await itemRepository.adjustQuantity(itemId, -4, reason: '出荷');
      await itemRepository.adjustQuantity(itemId, -20); // 6 -> 0 にクランプされる

      final item = await readItem(itemId);
      expect(item.quantity, 0);
      expect(await readLogs(itemId), hasLength(3));
    });

    test('他のアイテムの在庫・履歴には影響しない', () async {
      final itemId1 = await createItem(quantity: 5);
      final itemId2 = await createItem(quantity: 5);

      await itemRepository.adjustQuantity(itemId1, 3);

      final item1 = await readItem(itemId1);
      final item2 = await readItem(itemId2);
      expect(item1.quantity, 8);
      expect(item2.quantity, 5);
      expect(await readLogs(itemId2), isEmpty);
    });
  });

  group('watchLogsForItem', () {
    test('指定したアイテムの履歴のみを返す', () async {
      final itemId1 = await createItem(quantity: 0);
      final itemId2 = await createItem(quantity: 0);

      await itemRepository.adjustQuantity(itemId1, 5, reason: 'item1の入荷');
      await itemRepository.adjustQuantity(itemId2, 8, reason: 'item2の入荷');

      final logs = await stockLogRepository.watchLogsForItem(itemId1).first;
      expect(logs, hasLength(1));
      expect(logs.single.itemId, itemId1);
      expect(logs.single.reason, 'item1の入荷');
    });
  });
}
