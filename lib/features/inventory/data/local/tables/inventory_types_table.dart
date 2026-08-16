import 'package:drift/drift.dart';

@DataClassName('InventoryType')
class InventoryTypes extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}
