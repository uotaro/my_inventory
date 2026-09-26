import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_inventory/features/inventory/data/local/app_database.dart'
    as local;
import 'package:my_inventory/features/inventory/data/repositories/category_repository_impl.dart';
import 'package:my_inventory/features/inventory/domain/exceptions/master_data_in_use_exception.dart';

void main() {
  late local.AppDatabase db;
  late CategoryRepositoryImpl repository;
  late int inventoryTypeId;

  setUp(() async {
    db = local.AppDatabase.forTesting(NativeDatabase.memory());
    repository = CategoryRepositoryImpl(db);
    inventoryTypeId = await db
        .into(db.inventoryTypes)
        .insert(local.InventoryTypesCompanion.insert(name: 'テスト種別'));
  });

  tearDown(() async {
    await db.close();
  });

  // onCreateでサンプルのカテゴリーが登録されるため、総件数ではなくIDで存在を確認する。
  Future<bool> exists(int id) async =>
      (await (db.select(db.categories)..where((t) => t.id.equals(id))).get())
          .isNotEmpty;

  group('deleteCategory', () {
    test('小分類もアイテムも無いカテゴリーは削除できる', () async {
      final id = await repository.addCategory(
        inventoryTypeId: inventoryTypeId,
        name: 'カテゴリーA',
      );

      await repository.deleteCategory(id);

      expect(await exists(id), isFalse);
    });

    test('小分類が登録されているカテゴリーは削除できず、件数を通知する', () async {
      final id = await repository.addCategory(
        inventoryTypeId: inventoryTypeId,
        name: 'カテゴリーA',
      );
      for (final name in ['小1', '小2']) {
        await db.into(db.subCategories).insert(
              local.SubCategoriesCompanion.insert(categoryId: id, name: name),
            );
      }

      await expectLater(
        repository.deleteCategory(id),
        throwsA(
          isA<CategoryInUseBySubCategoriesException>()
              .having((e) => e.name, 'name', 'カテゴリーA')
              .having((e) => e.subCategoryCount, 'subCategoryCount', 2),
        ),
      );
      expect(await exists(id), isTrue);
    });

    test('他のカテゴリーの小分類は削除を妨げない', () async {
      final target = await repository.addCategory(
        inventoryTypeId: inventoryTypeId,
        name: 'カテゴリーA',
      );
      final other = await repository.addCategory(
        inventoryTypeId: inventoryTypeId,
        name: 'カテゴリーB',
      );
      await db.into(db.subCategories).insert(
            local.SubCategoriesCompanion.insert(categoryId: other, name: '小'),
          );

      await repository.deleteCategory(target);

      expect(await exists(target), isFalse);
      expect(await exists(other), isTrue);
    });
  });
}
