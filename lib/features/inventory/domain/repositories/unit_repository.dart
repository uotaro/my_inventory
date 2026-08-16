import '../entities/unit.dart';

abstract class UnitRepository {
  Stream<List<Unit>> watchUnits();

  Future<int> addUnit({required String name, int sortOrder = 0});

  Future<void> updateUnit(Unit unit);

  Future<void> deleteUnit(int id);
}
