import 'package:drift/drift.dart';

@DataClassName('ColorGroup')
class ColorGroups extends Table {
  IntColumn get id => integer().autoIncrement()();
  TextColumn get name => text().unique()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}
