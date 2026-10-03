import '../entities/category.dart';

abstract class CategoryRepository {
  Stream<List<Category>> watchCategories({int? inventoryTypeId});

  Future<int> addCategory({
    required int inventoryTypeId,
    required String name,
    int sortOrder = 0,
  });

  Future<void> updateCategory(Category category);

  /// [sortOrderById]（ID → 新しいsortOrder）を1回のトランザクションでまとめて反映する。
  /// sortOrder以外の列には触れない。途中で失敗した場合は全て元に戻る。
  Future<void> updateSortOrders(Map<int, int> sortOrderById);

  Future<void> deleteCategory(int id);
}
