import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_inventory/core/utils/route_observer.dart';
import 'package:my_inventory/features/inventory/data/local/app_database.dart'
    as local;
import 'package:my_inventory/features/inventory/data/local/app_database_provider.dart';
import 'package:my_inventory/features/inventory/data/repositories/item_repository_impl.dart';
import 'package:my_inventory/features/inventory/presentation/screens/item_list_screen.dart';
import 'package:my_inventory/l10n/app_localizations.dart';

void main() {
  testWidgets('スワイプで開いた行は、他画面から戻ったときに閉じ、スクロール位置は保たれる', (tester) async {
    final db = local.AppDatabase.forTesting(NativeDatabase.memory());
    final inventoryType = (await db.select(db.inventoryTypes).get()).first;
    final categoryId = await db
        .into(db.categories)
        .insert(
          local.CategoriesCompanion.insert(
            inventoryTypeId: inventoryType.id,
            name: 'パーツ',
          ),
        );
    final unitId = await db
        .into(db.units)
        .insert(local.UnitsCompanion.insert(name: 'テスト単位'));
    final itemRepository = ItemRepositoryImpl(db);
    for (var i = 0; i < 40; i++) {
      await itemRepository.addItem(
        categoryId: categoryId,
        unitId: unitId,
        name: 'アイテム$i',
      );
    }

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          locale: const Locale('ja'),
          localizationsDelegates: L10n.localizationsDelegates,
          supportedLocales: L10n.supportedLocales,
          navigatorObservers: [routeObserver],
          home: const ItemListScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 削除アクションは、行を開いている間だけ表示される。
    expect(find.byIcon(Icons.delete), findsNothing);

    // 一覧を下へスクロールしておく（戻ったあとも位置が保たれることを確認するため）。
    final listScrollable = find.descendant(
      of: find.byType(ListView),
      matching: find.byType(Scrollable),
    );
    await tester.drag(listScrollable, const Offset(0, -400));
    await tester.pumpAndSettle();
    final offsetBefore = tester
        .state<ScrollableState>(listScrollable)
        .position
        .pixels;
    expect(offsetBefore, greaterThan(0));

    // 画面内の行を左にスワイプして開く。
    await tester.fling(
      find.byType(Slidable).hitTestable().first,
      const Offset(-300, 0),
      1000,
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.delete), findsOneWidget);

    // 他画面（買い物リスト）へ遷移して、一覧に戻る。
    await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
    await tester.pumpAndSettle();
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    await tester.pumpAndSettle();

    expect(find.byIcon(Icons.delete), findsNothing);
    expect(
      tester.state<ScrollableState>(listScrollable).position.pixels,
      offsetBefore,
    );

    await tester.pumpWidget(const SizedBox());
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 1));
    }
    await db.close();
  });

  testWidgets('低在庫の行を開いたまま他画面へ移動し戻っても、戻った直後に行がずれない', (tester) async {
    final db = local.AppDatabase.forTesting(NativeDatabase.memory());
    final inventoryType = (await db.select(db.inventoryTypes).get()).first;
    final categoryId = await db
        .into(db.categories)
        .insert(
          local.CategoriesCompanion.insert(
            inventoryTypeId: inventoryType.id,
            name: 'パーツ',
          ),
        );
    final unitId = await db
        .into(db.units)
        .insert(local.UnitsCompanion.insert(name: 'テスト単位'));
    for (final name in ['在庫少A', '在庫少B']) {
      await ItemRepositoryImpl(db).addItem(
        categoryId: categoryId,
        unitId: unitId,
        name: name,
        quantity: 0,
        lowStockThreshold: 5,
      );
    }

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          locale: const Locale('ja'),
          localizationsDelegates: L10n.localizationsDelegates,
          supportedLocales: L10n.supportedLocales,
          navigatorObservers: [routeObserver],
          home: const ItemListScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.fling(
      find.byType(Slidable).hitTestable().first,
      const Offset(-300, 0),
      1000,
    );
    await tester.pumpAndSettle();
    expect(
      tester
          .widget<SlideTransition>(
            find
                .descendant(
                  of: find.byType(Slidable).first,
                  matching: find.byType(SlideTransition),
                )
                .first,
          )
          .position
          .value
          .dx,
      isNot(0),
    );

    await tester.tap(find.byIcon(Icons.shopping_cart_outlined));
    await tester.pumpAndSettle();
    tester.state<NavigatorState>(find.byType(Navigator)).pop();
    // 戻った直後のフレーム。画面遷移によるずれは両方の行に同じように掛かるので、
    // 行同士を比べることで、行だけのずれ（見切れ）を検出する。
    await tester.pump(const Duration(milliseconds: 16));

    // 同じリスト内の、スワイプしていない行と同じ位置にあること。
    // 行だけがずれていると、背景色が画面外へ見切れて見える。
    expect(
      tester.getRect(find.byType(ListTile).at(0)).left,
      tester.getRect(find.byType(ListTile).at(1)).left,
    );

    await tester.pumpWidget(const SizedBox());
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 1));
    }
    await db.close();
  });

  testWidgets('スワイプで開く行は1つだけ。別の行を開くと、前の行は閉じる', (tester) async {
    final db = local.AppDatabase.forTesting(NativeDatabase.memory());
    final inventoryType = (await db.select(db.inventoryTypes).get()).first;
    final categoryId = await db
        .into(db.categories)
        .insert(
          local.CategoriesCompanion.insert(
            inventoryTypeId: inventoryType.id,
            name: 'パーツ',
          ),
        );
    final unitId = await db
        .into(db.units)
        .insert(local.UnitsCompanion.insert(name: 'テスト単位'));
    for (final name in ['アイテムA', 'アイテムB']) {
      await ItemRepositoryImpl(
        db,
      ).addItem(categoryId: categoryId, unitId: unitId, name: name);
    }

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          locale: const Locale('ja'),
          localizationsDelegates: L10n.localizationsDelegates,
          supportedLocales: L10n.supportedLocales,
          navigatorObservers: [routeObserver],
          home: const ItemListScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    // 1行目を開く。
    await tester.fling(
      find.byType(Slidable).at(0),
      const Offset(-300, 0),
      1000,
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.delete), findsOneWidget);

    // 2行目を開くと、1行目は閉じて、開いているのは1行だけになる。
    await tester.fling(
      find.byType(Slidable).at(1),
      const Offset(-300, 0),
      1000,
    );
    await tester.pumpAndSettle();
    expect(find.byIcon(Icons.delete), findsOneWidget);
    expect(
      tester
          .widget<SlideTransition>(
            find
                .descendant(
                  of: find.byType(Slidable).at(0),
                  matching: find.byType(SlideTransition),
                )
                .first,
          )
          .position
          .value
          .dx,
      0,
    );

    await tester.pumpWidget(const SizedBox());
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 1));
    }
    await db.close();
  });
}
