import '../entities/inventory_type.dart';

abstract class InventoryTypeRepository {
  Stream<List<InventoryType>> watchInventoryTypes();

  /// 一覧画面等での継続監視ではなく、ダイアログ表示時などに
  /// 一度だけ取得したい場合に使う（Streamの購読ライフサイクルに依存しない）。
  Future<List<InventoryType>> getInventoryTypes();
}
