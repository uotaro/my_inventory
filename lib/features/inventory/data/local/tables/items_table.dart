import 'package:drift/drift.dart';

import 'categories_table.dart';
import 'color_options_table.dart';
import 'sub_categories_table.dart';
import 'units_table.dart';

@DataClassName('Item')
class Items extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get categoryId => integer().references(Categories, #id)();
  IntColumn get subCategoryId =>
      integer().nullable().references(SubCategories, #id)();
  IntColumn get colorId =>
      integer().nullable().references(ColorOptions, #id)();
  IntColumn get unitId => integer().references(Units, #id)();
  TextColumn get barcode => text().nullable().unique()();
  TextColumn get name => text()();
  IntColumn get favoriteRating => integer().withDefault(const Constant(0))();
  RealColumn get quantity => real().withDefault(const Constant(0))();
  RealColumn get lowStockThreshold => real().nullable()();
  TextColumn get imagePath => text().nullable()();
  TextColumn get memo => text().nullable()();
  DateTimeColumn get createdAt =>
      dateTime().clientDefault(() => DateTime.now())();
  DateTimeColumn get updatedAt =>
      dateTime().clientDefault(() => DateTime.now())();
}
