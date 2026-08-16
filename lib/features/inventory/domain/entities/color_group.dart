import 'package:freezed_annotation/freezed_annotation.dart';

part 'color_group.freezed.dart';

@freezed
abstract class ColorGroup with _$ColorGroup {
  const factory ColorGroup({
    required int id,
    required String name,
    required int sortOrder,
  }) = _ColorGroup;
}
