import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/stock_log.dart';
import '../../domain/repositories/stock_log_repository.dart';
import '../local/app_database.dart' as local;
import '../local/app_database_provider.dart';

part 'stock_log_repository_impl.g.dart';

class StockLogRepositoryImpl implements StockLogRepository {
  StockLogRepositoryImpl(this._db);

  final local.AppDatabase _db;

  @override
  Stream<List<StockLog>> watchLogsForItem(int itemId) {
    final query = _db.select(_db.stockLogs)
      ..where((t) => t.itemId.equals(itemId))
      ..orderBy([
        (t) => OrderingTerm(expression: t.createdAt, mode: OrderingMode.desc),
      ]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  StockLog _toDomain(local.StockLog row) => StockLog(
        id: row.id,
        itemId: row.itemId,
        changeAmount: row.changeAmount,
        reason: row.reason,
        createdAt: row.createdAt,
      );
}

@Riverpod(keepAlive: true)
StockLogRepository stockLogRepository(Ref ref) {
  return StockLogRepositoryImpl(ref.watch(appDatabaseProvider));
}
