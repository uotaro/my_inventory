import '../entities/shopping_list_entry.dart';

abstract class ShoppingListRepository {
  Stream<List<ShoppingListEntry>> watchShoppingList();

  /// 既に追加済みの場合は何もしない。
  Future<void> addItem(int itemId);

  Future<void> removeEntry(int entryId);

  /// アイテムIDを指定して買い物リストから除外する。
  /// 購入数がセットされていても在庫には反映しない。
  Future<void> removeItemByItemId(int itemId);

  Future<void> setPurchaseQuantity(int entryId, double quantity);

  /// 該当エントリの購入数をアイテムの在庫数に反映し、買い物リストから削除する。
  /// 購入数が0の場合は何もしない。
  Future<void> purchaseEntry(int entryId, {String? reason});

  /// 購入数が0より大きい全エントリに対して[purchaseEntry]相当の処理を行う。
  Future<void> purchaseAll({String? reason});
}
