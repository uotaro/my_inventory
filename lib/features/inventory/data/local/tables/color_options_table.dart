import 'package:drift/drift.dart';

import 'color_groups_table.dart';

// NOTE: テーブル名を Colors ではなく ColorOptions にしているのは、
// 生成されるデータクラス名が Flutter の dart:ui / material の
// Color クラスと衝突するのを避けるため。
@DataClassName('ColorOption')
class ColorOptions extends Table {
  IntColumn get id => integer().autoIncrement()();
  IntColumn get colorGroupId => integer().references(ColorGroups, #id)();
  TextColumn get name => text().unique()();
  TextColumn get hexCode => text().nullable()();
  IntColumn get sortOrder => integer().withDefault(const Constant(0))();
}
