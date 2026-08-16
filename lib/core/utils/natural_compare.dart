final RegExp _tokenPattern = RegExp(r'\d+|\D+');
final RegExp _numericTokenPattern = RegExp(r'^\d+$');

/// 文字列中の数字部分を数値として比較する自然順（Natural Order）コンパレータ。
/// 例: "item2" と "item10" を通常の文字列比較（辞書順）で比べると
/// "item10" < "item2" になってしまうが、これを "item2" < "item10" の順にする。
int naturalCompare(String a, String b) {
  final aTokens = _tokenPattern.allMatches(a).map((m) => m.group(0)!).toList();
  final bTokens = _tokenPattern.allMatches(b).map((m) => m.group(0)!).toList();

  final length = aTokens.length < bTokens.length ? aTokens.length : bTokens.length;
  for (var i = 0; i < length; i++) {
    final aToken = aTokens[i];
    final bToken = bTokens[i];
    final isNumericPair =
        _numericTokenPattern.hasMatch(aToken) && _numericTokenPattern.hasMatch(bToken);

    final comparison = isNumericPair
        ? (int.parse(aToken)).compareTo(int.parse(bToken))
        : aToken.toLowerCase().compareTo(bToken.toLowerCase());
    if (comparison != 0) return comparison;
  }
  return aTokens.length.compareTo(bTokens.length);
}
