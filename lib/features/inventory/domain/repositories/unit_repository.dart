import '../entities/unit.dart';

abstract class UnitRepository {
  Stream<List<Unit>> watchUnits();

  Future<int> addUnit({required String name, int sortOrder = 0});

  Future<void> updateUnit(Unit unit);

  /// [sortOrderById]（ID → 新しいsortOrder）を1回のトランザクションでまとめて反映する。
  /// sortOrder以外の列には触れない。途中で失敗した場合は全て元に戻る。
  Future<void> updateSortOrders(Map<int, int> sortOrderById);

  Future<void> deleteUnit(int id);
}
