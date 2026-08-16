import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/unit.dart';
import '../../domain/exceptions/master_data_in_use_exception.dart';
import '../../domain/repositories/unit_repository.dart';
import '../local/app_database.dart' as local;
import '../local/app_database_provider.dart';

part 'unit_repository_impl.g.dart';

class UnitRepositoryImpl implements UnitRepository {
  UnitRepositoryImpl(this._db);

  final local.AppDatabase _db;

  @override
  Stream<List<Unit>> watchUnits() {
    final query = _db.select(_db.units)
      ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<int> addUnit({required String name, int sortOrder = 0}) {
    return _db.into(_db.units).insert(
          local.UnitsCompanion.insert(name: name, sortOrder: Value(sortOrder)),
        );
  }

  @override
  Future<void> updateUnit(Unit unit) {
    return (_db.update(_db.units)..where((t) => t.id.equals(unit.id))).write(
      local.UnitsCompanion(
        name: Value(unit.name),
        sortOrder: Value(unit.sortOrder),
      ),
    );
  }

  @override
  Future<void> deleteUnit(int id) async {
    final unit =
        await (_db.select(_db.units)..where((t) => t.id.equals(id)))
            .getSingle();

    final itemCount = _db.items.id.count();
    final countQuery = _db.selectOnly(_db.items)
      ..addColumns([itemCount])
      ..where(_db.items.unitId.equals(id));
    final count = await countQuery.map((row) => row.read(itemCount) ?? 0).getSingle();
    if (count > 0) {
      throw MasterDataInUseException(unit.name, count);
    }

    await (_db.delete(_db.units)..where((t) => t.id.equals(id))).go();
  }

  Unit _toDomain(local.Unit row) => Unit(
        id: row.id,
        name: row.name,
        sortOrder: row.sortOrder,
      );
}

@Riverpod(keepAlive: true)
UnitRepository unitRepository(Ref ref) {
  return UnitRepositoryImpl(ref.watch(appDatabaseProvider));
}
