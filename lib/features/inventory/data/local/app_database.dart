import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';

import 'tables/categories_table.dart';
import 'tables/color_groups_table.dart';
import 'tables/color_options_table.dart';
import 'tables/inventory_types_table.dart';
import 'tables/items_table.dart';
import 'tables/product_name_cache_table.dart';
import 'tables/stock_logs_table.dart';
import 'tables/sub_categories_table.dart';
import 'tables/units_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    InventoryTypes,
    Categories,
    SubCategories,
    ColorGroups,
    ColorOptions,
    Units,
    Items,
    StockLogs,
    ProductNameCache,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  /// テスト用に任意の[QueryExecutor]（インメモリDB等）を注入するコンストラクタ。
  AppDatabase.forTesting(super.executor);

  @override
  int get schemaVersion => 5;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _seedMasterData();
        },
        onUpgrade: (Migrator m, int from, int to) async {
          if (from < 2) {
            await m.createTable(subCategories);
            await m.addColumn(items, items.subCategoryId);
          }
          if (from < 3) {
            await _migrateColorGroupsToLocaleIndependentKeys();
          }
          if (from < 4) {
            await m.addColumn(items, items.favoriteRating);
            await m.dropColumn(items, 'size');
          }
          if (from < 5) {
            await m.createTable(productNameCache);
          }
        },
      );

  /// DBファイルが初めて作られた直後（onCreate）にのみ実行される。
  /// Categories/ColorOptions は FK 必須のため、これが無いと
  /// カテゴリー登録・色登録が最初の1件も作れなくなる。
  ///
  /// colorGroups.name には表示言語に依存しない固定キーを保存し、
  /// 実際の表示名は presentation 層（[colorGroupLabel]）でl10nを介して解決する。
  /// 併せて、初回起動時にすぐ試せるようサンプルのカテゴリー・単位・色も登録する。
  Future<void> _seedMasterData() async {
    final inventoryTypeId = await into(inventoryTypes).insert(
      InventoryTypesCompanion.insert(name: '手芸用品', sortOrder: const Value(0)),
    );

    final colorGroupIds = await _seedColorGroups();
    await _seedSampleCategories(inventoryTypeId);
    await _seedSampleUnits();
    await _seedSampleColors(colorGroupIds);
  }

  Future<Map<String, int>> _seedColorGroups() async {
    const defs = [
      ('blue', 0),
      ('red', 1),
      ('green', 2),
      ('yellow', 3),
      ('monochrome', 4),
      ('beige_brown', 5),
      ('pattern_other', 6),
    ];
    final ids = <String, int>{};
    for (final (key, sortOrder) in defs) {
      ids[key] = await into(colorGroups).insert(
        ColorGroupsCompanion.insert(name: key, sortOrder: Value(sortOrder)),
      );
    }
    return ids;
  }

  /// サンプルのカテゴリー・サブカテゴリー。
  Future<void> _seedSampleCategories(int inventoryTypeId) async {
    const defs = {
      '布': ['フェルト', 'サテン'],
      '糸': ['ミシン糸', '毛糸'],
    };
    var categorySortOrder = 0;
    for (final entry in defs.entries) {
      final categoryId = await into(categories).insert(
        CategoriesCompanion.insert(
          inventoryTypeId: inventoryTypeId,
          name: entry.key,
          sortOrder: Value(categorySortOrder++),
        ),
      );
      var subCategorySortOrder = 0;
      for (final subCategoryName in entry.value) {
        await into(subCategories).insert(
          SubCategoriesCompanion.insert(
            categoryId: categoryId,
            name: subCategoryName,
            sortOrder: Value(subCategorySortOrder++),
          ),
        );
      }
    }
  }

  /// サンプルの単位。
  Future<void> _seedSampleUnits() async {
    const names = ['個', '枚', 'g'];
    for (var i = 0; i < names.length; i++) {
      await into(
        units,
      ).insert(UnitsCompanion.insert(name: names[i], sortOrder: Value(i)));
    }
  }

  /// サンプルの色。各色は既存の色系統（[ColorGroups]）のうち近いものに割り当てる
  /// （オレンジ・ピンクは赤系に分類）。
  Future<void> _seedSampleColors(Map<String, int> colorGroupIds) async {
    const defs = [
      ('白', '#ffffff', 'monochrome'),
      ('黒', '#000000', 'monochrome'),
      ('グレー', '#808080', 'monochrome'),
      ('ダークグレー', '#696969', 'monochrome'),
      ('赤', '#ff0000', 'red'),
      ('青', '#0000ff', 'blue'),
      ('緑', '#008000', 'green'),
      ('黄色', '#ffff00', 'yellow'),
      ('オレンジ', '#ffa500', 'red'),
      ('ピンク', '#ffc0cb', 'red'),
      ('ベージュ', '#f5f5dc', 'beige_brown'),
      ('茶色', '#a52a2a', 'beige_brown'),
    ];
    var sortOrder = 0;
    for (final (name, hexCode, groupKey) in defs) {
      await into(colorOptions).insert(
        ColorOptionsCompanion.insert(
          colorGroupId: colorGroupIds[groupKey]!,
          name: name,
          hexCode: Value(hexCode),
          sortOrder: Value(sortOrder++),
        ),
      );
    }
  }

  /// schemaVersion 2以前は colorGroups.name に日本語の表示名をそのまま
  /// 保存していたが、表示言語に依存しない固定キーへ変更した。
  /// 既存データのキーを変換し、新規追加した「緑系」「黄系」を挿入する。
  Future<void> _migrateColorGroupsToLocaleIndependentKeys() async {
    const legacyNameToKey = {
      '青系': 'blue',
      '赤系': 'red',
      '白黒グレー系': 'monochrome',
      'ベージュ・茶系': 'beige_brown',
      '柄・その他': 'pattern_other',
    };
    const keyToSortOrder = {
      'blue': 0,
      'red': 1,
      'green': 2,
      'yellow': 3,
      'monochrome': 4,
      'beige_brown': 5,
      'pattern_other': 6,
    };

    for (final entry in legacyNameToKey.entries) {
      await (update(colorGroups)..where((t) => t.name.equals(entry.key)))
          .write(ColorGroupsCompanion(name: Value(entry.value)));
    }
    for (final entry in keyToSortOrder.entries) {
      await (update(colorGroups)..where((t) => t.name.equals(entry.key)))
          .write(ColorGroupsCompanion(sortOrder: Value(entry.value)));
    }

    final existingKeys = await (select(
      colorGroups,
    ).map((row) => row.name)).get();
    if (!existingKeys.contains('green')) {
      await into(colorGroups).insert(
        ColorGroupsCompanion.insert(name: 'green', sortOrder: const Value(2)),
      );
    }
    if (!existingKeys.contains('yellow')) {
      await into(colorGroups).insert(
        ColorGroupsCompanion.insert(
          name: 'yellow',
          sortOrder: const Value(3),
        ),
      );
    }
  }

  static QueryExecutor _openConnection() {
    return driftDatabase(name: 'inventory_manager');
  }
}
