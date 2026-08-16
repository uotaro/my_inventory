import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../data/repositories/category_repository_impl.dart';
import '../../data/repositories/color_group_repository_impl.dart';
import '../../data/repositories/color_option_repository_impl.dart';
import '../../data/repositories/sub_category_repository_impl.dart';
import '../../data/repositories/unit_repository_impl.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/color_group.dart';
import '../../domain/entities/color_option.dart';
import '../../domain/entities/sub_category.dart';
import '../../domain/entities/unit.dart';

part 'master_data_providers.g.dart';

// MVP時点では InventoryType は「手芸用品」の1件のみ運用のため、
// カテゴリー一覧は inventoryTypeId で絞り込まずに全件表示している。
// InventoryType自体は画面から継続監視されないため一覧Providerを持たず、
// 必要な箇所（マスタ追加ダイアログ）では
// InventoryTypeRepository.getInventoryTypes() を直接使う。
//
// 以下は全て keepAlive: true にしている。デフォルトのautoDisposeのままだと、
// マスタ追加ダイアログ（add_master_data_dialogs.dart）のように「画面には
// ref.watch されておらず ref.read(...future) だけで一時的に読む」呼び出しで、
// ストリームの初回値が届く前にプロバイダが破棄され
// 「disposed during loading state」例外になる（実際に発生した不具合）。
@Riverpod(keepAlive: true)
Stream<List<Category>> categoryList(Ref ref) {
  return ref.watch(categoryRepositoryProvider).watchCategories();
}

@Riverpod(keepAlive: true)
Stream<List<SubCategory>> subCategoryList(Ref ref, {int? categoryId}) {
  return ref
      .watch(subCategoryRepositoryProvider)
      .watchSubCategories(categoryId: categoryId);
}

@Riverpod(keepAlive: true)
Stream<List<ColorGroup>> colorGroupList(Ref ref) {
  return ref.watch(colorGroupRepositoryProvider).watchColorGroups();
}

@Riverpod(keepAlive: true)
Stream<List<ColorOption>> colorOptionList(Ref ref) {
  return ref.watch(colorOptionRepositoryProvider).watchColorOptions();
}

@Riverpod(keepAlive: true)
Stream<List<Unit>> unitList(Ref ref) {
  return ref.watch(unitRepositoryProvider).watchUnits();
}
