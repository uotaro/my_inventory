import 'package:drift/drift.dart';

import 'items_table.dart';

@DataClassName('ShoppingListEntry')
class ShoppingListEntries extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get itemId => integer().references(Items, #id).unique()();
  RealColumn get purchaseQuantity => real().withDefault(const Constant(0))();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
}
