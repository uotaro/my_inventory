/// [items]（並べ替え対象のグループ）内で [oldIndex] の要素を [newIndex] へ移動し、
/// 変化した要素のみ [persist] でsortOrderを0始まりの連番に更新する。
///
/// ReorderableListViewの新しい`onReorderItem`コールバックは、
/// 使用しているFlutter SDK（3.44.9）では発火しない不具合が確認できたため、
/// 呼び出し側は非推奨だが正しく動作する`onReorder`を使用し、
/// ここでnewIndexの調整を行う。
Future<void> handleReorder<T>({
  required List<T> items,
  required int oldIndex,
  required int newIndex,
  required int Function(T item) sortOrderOf,
  required Future<void> Function(T item, int newSortOrder) persist,
}) async {
  if (newIndex > oldIndex) newIndex -= 1;
  final reordered = List<T>.of(items);
  final moved = reordered.removeAt(oldIndex);
  reordered.insert(newIndex, moved);

  for (var i = 0; i < reordered.length; i++) {
    if (sortOrderOf(reordered[i]) != i) {
      await persist(reordered[i], i);
    }
  }
}
