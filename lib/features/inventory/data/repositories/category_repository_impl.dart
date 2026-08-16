import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/category.dart';
import '../../domain/exceptions/duplicate_name_exception.dart';
import '../../domain/exceptions/master_data_in_use_exception.dart';
import '../../domain/repositories/category_repository.dart';
import '../local/app_database.dart' as local;
import '../local/app_database_provider.dart';

part 'category_repository_impl.g.dart';

class CategoryRepositoryImpl implements CategoryRepository {
  CategoryRepositoryImpl(this._db);

  final local.AppDatabase _db;

  @override
  Stream<List<Category>> watchCategories({int? inventoryTypeId}) {
    final query = _db.select(_db.categories)
      ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]);
    if (inventoryTypeId != null) {
      query.where((t) => t.inventoryTypeId.equals(inventoryTypeId));
    }
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<int> addCategory({
    required int inventoryTypeId,
    required String name,
    int sortOrder = 0,
  }) async {
    final existing =
        await (_db.select(_db.categories)..where(
          (t) => t.inventoryTypeId.equals(inventoryTypeId) & t.name.equals(name),
        )).getSingleOrNull();
    if (existing != null) {
      throw DuplicateNameException(name);
    }

    return _db.into(_db.categories).insert(
          local.CategoriesCompanion.insert(
            inventoryTypeId: inventoryTypeId,
            name: name,
            sortOrder: Value(sortOrder),
          ),
        );
  }

  @override
  Future<void> updateCategory(Category category) async {
    final existing =
        await (_db.select(_db.categories)..where(
          (t) =>
              t.inventoryTypeId.equals(category.inventoryTypeId) &
              t.name.equals(category.name) &
              t.id.equals(category.id).not(),
        )).getSingleOrNull();
    if (existing != null) {
      throw DuplicateNameException(category.name);
    }

    await (_db.update(_db.categories)
          ..where((t) => t.id.equals(category.id)))
        .write(
      local.CategoriesCompanion(
        inventoryTypeId: Value(category.inventoryTypeId),
        name: Value(category.name),
        sortOrder: Value(category.sortOrder),
      ),
    );
  }

  @override
  Future<void> deleteCategory(int id) async {
    final category =
        await (_db.select(_db.categories)..where((t) => t.id.equals(id)))
            .getSingle();

    final itemCount = _db.items.id.count();
    final countQuery = _db.selectOnly(_db.items)
      ..addColumns([itemCount])
      ..where(_db.items.categoryId.equals(id));
    final count = await countQuery.map((row) => row.read(itemCount) ?? 0).getSingle();
    if (count > 0) {
      throw MasterDataInUseException(category.name, count);
    }

    await (_db.delete(_db.categories)..where((t) => t.id.equals(id))).go();
  }

  Category _toDomain(local.Category row) => Category(
        id: row.id,
        inventoryTypeId: row.inventoryTypeId,
        name: row.name,
        sortOrder: row.sortOrder,
      );
}

@Riverpod(keepAlive: true)
CategoryRepository categoryRepository(Ref ref) {
  return CategoryRepositoryImpl(ref.watch(appDatabaseProvider));
}
