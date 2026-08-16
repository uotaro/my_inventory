import '../entities/stock_log.dart';

abstract class StockLogRepository {
  /// 特定アイテムの増減履歴を新しい順で返す。
  /// 書き込みは ItemRepository.adjustQuantity 経由で行う（在庫数の更新とアトミックにするため）。
  Stream<List<StockLog>> watchLogsForItem(int itemId);
}
