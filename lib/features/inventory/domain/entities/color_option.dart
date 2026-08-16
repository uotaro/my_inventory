import 'package:freezed_annotation/freezed_annotation.dart';

part 'color_option.freezed.dart';

@freezed
abstract class ColorOption with _$ColorOption {
  const factory ColorOption({
    required int id,
    required int colorGroupId,
    required String name,
    String? hexCode,
    required int sortOrder,
  }) = _ColorOption;
}
