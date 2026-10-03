/// [items]（並べ替え対象のグループ）内で [oldIndex] の要素を [newIndex] へ移動し、
/// sortOrderが変化した要素だけを「ID → 新しいsortOrder（0始まりの連番）」の
/// マップにまとめて、[persist] を1回だけ呼び出す。
///
/// 1件ずつ保存すると、保存のたびにDBのStreamが流れて一覧が再構築され、
/// 途中で失敗すると一部だけ更新された状態が残る。[persist] 側で
/// 1トランザクションにまとめることで、これらを避ける。
///
/// ReorderableListViewの新しい`onReorderItem`コールバックは、
/// 使用しているFlutter SDK（3.44.9）では発火しない不具合が確認できたため、
/// 呼び出し側は非推奨だが正しく動作する`onReorder`を使用し、
/// ここでnewIndexの調整を行う。
Future<void> handleReorder<T>({
  required List<T> items,
  required int oldIndex,
  required int newIndex,
  required int Function(T item) idOf,
  required int Function(T item) sortOrderOf,
  required Future<void> Function(Map<int, int> sortOrderById) persist,
}) async {
  if (newIndex > oldIndex) newIndex -= 1;
  final reordered = List<T>.of(items);
  final moved = reordered.removeAt(oldIndex);
  reordered.insert(newIndex, moved);

  final changes = <int, int>{
    for (var i = 0; i < reordered.length; i++)
      if (sortOrderOf(reordered[i]) != i) idOf(reordered[i]): i,
  };
  if (changes.isEmpty) return;
  await persist(changes);
}
