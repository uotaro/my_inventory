import '../entities/sub_category.dart';

abstract class SubCategoryRepository {
  Stream<List<SubCategory>> watchSubCategories({int? categoryId});

  Future<int> addSubCategory({
    required int categoryId,
    required String name,
    int sortOrder = 0,
  });

  Future<void> updateSubCategory(SubCategory subCategory);

  /// [sortOrderById]（ID → 新しいsortOrder）を1回のトランザクションでまとめて反映する。
  /// sortOrder以外の列には触れない。途中で失敗した場合は全て元に戻る。
  Future<void> updateSortOrders(Map<int, int> sortOrderById);

  Future<void> deleteSubCategory(int id);
}
