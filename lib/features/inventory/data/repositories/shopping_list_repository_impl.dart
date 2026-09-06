import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/shopping_list_entry.dart';
import '../../domain/repositories/shopping_list_repository.dart';
import '../local/app_database.dart' as local;
import '../local/app_database_provider.dart';
import 'item_repository_impl.dart';

part 'shopping_list_repository_impl.g.dart';

class ShoppingListRepositoryImpl implements ShoppingListRepository {
  ShoppingListRepositoryImpl(this._db);

  final local.AppDatabase _db;

  JoinedSelectStatement<Object?, Object?> _baseQuery() {
    return _db.select(_db.shoppingListEntries).join([
      innerJoin(
        _db.items,
        _db.items.id.equalsExp(_db.shoppingListEntries.itemId),
      ),
      innerJoin(
        _db.categories,
        _db.categories.id.equalsExp(_db.items.categoryId),
      ),
      innerJoin(
        _db.inventoryTypes,
        _db.inventoryTypes.id.equalsExp(_db.categories.inventoryTypeId),
      ),
      leftOuterJoin(
        _db.subCategories,
        _db.subCategories.id.equalsExp(_db.items.subCategoryId),
      ),
      leftOuterJoin(
        _db.colorOptions,
        _db.colorOptions.id.equalsExp(_db.items.colorId),
      ),
      innerJoin(_db.units, _db.units.id.equalsExp(_db.items.unitId)),
    ]);
  }

  @override
  Stream<List<ShoppingListEntry>> watchShoppingList() {
    final query = _baseQuery()
      ..orderBy([OrderingTerm(expression: _db.shoppingListEntries.createdAt)]);
    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<void> addItem(int itemId) async {
    await _db
        .into(_db.shoppingListEntries)
        .insert(
          local.ShoppingListEntriesCompanion.insert(itemId: itemId),
          mode: InsertMode.insertOrIgnore,
        );
  }

  @override
  Future<void> removeEntry(int entryId) {
    return (_db.delete(
      _db.shoppingListEntries,
    )..where((t) => t.id.equals(entryId))).go();
  }

  @override
  Future<void> removeItemByItemId(int itemId) {
    return (_db.delete(
      _db.shoppingListEntries,
    )..where((t) => t.itemId.equals(itemId))).go();
  }

  @override
  Future<void> setPurchaseQuantity(int entryId, double quantity) {
    final clampedQuantity = quantity < 0 ? 0.0 : quantity;
    return (_db.update(
      _db.shoppingListEntries,
    )..where((t) => t.id.equals(entryId))).write(
      local.ShoppingListEntriesCompanion(
        purchaseQuantity: Value(clampedQuantity),
      ),
    );
  }

  @override
  Future<void> purchaseEntry(int entryId, {String? reason}) {
    return _db.transaction(() async {
      final entry = await (_db.select(
        _db.shoppingListEntries,
      )..where((t) => t.id.equals(entryId))).getSingle();
      await _applyPurchase(entry, reason: reason);
    });
  }

  @override
  Future<void> purchaseAll({String? reason}) {
    return _db.transaction(() async {
      final entries = await (_db.select(
        _db.shoppingListEntries,
      )..where((t) => t.purchaseQuantity.isBiggerThanValue(0))).get();
      for (final entry in entries) {
        await _applyPurchase(entry, reason: reason);
      }
    });
  }

  /// [entry]の購入数をアイテムの在庫数に反映し、在庫ログを残したうえで
  /// 買い物リストから削除する。購入数が0以下の場合は何もしない。
  Future<void> _applyPurchase(
    local.ShoppingListEntry entry, {
    String? reason,
  }) async {
    if (entry.purchaseQuantity <= 0) return;

    final item = await (_db.select(
      _db.items,
    )..where((t) => t.id.equals(entry.itemId))).getSingle();
    final newQuantity = item.quantity + entry.purchaseQuantity;

    await (_db.update(
      _db.items,
    )..where((t) => t.id.equals(entry.itemId))).write(
      local.ItemsCompanion(
        quantity: Value(newQuantity),
        updatedAt: Value(DateTime.now()),
      ),
    );
    await _db
        .into(_db.stockLogs)
        .insert(
          local.StockLogsCompanion.insert(
            itemId: entry.itemId,
            changeAmount: entry.purchaseQuantity,
            reason: Value(reason),
          ),
        );
    await (_db.delete(
      _db.shoppingListEntries,
    )..where((t) => t.id.equals(entry.id))).go();
  }

  ShoppingListEntry _toDomain(TypedResult row) {
    final entryRow = row.readTable(_db.shoppingListEntries);
    return ShoppingListEntry(
      id: entryRow.id,
      item: itemFromRow(_db, row),
      purchaseQuantity: entryRow.purchaseQuantity,
      createdAt: entryRow.createdAt,
    );
  }
}

@Riverpod(keepAlive: true)
ShoppingListRepository shoppingListRepository(Ref ref) {
  return ShoppingListRepositoryImpl(ref.watch(appDatabaseProvider));
}
