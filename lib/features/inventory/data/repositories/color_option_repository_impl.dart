import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/color_option.dart';
import '../../domain/repositories/color_option_repository.dart';
import '../local/app_database.dart' as local;
import '../local/app_database_provider.dart';

part 'color_option_repository_impl.g.dart';

class ColorOptionRepositoryImpl implements ColorOptionRepository {
  ColorOptionRepositoryImpl(this._db);

  final local.AppDatabase _db;

  @override
  Stream<List<ColorOption>> watchColorOptions({int? colorGroupId}) {
    final query = _db.select(_db.colorOptions)
      ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]);
    if (colorGroupId != null) {
      query.where((t) => t.colorGroupId.equals(colorGroupId));
    }
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<int> addColorOption({
    required int colorGroupId,
    required String name,
    String? hexCode,
    int sortOrder = 0,
  }) {
    return _db.into(_db.colorOptions).insert(
          local.ColorOptionsCompanion.insert(
            colorGroupId: colorGroupId,
            name: name,
            hexCode: Value(hexCode),
            sortOrder: Value(sortOrder),
          ),
        );
  }

  @override
  Future<void> updateColorOption(ColorOption colorOption) {
    return (_db.update(_db.colorOptions)
          ..where((t) => t.id.equals(colorOption.id)))
        .write(
      local.ColorOptionsCompanion(
        colorGroupId: Value(colorOption.colorGroupId),
        name: Value(colorOption.name),
        hexCode: Value(colorOption.hexCode),
        sortOrder: Value(colorOption.sortOrder),
      ),
    );
  }

  @override
  Future<void> deleteColorOption(int id) {
    return _db.transaction(() async {
      await (_db.update(_db.items)..where((t) => t.colorId.equals(id)))
          .write(const local.ItemsCompanion(colorId: Value(null)));
      await (_db.delete(_db.colorOptions)..where((t) => t.id.equals(id))).go();
    });
  }

  ColorOption _toDomain(local.ColorOption row) => ColorOption(
        id: row.id,
        colorGroupId: row.colorGroupId,
        name: row.name,
        hexCode: row.hexCode,
        sortOrder: row.sortOrder,
      );
}

@Riverpod(keepAlive: true)
ColorOptionRepository colorOptionRepository(Ref ref) {
  return ColorOptionRepositoryImpl(ref.watch(appDatabaseProvider));
}
