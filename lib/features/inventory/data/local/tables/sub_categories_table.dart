import 'package:drift/drift.dart';

import 'categories_table.dart';

@DataClassName('SubCategory')
class SubCategories extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  TextColumn get name => text()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}
