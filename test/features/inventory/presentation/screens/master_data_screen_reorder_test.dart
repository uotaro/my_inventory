import 'package:drift/drift.dart' show Value;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_inventory/features/inventory/data/local/app_database.dart'
    as local;
import 'package:my_inventory/features/inventory/data/local/app_database_provider.dart';
import 'package:my_inventory/features/inventory/presentation/screens/master_data_screen.dart';
import 'package:my_inventory/l10n/app_localizations.dart';

void main() {
  late local.AppDatabase db;

  setUp(() async {
    db = local.AppDatabase.forTesting(NativeDatabase.memory());

    // AppDatabaseはonCreateでサンプルの大分類・中分類・小分類・単位・色を
    // 自動投入するため、このテストで検証したい並び順の前提を崩さないよう
    // 一旦すべて削除してから、テスト用データだけを投入し直す。
    await db.delete(db.subCategories).go();
    await db.delete(db.categories).go();
    await db.delete(db.inventoryTypes).go();
    await db.delete(db.colorOptions).go();
    await db.delete(db.units).go();

    final typeA = await db
        .into(db.inventoryTypes)
        .insert(local.InventoryTypesCompanion.insert(name: '種別A'));
    final typeB = await db.into(db.inventoryTypes).insert(
      local.InventoryTypesCompanion.insert(
        name: '種別B',
        sortOrder: const Value(1),
      ),
    );

    final categoryA1 = await db.into(db.categories).insert(
      local.CategoriesCompanion.insert(
        inventoryTypeId: typeA,
        name: '中分類A1',
      ),
    );
    await db.into(db.categories).insert(
      local.CategoriesCompanion.insert(
        inventoryTypeId: typeA,
        name: '中分類A2',
        sortOrder: const Value(1),
      ),
    );
    // 種別Bを先に登録してもソート順（種別A→種別B）が優先されることを検証するための中分類。
    await db.into(db.categories).insert(
      local.CategoriesCompanion.insert(
        inventoryTypeId: typeB,
        name: '中分類B1',
      ),
    );

    await db.into(db.subCategories).insert(
      local.SubCategoriesCompanion.insert(
        categoryId: categoryA1,
        name: '小分類A1-1',
      ),
    );
    await db.into(db.subCategories).insert(
      local.SubCategoriesCompanion.insert(
        categoryId: categoryA1,
        name: '小分類A1-2',
        sortOrder: const Value(1),
      ),
    );

    await db
        .into(db.units)
        .insert(local.UnitsCompanion.insert(name: '単位1'));
    await db.into(db.units).insert(
      local.UnitsCompanion.insert(name: '単位2', sortOrder: const Value(1)),
    );

    final colorGroups = await db.select(db.colorGroups).get();
    await db.into(db.colorOptions).insert(
      local.ColorOptionsCompanion.insert(
        colorGroupId: colorGroups.first.id,
        name: '色1',
      ),
    );
    await db.into(db.colorOptions).insert(
      local.ColorOptionsCompanion.insert(
        colorGroupId: colorGroups.first.id,
        name: '色2',
        sortOrder: const Value(1),
      ),
    );
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
          home: const MasterDataScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();
  }

  // ProviderScope破棄時、drift StreamのキャンセルがTimer.zeroを発行するため、
  // テスト終了前に明示的にツリーを破棄してpumpし、pending timerを解消しておく。
  Future<void> disposeScreen(WidgetTester tester) async {
    await tester.pumpWidget(const SizedBox());
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 1));
    }
  }

  // 実際の長押しジェスチャーはシミュレーション環境依存で不安定なため、
  // ReorderableListViewウィジェットが実際に受け取るonReorderコールバックを
  // 直接呼び出すことで、長押しドラッグ確定時と同じ経路（DB永続化まで）を検証する。
  Future<void> invokeReorder(
    WidgetTester tester,
    Finder listFinder,
    int oldIndex,
    int newIndex,
  ) async {
    final list = tester.widget<ReorderableListView>(listFinder);
    // ignore: deprecated_member_use
    list.onReorder!(oldIndex, newIndex);
    await tester.pumpAndSettle();
  }

  testWidgets('全タブがクラッシュせず描画される', (tester) async {
    await pumpScreen(tester);
    expect(tester.takeException(), isNull);

    for (final tabText in ['中分類', '小分類', '色', '単位', '大分類']) {
      await tester.tap(find.text(tabText).first);
      await tester.pumpAndSettle();
      expect(
        tester.takeException(),
        isNull,
        reason: '$tabTextタブの描画で例外が発生しました',
      );
    }
    await disposeScreen(tester);
  });

  testWidgets('大分類タブで長押しドラッグするとsortOrderが更新される', (tester) async {
    await pumpScreen(tester);

    await invokeReorder(tester, find.byType(ReorderableListView), 0, 2);

    final types = await db.select(db.inventoryTypes).get();
    final typeB = types.firstWhere((t) => t.name == '種別B');
    final typeA = types.firstWhere((t) => t.name == '種別A');
    expect(typeB.sortOrder, lessThan(typeA.sortOrder));
    await disposeScreen(tester);
  });

  testWidgets('中分類タブで長押しドラッグすると同じ大分類内でsortOrderが更新される', (
    tester,
  ) async {
    await pumpScreen(tester);
    await tester.tap(find.text('中分類').first);
    await tester.pumpAndSettle();

    await invokeReorder(tester, find.byType(ReorderableListView).first, 0, 2);

    final categories = await db.select(db.categories).get();
    final a1 = categories.firstWhere((c) => c.name == '中分類A1');
    final a2 = categories.firstWhere((c) => c.name == '中分類A2');
    expect(a2.sortOrder, lessThan(a1.sortOrder));
    await disposeScreen(tester);
  });

  testWidgets('小分類タブのヘッダーは「大分類 - 中分類」の形式で、大分類→中分類の順に並ぶ', (
    tester,
  ) async {
    await pumpScreen(tester);
    await tester.tap(find.text('小分類').first);
    await tester.pumpAndSettle();

    final headerTexts = tester
        .widgetList<Text>(
          find.byWidgetPredicate(
            (w) => w is Text && (w.data?.contains(' - ') ?? false),
          ),
        )
        .map((t) => t.data)
        .toList();

    expect(headerTexts, [
      '種別A - 中分類A1',
      '種別A - 中分類A2',
      '種別B - 中分類B1',
    ]);
    await disposeScreen(tester);
  });

  testWidgets('小分類タブで長押しドラッグすると同じ中分類内でsortOrderが更新される', (
    tester,
  ) async {
    await pumpScreen(tester);
    await tester.tap(find.text('小分類').first);
    await tester.pumpAndSettle();

    await invokeReorder(tester, find.byType(ReorderableListView).first, 0, 2);

    final subCategories = await db.select(db.subCategories).get();
    final s1 = subCategories.firstWhere((s) => s.name == '小分類A1-1');
    final s2 = subCategories.firstWhere((s) => s.name == '小分類A1-2');
    expect(s2.sortOrder, lessThan(s1.sortOrder));
    await disposeScreen(tester);
  });

  testWidgets('色タブで長押しドラッグするとsortOrderが更新される', (tester) async {
    await pumpScreen(tester);
    await tester.tap(find.text('色').first);
    await tester.pumpAndSettle();

    await invokeReorder(tester, find.byType(ReorderableListView), 0, 2);

    final colorOptions = await db.select(db.colorOptions).get();
    final c1 = colorOptions.firstWhere((c) => c.name == '色1');
    final c2 = colorOptions.firstWhere((c) => c.name == '色2');
    expect(c2.sortOrder, lessThan(c1.sortOrder));
    await disposeScreen(tester);
  });

  testWidgets('単位タブで長押しドラッグするとsortOrderが更新される', (tester) async {
    await pumpScreen(tester);
    await tester.tap(find.text('単位').first);
    await tester.pumpAndSettle();

    await invokeReorder(tester, find.byType(ReorderableListView), 0, 2);

    final units = await db.select(db.units).get();
    final u1 = units.firstWhere((u) => u.name == '単位1');
    final u2 = units.firstWhere((u) => u.name == '単位2');
    expect(u2.sortOrder, lessThan(u1.sortOrder));
    await disposeScreen(tester);
  });
}
