import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_inventory/features/inventory/data/local/app_database.dart'
    as local;
import 'package:my_inventory/features/inventory/data/repositories/category_repository_impl.dart';
import 'package:my_inventory/features/inventory/data/repositories/color_option_repository_impl.dart';
import 'package:my_inventory/features/inventory/data/repositories/inventory_type_repository_impl.dart';
import 'package:my_inventory/features/inventory/data/repositories/shopping_list_repository_impl.dart';
import 'package:my_inventory/features/inventory/data/repositories/sub_category_repository_impl.dart';
import 'package:my_inventory/features/inventory/data/repositories/unit_repository_impl.dart';

/// 並べ替え対象の6つのリポジトリで共通の `updateSortOrders` の振る舞いを検証する。
class _Case {
  const _Case({
    required this.label,
    required this.table,
    required this.otherColumn,
    required this.updateSortOrders,
    required this.seed,
  });

  final String label;

  /// SQL上のテーブル名（トリガーと素のSELECTで使う）。
  final String table;

  /// sortOrder以外で「更新されないこと」を確認する列。
  final String otherColumn;

  final Future<void> Function(local.AppDatabase db, Map<int, int> sortOrderById)
  updateSortOrders;

  /// sortOrder=0,1,2 の3行を登録し、そのIDを返す。
  final Future<List<int>> Function(local.AppDatabase db) seed;
}

final _cases = <_Case>[
  _Case(
    label: '大分類',
    table: 'inventory_types',
    otherColumn: 'name',
    updateSortOrders: (db, m) =>
        InventoryTypeRepositoryImpl(db).updateSortOrders(m),
    seed: (db) async => [
      for (var i = 0; i < 3; i++)
        await db.into(db.inventoryTypes).insert(
          local.InventoryTypesCompanion.insert(
            name: 'テスト大分類$i',
            sortOrder: Value(i),
          ),
        ),
    ],
  ),
  _Case(
    label: '中分類',
    table: 'categories',
    otherColumn: 'name',
    updateSortOrders: (db, m) => CategoryRepositoryImpl(db).updateSortOrders(m),
    seed: (db) async {
      final typeId = await db
          .into(db.inventoryTypes)
          .insert(local.InventoryTypesCompanion.insert(name: 'テスト大分類'));
      return [
        for (var i = 0; i < 3; i++)
          await db.into(db.categories).insert(
            local.CategoriesCompanion.insert(
              inventoryTypeId: typeId,
              name: 'テスト中分類$i',
              sortOrder: Value(i),
            ),
          ),
      ];
    },
  ),
  _Case(
    label: '小分類',
    table: 'sub_categories',
    otherColumn: 'name',
    updateSortOrders: (db, m) =>
        SubCategoryRepositoryImpl(db).updateSortOrders(m),
    seed: (db) async {
      final typeId = await db
          .into(db.inventoryTypes)
          .insert(local.InventoryTypesCompanion.insert(name: 'テスト大分類'));
      final categoryId = await db.into(db.categories).insert(
        local.CategoriesCompanion.insert(
          inventoryTypeId: typeId,
          name: 'テスト中分類',
        ),
      );
      return [
        for (var i = 0; i < 3; i++)
          await db.into(db.subCategories).insert(
            local.SubCategoriesCompanion.insert(
              categoryId: categoryId,
              name: 'テスト小分類$i',
              sortOrder: Value(i),
            ),
          ),
      ];
    },
  ),
  _Case(
    label: '色',
    table: 'color_options',
    otherColumn: 'name',
    updateSortOrders: (db, m) =>
        ColorOptionRepositoryImpl(db).updateSortOrders(m),
    seed: (db) async {
      final groupId = (await db.select(db.colorGroups).get()).first.id;
      return [
        for (var i = 0; i < 3; i++)
          await db.into(db.colorOptions).insert(
            local.ColorOptionsCompanion.insert(
              colorGroupId: groupId,
              name: 'テスト色$i',
              sortOrder: Value(i),
            ),
          ),
      ];
    },
  ),
  _Case(
    label: '単位',
    table: 'units',
    otherColumn: 'name',
    updateSortOrders: (db, m) => UnitRepositoryImpl(db).updateSortOrders(m),
    seed: (db) async => [
      for (var i = 0; i < 3; i++)
        await db.into(db.units).insert(
          local.UnitsCompanion.insert(name: 'テスト単位$i', sortOrder: Value(i)),
        ),
    ],
  ),
  _Case(
    label: '買い物リスト',
    table: 'shopping_list_entries',
    otherColumn: 'purchase_quantity',
    updateSortOrders: (db, m) =>
        ShoppingListRepositoryImpl(db).updateSortOrders(m),
    seed: (db) async {
      final typeId = await db
          .into(db.inventoryTypes)
          .insert(local.InventoryTypesCompanion.insert(name: 'テスト大分類'));
      final categoryId = await db.into(db.categories).insert(
        local.CategoriesCompanion.insert(
          inventoryTypeId: typeId,
          name: 'テスト中分類',
        ),
      );
      final unitId = await db
          .into(db.units)
          .insert(local.UnitsCompanion.insert(name: 'テスト単位'));
      final ids = <int>[];
      for (var i = 0; i < 3; i++) {
        final itemId = await db.into(db.items).insert(
          local.ItemsCompanion.insert(
            categoryId: categoryId,
            unitId: unitId,
            name: 'テストアイテム$i',
          ),
        );
        ids.add(
          await db.into(db.shoppingListEntries).insert(
            local.ShoppingListEntriesCompanion.insert(
              itemId: itemId,
              purchaseQuantity: Value(i + 10.0),
              sortOrder: Value(i),
            ),
          ),
        );
      }
      return ids;
    },
  ),
];

void main() {
  late local.AppDatabase db;

  setUp(() {
    db = local.AppDatabase.forTesting(NativeDatabase.memory());
  });

  tearDown(() async {
    await db.close();
  });

  /// [ids] の行について「ID → 列の値」を返す。
  Future<Map<int, Object?>> readColumn(
    _Case c,
    List<int> ids,
    String column,
  ) async {
    final rows = await db.customSelect('SELECT id, $column FROM ${c.table}').get();
    return {
      for (final row in rows)
        if (ids.contains(row.read<int>('id'))) row.read<int>('id'): row.data[column],
    };
  }

  for (final c in _cases) {
    group('${c.label}の updateSortOrders', () {
      test('指定したIDのsortOrderだけを更新し、指定しない行はそのまま残す', () async {
        final ids = await c.seed(db);

        await c.updateSortOrders(db, {ids[0]: 2, ids[2]: 0});

        expect(await readColumn(c, ids, 'sort_order'), {
          ids[0]: 2,
          ids[1]: 1,
          ids[2]: 0,
        });
      });

      test('sortOrder以外の列は変更しない', () async {
        final ids = await c.seed(db);
        final before = await readColumn(c, ids, c.otherColumn);

        await c.updateSortOrders(db, {ids[0]: 2, ids[1]: 0, ids[2]: 1});

        expect(await readColumn(c, ids, c.otherColumn), before);
      });

      test('空のマップでも例外にならず、何も変更しない', () async {
        final ids = await c.seed(db);

        await c.updateSortOrders(db, {});

        expect(await readColumn(c, ids, 'sort_order'), {
          ids[0]: 0,
          ids[1]: 1,
          ids[2]: 2,
        });
      });

      test('途中で失敗した場合は、それまでの更新も含めて全て元に戻る', () async {
        final ids = await c.seed(db);
        // sort_order=99 への更新だけを失敗させ、「2件目で失敗」を再現する。
        await db.customStatement(
          'CREATE TRIGGER fail_on_99 BEFORE UPDATE ON ${c.table} '
          'WHEN NEW.sort_order = 99 '
          "BEGIN SELECT RAISE(ABORT, 'テスト用の失敗'); END",
        );

        await expectLater(
          c.updateSortOrders(db, {ids[0]: 5, ids[1]: 99}),
          throwsA(anything),
        );

        expect(await readColumn(c, ids, 'sort_order'), {
          ids[0]: 0,
          ids[1]: 1,
          ids[2]: 2,
        });
      });
    });
  }
}
