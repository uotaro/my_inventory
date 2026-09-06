import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/inventory_type.dart';
import '../../domain/exceptions/duplicate_name_exception.dart';
import '../../domain/exceptions/master_data_in_use_exception.dart';
import '../../domain/repositories/inventory_type_repository.dart';
import '../local/app_database.dart' as local;
import '../local/app_database_provider.dart';

part 'inventory_type_repository_impl.g.dart';

class InventoryTypeRepositoryImpl implements InventoryTypeRepository {
  InventoryTypeRepositoryImpl(this._db);

  final local.AppDatabase _db;

  @override
  Stream<List<InventoryType>> watchInventoryTypes() {
    final query = _db.select(_db.inventoryTypes)
      ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<List<InventoryType>> getInventoryTypes() async {
    final query = _db.select(_db.inventoryTypes)
      ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]);
    final rows = await query.get();
    return rows.map(_toDomain).toList();
  }

  @override
  Future<int> addInventoryType({required String name, int sortOrder = 0}) async {
    final existing =
        await (_db.select(_db.inventoryTypes)..where((t) => t.name.equals(name)))
            .getSingleOrNull();
    if (existing != null) {
      throw DuplicateNameException(name);
    }

    return _db.into(_db.inventoryTypes).insert(
          local.InventoryTypesCompanion.insert(
            name: name,
            sortOrder: Value(sortOrder),
          ),
        );
  }

  @override
  Future<void> updateInventoryType(InventoryType inventoryType) async {
    final existing =
        await (_db.select(_db.inventoryTypes)..where(
          (t) =>
              t.name.equals(inventoryType.name) &
              t.id.equals(inventoryType.id).not(),
        )).getSingleOrNull();
    if (existing != null) {
      throw DuplicateNameException(inventoryType.name);
    }

    await (_db.update(_db.inventoryTypes)
          ..where((t) => t.id.equals(inventoryType.id)))
        .write(
      local.InventoryTypesCompanion(
        name: Value(inventoryType.name),
        sortOrder: Value(inventoryType.sortOrder),
      ),
    );
  }

  @override
  Future<void> deleteInventoryType(int id) async {
    final inventoryType =
        await (_db.select(_db.inventoryTypes)..where((t) => t.id.equals(id)))
            .getSingle();

    final totalCount = _db.inventoryTypes.id.count();
    final totalCountQuery = _db.selectOnly(_db.inventoryTypes)
      ..addColumns([totalCount]);
    final total =
        await totalCountQuery.map((row) => row.read(totalCount) ?? 0).getSingle();
    if (total <= 1) {
      throw const LastInventoryTypeException();
    }

    final categoryCount = _db.categories.id.count();
    final countQuery = _db.selectOnly(_db.categories)
      ..addColumns([categoryCount])
      ..where(_db.categories.inventoryTypeId.equals(id));
    final count =
        await countQuery.map((row) => row.read(categoryCount) ?? 0).getSingle();
    if (count > 0) {
      throw TypeInUseByCategoriesException(inventoryType.name, count);
    }

    await (_db.delete(_db.inventoryTypes)..where((t) => t.id.equals(id))).go();
  }

  InventoryType _toDomain(local.InventoryType row) => InventoryType(
        id: row.id,
        name: row.name,
        sortOrder: row.sortOrder,
      );
}

@Riverpod(keepAlive: true)
InventoryTypeRepository inventoryTypeRepository(Ref ref) {
  return InventoryTypeRepositoryImpl(ref.watch(appDatabaseProvider));
}
