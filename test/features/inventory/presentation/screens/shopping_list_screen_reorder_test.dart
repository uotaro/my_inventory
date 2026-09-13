import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_inventory/features/inventory/data/local/app_database.dart'
    as local;
import 'package:my_inventory/features/inventory/data/local/app_database_provider.dart';
import 'package:my_inventory/features/inventory/data/repositories/item_repository_impl.dart';
import 'package:my_inventory/features/inventory/data/repositories/shopping_list_repository_impl.dart';
import 'package:my_inventory/features/inventory/presentation/screens/shopping_list_screen.dart';
import 'package:my_inventory/l10n/app_localizations.dart';

void main() {
  late local.AppDatabase db;
  late int itemAId;
  late int itemBId;

  setUp(() async {
    db = local.AppDatabase.forTesting(NativeDatabase.memory());

    final inventoryTypeId = await db
        .into(db.inventoryTypes)
        .insert(local.InventoryTypesCompanion.insert(name: 'テスト種別'));
    final categoryId = await db.into(db.categories).insert(
      local.CategoriesCompanion.insert(
        inventoryTypeId: inventoryTypeId,
        name: 'テストカテゴリー',
      ),
    );
    final unitId = await db
        .into(db.units)
        .insert(local.UnitsCompanion.insert(name: 'テスト単位'));

    final itemRepository = ItemRepositoryImpl(db);
    itemAId = await itemRepository.addItem(
      categoryId: categoryId,
      unitId: unitId,
      name: 'アイテムA',
    );
    itemBId = await itemRepository.addItem(
      categoryId: categoryId,
      unitId: unitId,
      name: 'アイテムB',
    );

    final shoppingListRepository = ShoppingListRepositoryImpl(db);
    // アイテムA→Bの順で追加し、sortOrderが追加順（A=0, B=1）になることを前提にする。
    await shoppingListRepository.addItem(itemAId);
    await shoppingListRepository.addItem(itemBId);
  });

  tearDown(() async {
    await db.close();
  });

  Future<void> pumpScreen(WidgetTester tester) async {
    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          locale: const Locale('ja'),
          localizationsDelegates: L10n.localizationsDelegates,
          supportedLocales: L10n.supportedLocales,
          home: const ShoppingListScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  Future<void> disposeScreen(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 1));
    }
  }

  testWidgets('買い物リストがクラッシュせず描画される', (tester) async {
    await pumpScreen(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('アイテムA'), findsOneWidget);
    expect(find.text('アイテムB'), findsOneWidget);
    await disposeScreen(tester);
  });

  testWidgets('長押しドラッグすると買い物リストのsortOrderが更新される', (tester) async {
    await pumpScreen(tester);

    final list = tester.widget<ReorderableListView>(
      find.byType(ReorderableListView),
    );
    // ignore: deprecated_member_use
    list.onReorder!(0, 2);
    await tester.pumpAndSettle();

    final entries = await db.select(db.shoppingListEntries).get();
    final entryA = entries.firstWhere((e) => e.itemId == itemAId);
    final entryB = entries.firstWhere((e) => e.itemId == itemBId);
    expect(entryB.sortOrder, lessThan(entryA.sortOrder));
    await disposeScreen(tester);
  });
}
