import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/color_group.dart';
import '../../domain/repositories/color_group_repository.dart';
import '../local/app_database.dart' as local;
import '../local/app_database_provider.dart';

part 'color_group_repository_impl.g.dart';

class ColorGroupRepositoryImpl implements ColorGroupRepository {
  ColorGroupRepositoryImpl(this._db);

  final local.AppDatabase _db;

  @override
  Stream<List<ColorGroup>> watchColorGroups() {
    final query = _db.select(_db.colorGroups)
      ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<List<ColorGroup>> getColorGroups() async {
    final query = _db.select(_db.colorGroups)
      ..orderBy([(t) => OrderingTerm(expression: t.sortOrder)]);
    final rows = await query.get();
    return rows.map(_toDomain).toList();
  }

  ColorGroup _toDomain(local.ColorGroup row) => ColorGroup(
        id: row.id,
        name: row.name,
        sortOrder: row.sortOrder,
      );
}

@Riverpod(keepAlive: true)
ColorGroupRepository colorGroupRepository(Ref ref) {
  return ColorGroupRepositoryImpl(ref.watch(appDatabaseProvider));
}
