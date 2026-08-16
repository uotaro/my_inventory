import 'package:drift/drift.dart';

import 'inventory_types_table.dart';

@DataClassName('Category')
class Categories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get inventoryTypeId =>
      integer().references(InventoryTypes, #id)();
  TextColumn get name => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}
