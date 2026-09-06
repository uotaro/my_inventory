import 'package:drift/native.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:my_inventory/features/inventory/data/local/app_database.dart'
    as local;
import 'package:my_inventory/features/inventory/data/local/app_database_provider.dart';
import 'package:my_inventory/features/inventory/data/repositories/item_repository_impl.dart';
import 'package:my_inventory/features/inventory/presentation/providers/filtered_items_provider.dart';
import 'package:my_inventory/features/inventory/presentation/providers/item_filter_controller.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late local.AppDatabase db;
  late ProviderContainer container;
  late int categoryId;
  late int unitId;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    db = local.AppDatabase.forTesting(NativeDatabase.memory());
    container = ProviderContainer(
      overrides: [appDatabaseProvider.overrideWithValue(db)],
    );
    addTearDown(container.dispose);
    addTearDown(db.close);

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

  Future<void> createItem({
    required String name,
    required double quantity,
    double lowStockThreshold = 0,
  }) {
    return container.read(itemRepositoryProvider).addItem(
          categoryId: categoryId,
          unitId: unitId,
          name: name,
          quantity: quantity,
          lowStockThreshold: lowStockThreshold,
        );
  }

  Future<List<String>> namesFor(StockFilter filter) async {
    container
        .read(itemFilterControllerProvider.notifier)
        .setStockFilter(filter);
    final items = await container.read(filteredItemsProvider.future);
    return items.map((i) => i.name).toList()..sort();
  }

  group('在庫による絞り込み', () {
    setUp(() async {
      // 在庫数(5) > 目安(2) -> 在庫あり
      await createItem(name: 'A', quantity: 5, lowStockThreshold: 2);
      // 在庫数(2) <= 目安(2) -> 在庫不足
      await createItem(name: 'B', quantity: 2, lowStockThreshold: 2);
      // 在庫数(0) <= 目安(2) -> 在庫不足かつ在庫0
      await createItem(name: 'C', quantity: 0, lowStockThreshold: 2);
      // 目安0、在庫数(3) > 0 -> 在庫あり
      await createItem(name: 'D', quantity: 3, lowStockThreshold: 0);
      // 目安0、在庫数(0) <= 0 -> 在庫不足かつ在庫0
      await createItem(name: 'E', quantity: 0, lowStockThreshold: 0);

      // filteredItemsProviderはautoDisposeのため、購読者がいないと
      // read(...future)の完了前に破棄されてしまう
      // （"disposed during loading state" 例外）。テスト中は破棄されないよう
      // ダミーの購読を維持しておく（アイテム作成後に購読することで、
      // 初回クエリの時点で5件すべてが反映された状態を保証する）。
      final subscription = container.listen(filteredItemsProvider, (_, _) {});
      addTearDown(subscription.close);
    });

    test('すべて: 全アイテムが表示される', () async {
      expect(await namesFor(StockFilter.all), ['A', 'B', 'C', 'D', 'E']);
    });

    test('在庫あり: 在庫数が目安を上回るアイテムのみ表示される', () async {
      expect(await namesFor(StockFilter.inStock), ['A', 'D']);
    });

    test('在庫不足: 在庫数が目安以下のアイテムのみ表示される', () async {
      expect(await namesFor(StockFilter.lowStock), ['B', 'C', 'E']);
    });

    test('在庫0: 在庫数が0のアイテムのみ表示される', () async {
      expect(await namesFor(StockFilter.zero), ['C', 'E']);
    });
  });
}
