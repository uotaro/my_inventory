import '../entities/color_option.dart';

abstract class ColorOptionRepository {
  Stream<List<ColorOption>> watchColorOptions({int? colorGroupId});

  Future<int> addColorOption({
    required int colorGroupId,
    required String name,
    String? hexCode,
    int sortOrder = 0,
  });

  Future<void> updateColorOption(ColorOption colorOption);

  /// [sortOrderById]（ID → 新しいsortOrder）を1回のトランザクションでまとめて反映する。
  /// sortOrder以外の列には触れない。途中で失敗した場合は全て元に戻る。
  Future<void> updateSortOrders(Map<int, int> sortOrderById);

  Future<void> deleteColorOption(int id);
}
