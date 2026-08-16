import '../entities/color_group.dart';

abstract class ColorGroupRepository {
  Stream<List<ColorGroup>> watchColorGroups();

  /// 一覧画面等での継続監視ではなく、ダイアログ表示時などに
  /// 一度だけ取得したい場合に使う（Streamの購読ライフサイクルに依存しない）。
  Future<List<ColorGroup>> getColorGroups();
}
