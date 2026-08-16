import '../entities/category.dart';

abstract class CategoryRepository {
  Stream<List<Category>> watchCategories({int? inventoryTypeId});

  Future<int> addCategory({
    required int inventoryTypeId,
    required String name,
    int sortOrder = 0,
  });

  Future<void> updateCategory(Category category);

  Future<void> deleteCategory(int id);
}
