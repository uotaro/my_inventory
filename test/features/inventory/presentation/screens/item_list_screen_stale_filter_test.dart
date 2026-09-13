import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:my_inventory/features/inventory/data/local/app_database.dart'
    as local;
import 'package:my_inventory/features/inventory/data/local/app_database_provider.dart';
import 'package:my_inventory/features/inventory/presentation/providers/item_filter_controller.dart';
import 'package:my_inventory/features/inventory/presentation/screens/item_list_screen.dart';
import 'package:my_inventory/features/inventory/presentation/screens/master_data_screen.dart';
import 'package:my_inventory/l10n/app_localizations.dart';

void main() {
  testWidgets('検索条件の小分類が削除されてもクラッシュせず検索条件が解除される', (tester) async {
    final db = local.AppDatabase.forTesting(NativeDatabase.memory());
    await db.customSelect('select 1').get();

    final inventoryType = (await db.select(db.inventoryTypes).get()).first;
    final categoryId = await db.into(db.categories).insert(
      local.CategoriesCompanion.insert(
        inventoryTypeId: inventoryType.id,
        name: 'パーツ',
      ),
    );
    final subCategoryId = await db.into(db.subCategories).insert(
      local.SubCategoriesCompanion.insert(categoryId: categoryId, name: '適当'),
    );

    await tester.pumpWidget(
      ProviderScope(
        overrides: [appDatabaseProvider.overrideWithValue(db)],
        child: MaterialApp(
          locale: const Locale('ja'),
          localizationsDelegates: L10n.localizationsDelegates,
          supportedLocales: L10n.supportedLocales,
          home: const ItemListScreen(),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final container = ProviderScope.containerOf(
      tester.element(find.byType(ItemListScreen)),
    );
    final filterController = container.read(
      itemFilterControllerProvider.notifier,
    );
    filterController.setInventoryType(inventoryType.id);
    filterController.setCategory(categoryId);
    filterController.setSubCategory(subCategoryId);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);

    // マスタ管理画面で該当の小分類を削除する。
    await tester.tap(find.byTooltip('マスタ管理'));
    await tester.pumpAndSettle();
    expect(find.byType(MasterDataScreen), findsOneWidget);
    await tester.tap(find.text('小分類').first);
    await tester.pumpAndSettle();
    expect(find.text('適当'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.delete_outline).first);
    await tester.pumpAndSettle();
    await tester.tap(find.text('削除').last);
    await tester.pumpAndSettle();

    // 在庫一覧画面に戻る。
    final navigator = tester.state<NavigatorState>(find.byType(Navigator));
    navigator.pop();
    await tester.pumpAndSettle();

    expect(tester.takeException(), isNull);
    expect(container.read(itemFilterControllerProvider).subCategoryId, isNull);

    await tester.pumpWidget(const SizedBox());
    for (var i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 1));
    }
    await db.close();
  });
}
