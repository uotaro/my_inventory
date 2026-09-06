import '../entities/item.dart';

abstract class ItemRepository {
  /// [inventoryTypeId] / [categoryId] / [subCategoryId] / [colorGroupId] を指定すると絞り込み検索になる。
  /// 例: 「布(categoryId)で青系(colorGroupId)のアイテム」
  Stream<List<Item>> watchItems({
    int? inventoryTypeId,
    int? categoryId,
    int? subCategoryId,
    int? colorGroupId,
  });

  Future<Item?> findByBarcode(String barcode);

  Future<int> addItem({
    required int categoryId,
    int? subCategoryId,
    int? colorId,
    required int unitId,
    String? barcode,
    required String name,
    int favoriteRating = 0,
    double quantity = 0,
    double lowStockThreshold = 0,
    String? imagePath,
    String? memo,
  });

  Future<void> updateItem(Item item);

  Future<void> deleteItem(int id);

  /// 在庫数を増減し、同時に stock_logs に履歴を1件残す（購入: 正の値 / 消費: 負の値）。
  Future<void> adjustQuantity(int itemId, double changeAmount, {String? reason});
}
