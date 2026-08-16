import 'package:flutter/widgets.dart';
import 'package:my_inventory/l10n/app_localizations.dart';

/// [ColorGroup.name] には表示言語に依存しない固定キーを保存しており、
/// 実際の表示名はここで現在のロケールに変換する。
/// 未知のキー（想定外データ）の場合はキーの文字列をそのまま返す。
String colorGroupLabel(BuildContext context, String key) {
  final l10n = L10n.of(context);
  switch (key) {
    case 'blue':
      return l10n.colorGroupBlue;
    case 'red':
      return l10n.colorGroupRed;
    case 'green':
      return l10n.colorGroupGreen;
    case 'yellow':
      return l10n.colorGroupYellow;
    case 'monochrome':
      return l10n.colorGroupMonochrome;
    case 'beige_brown':
      return l10n.colorGroupBeigeBrown;
    case 'pattern_other':
      return l10n.colorGroupPatternOther;
    default:
      return key;
  }
}
