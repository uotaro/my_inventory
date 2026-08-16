import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/inventory_type.dart';
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
