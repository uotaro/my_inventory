import 'package:drift/drift.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities/category.dart';
import '../../domain/entities/color_option.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/sub_category.dart';
import '../../domain/entities/unit.dart';
import '../../domain/repositories/item_repository.dart';
import '../local/app_database.dart' as local;
import '../local/app_database_provider.dart';
import '../local/item_image_storage.dart';

part 'item_repository_impl.g.dart';

class ItemRepositoryImpl implements ItemRepository {
  ItemRepositoryImpl(this._db);

  final local.AppDatabase _db;

  JoinedSelectStatement<Object?, Object?> _baseQuery() {
    return _db.select(_db.items).join([
      innerJoin(
        _db.categories,
        _db.categories.id.equalsExp(_db.items.categoryId),
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
  Stream<List<Item>> watchItems({
    int? categoryId,
    int? subCategoryId,
    int? colorGroupId,
    double? minQuantity,
  }) {
    final query = _baseQuery();

    if (categoryId != null) {
      query.where(_db.items.categoryId.equals(categoryId));
    }
    if (subCategoryId != null) {
      query.where(_db.items.subCategoryId.equals(subCategoryId));
    }
    if (colorGroupId != null) {
      query.where(_db.colorOptions.colorGroupId.equals(colorGroupId));
    }
    if (minQuantity != null) {
      query.where(_db.items.quantity.isBiggerOrEqualValue(minQuantity));
    }
    query.orderBy([OrderingTerm(expression: _db.items.name)]);

    return query.watch().map((rows) => rows.map(_toDomain).toList());
  }

  @override
  Future<Item?> findByBarcode(String barcode) async {
    final query = _baseQuery()..where(_db.items.barcode.equals(barcode));
    final row = await query.getSingleOrNull();
    return row == null ? null : _toDomain(row);
  }

  @override
  Future<int> addItem({
    required int categoryId,
    int? subCategoryId,
    int? colorId,
    required int unitId,
    String? barcode,
    required String name,
    int favoriteRating = 0,
    double quantity = 0,
    double? lowStockThreshold,
    String? imagePath,
    String? memo,
  }) {
    return _db.into(_db.items).insert(
          local.ItemsCompanion.insert(
            categoryId: categoryId,
            subCategoryId: Value(subCategoryId),
            colorId: Value(colorId),
            unitId: unitId,
            barcode: Value(barcode),
            name: name,
            favoriteRating: Value(favoriteRating),
            quantity: Value(quantity),
            lowStockThreshold: Value(lowStockThreshold),
            imagePath: Value(imagePath),
            memo: Value(memo),
          ),
        );
  }

  @override
  Future<void> updateItem(Item item) async {
    final previous = await (_db.select(
      _db.items,
    )..where((t) => t.id.equals(item.id))).getSingle();

    await (_db.update(_db.items)..where((t) => t.id.equals(item.id))).write(
      local.ItemsCompanion(
        categoryId: Value(item.category.id),
        subCategoryId: Value(item.subCategory?.id),
        colorId: Value(item.color?.id),
        unitId: Value(item.unit.id),
        barcode: Value(item.barcode),
        name: Value(item.name),
        favoriteRating: Value(item.favoriteRating),
        quantity: Value(item.quantity),
        lowStockThreshold: Value(item.lowStockThreshold),
        imagePath: Value(item.imagePath),
        memo: Value(item.memo),
        updatedAt: Value(DateTime.now()),
      ),
    );

    if (previous.imagePath != null && previous.imagePath != item.imagePath) {
      await deleteItemImageIfExists(previous.imagePath);
    }
  }

  @override
  Future<void> deleteItem(int id) async {
    final item = await (_db.select(
      _db.items,
    )..where((t) => t.id.equals(id))).getSingle();

    await (_db.delete(_db.items)..where((t) => t.id.equals(id))).go();
    await deleteItemImageIfExists(item.imagePath);
  }

  @override
  Future<void> adjustQuantity(
    int itemId,
    double changeAmount, {
    String? reason,
  }) {
    return _db.transaction(() async {
      final item = await (_db.select(
        _db.items,
      )..where((t) => t.id.equals(itemId))).getSingle();

      // 在庫数はマイナスにはならない（消費数が現在庫を超える場合は0で頭打ち）。
      final newQuantity = item.quantity + changeAmount;
      final clampedQuantity = newQuantity < 0 ? 0.0 : newQuantity;
      final appliedChangeAmount = clampedQuantity - item.quantity;
      if (appliedChangeAmount == 0) return;

      await (_db.update(_db.items)..where((t) => t.id.equals(itemId))).write(
        local.ItemsCompanion(
          quantity: Value(clampedQuantity),
          updatedAt: Value(DateTime.now()),
        ),
      );

      await _db.into(_db.stockLogs).insert(
            local.StockLogsCompanion.insert(
              itemId: itemId,
              changeAmount: appliedChangeAmount,
              reason: Value(reason),
            ),
          );
    });
  }

  Item _toDomain(TypedResult row) {
    final itemRow = row.readTable(_db.items);
    final categoryRow = row.readTable(_db.categories);
    final subCategoryRow = row.readTableOrNull(_db.subCategories);
    final colorRow = row.readTableOrNull(_db.colorOptions);
    final unitRow = row.readTable(_db.units);

    return Item(
      id: itemRow.id,
      category: Category(
        id: categoryRow.id,
        inventoryTypeId: categoryRow.inventoryTypeId,
        name: categoryRow.name,
        sortOrder: categoryRow.sortOrder,
      ),
      subCategory: subCategoryRow == null
          ? null
          : SubCategory(
              id: subCategoryRow.id,
              categoryId: subCategoryRow.categoryId,
              name: subCategoryRow.name,
              sortOrder: subCategoryRow.sortOrder,
            ),
      color: colorRow == null
          ? null
          : ColorOption(
              id: colorRow.id,
              colorGroupId: colorRow.colorGroupId,
              name: colorRow.name,
              hexCode: colorRow.hexCode,
              sortOrder: colorRow.sortOrder,
            ),
      unit: Unit(id: unitRow.id, name: unitRow.name, sortOrder: unitRow.sortOrder),
      barcode: itemRow.barcode,
      name: itemRow.name,
      favoriteRating: itemRow.favoriteRating,
      quantity: itemRow.quantity,
      lowStockThreshold: itemRow.lowStockThreshold,
      imagePath: itemRow.imagePath,
      memo: itemRow.memo,
      createdAt: itemRow.createdAt,
      updatedAt: itemRow.updatedAt,
    );
  }
}

@Riverpod(keepAlive: true)
ItemRepository itemRepository(Ref ref) {
  return ItemRepositoryImpl(ref.watch(appDatabaseProvider));
}
