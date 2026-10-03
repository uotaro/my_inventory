import 'package:flutter_test/flutter_test.dart';
import 'package:my_inventory/features/inventory/presentation/widgets/reorder_helper.dart';

typedef _Row = ({int id, int sortOrder});

void main() {
  List<_Row> rows(List<int> sortOrders) => [
    for (var i = 0; i < sortOrders.length; i++)
      (id: i + 1, sortOrder: sortOrders[i]),
  ];

  /// [handleReorder] を実行し、persistに渡されたマップの一覧（呼び出し回数分）を返す。
  Future<List<Map<int, int>>> reorder(
    List<_Row> items, {
    required int oldIndex,
    required int newIndex,
  }) async {
    final calls = <Map<int, int>>[];
    await handleReorder<_Row>(
      items: items,
      oldIndex: oldIndex,
      newIndex: newIndex,
      idOf: (r) => r.id,
      sortOrderOf: (r) => r.sortOrder,
      persist: (sortOrderById) async => calls.add(sortOrderById),
    );
    return calls;
  }

  test('先頭を末尾へ移動すると、全要素の新しいsortOrderを1回のpersistでまとめて渡す', () async {
    // newIndexはFlutterの仕様で「移動先の1つ後ろ」を指す（末尾へ移動なら要素数）。
    final calls = await reorder(rows([0, 1, 2]), oldIndex: 0, newIndex: 3);

    expect(calls, [
      {2: 0, 3: 1, 1: 2},
    ]);
  });

  test('末尾を先頭へ移動すると、全要素の新しいsortOrderをまとめて渡す', () async {
    final calls = await reorder(rows([0, 1, 2]), oldIndex: 2, newIndex: 0);

    expect(calls, [
      {3: 0, 1: 1, 2: 2},
    ]);
  });

  test('sortOrderが変わらない要素はpersistに含めない', () async {
    // [1,2,3,4] のうち3を末尾へ移動 → [1,2,4,3]。変わるのは4と3だけ。
    final calls = await reorder(rows([0, 1, 2, 3]), oldIndex: 2, newIndex: 4);

    expect(calls, [
      {4: 2, 3: 3},
    ]);
  });

  test('元の位置へ戻す操作ではpersistを呼ばない', () async {
    expect(await reorder(rows([0, 1, 2]), oldIndex: 1, newIndex: 1), isEmpty);
    // 自分の直後（newIndex = oldIndex + 1）も元の位置。
    expect(await reorder(rows([0, 1, 2]), oldIndex: 1, newIndex: 2), isEmpty);
  });

  test('sortOrderが連番でない場合も、0始まりの連番に揃えて渡す', () async {
    final calls = await reorder(rows([5, 7, 9]), oldIndex: 0, newIndex: 2);

    expect(calls, [
      {2: 0, 1: 1, 3: 2},
    ]);
  });
}
