import '../entities/sub_category.dart';

abstract class SubCategoryRepository {
  Stream<List<SubCategory>> watchSubCategories({int? categoryId});

  Future<int> addSubCategory({
    required int categoryId,
    required String name,
    int sortOrder = 0,
  });

  Future<void> updateSubCategory(SubCategory subCategory);

  Future<void> deleteSubCategory(int id);
}
