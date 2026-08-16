import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/sub_category.dart';
import '../../domain/exceptions/duplicate_name_exception.dart';
import '../../domain/repositories/sub_category_repository.dart';
import '../local/app_database.dart' as local;
import '../local/app_database_provider.dart';

part 'sub_category_repository_impl.g.dart';

class SubCategoryRepositoryImpl implements SubCategoryRepository {
  SubCategoryRepositoryImpl(this._db);

  final local.AppDatabase _db;

  @override
  Stream<List<SubCategory>> watchSubCategories({int? categoryId}) {
    final query = _db.select(_db.subCategories)
      ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]);
    if (categoryId != null) {
      query.where((t) => t.categoryId.equals(categoryId));
    }
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<int> addSubCategory({
    required int categoryId,
    required String name,
    int sortOrder = 0,
  }) async {
    final existing =
        await (_db.select(_db.subCategories)..where(
          (t) => t.categoryId.equals(categoryId) & t.name.equals(name),
        )).getSingleOrNull();
    if (existing != null) {
      throw DuplicateNameException(name);
    }

    return _db.into(_db.subCategories).insert(
          local.SubCategoriesCompanion.insert(
            categoryId: categoryId,
            name: name,
            sortOrder: Value(sortOrder),
          ),
        );
  }

  @override
  Future<void> updateSubCategory(SubCategory subCategory) async {
    final existing =
        await (_db.select(_db.subCategories)..where(
          (t) =>
              t.categoryId.equals(subCategory.categoryId) &
              t.name.equals(subCategory.name) &
              t.id.equals(subCategory.id).not(),
        )).getSingleOrNull();
    if (existing != null) {
      throw DuplicateNameException(subCategory.name);
    }

    await (_db.update(_db.subCategories)
          ..where((t) => t.id.equals(subCategory.id)))
        .write(
      local.SubCategoriesCompanion(
        categoryId: Value(subCategory.categoryId),
        name: Value(subCategory.name),
        sortOrder: Value(subCategory.sortOrder),
      ),
    );
  }

  @override
  Future<void> deleteSubCategory(int id) {
    return _db.transaction(() async {
      await (_db.update(_db.items)..where((t) => t.subCategoryId.equals(id)))
          .write(const local.ItemsCompanion(subCategoryId: Value(null)));
      await (_db.delete(_db.subCategories)..where((t) => t.id.equals(id))).go();
    });
  }

  SubCategory _toDomain(local.SubCategory row) => SubCategory(
        id: row.id,
        categoryId: row.categoryId,
        name: row.name,
        sortOrder: row.sortOrder,
      );
}

@Riverpod(keepAlive: true)
SubCategoryRepository subCategoryRepository(Ref ref) {
  return SubCategoryRepositoryImpl(ref.watch(appDatabaseProvider));
}
