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

  Future<void> deleteColorOption(int id);
}
