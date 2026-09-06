import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_inventory/features/inventory/data/local/app_database.dart';
import 'package:my_inventory/features/inventory/data/local/app_database_provider.dart';
import 'package:my_inventory/main.dart';

Future<void> _pumpApp(WidgetTester tester) async {
  tester.platformDispatcher.localeTestValue = const Locale('ja');
  tester.platformDispatcher.localesTestValue = const [Locale('ja')];
  addTearDown(tester.platformDispatcher.clearLocaleTestValue);
  addTearDown(tester.platformDispatcher.clearLocalesTestValue);

  await tester.pumpWidget(
    ProviderScope(
      overrides: [
        appDatabaseProvider.overrideWith((ref) {
          final database = AppDatabase.forTesting(NativeDatabase.memory());
          ref.onDispose(database.close);
          return database;
        }),
      ],
      child: const MyApp(),
    ),
  );
  await tester.pumpAndSettle();
}

/// ProviderScope破棄時にdriftのストリーム監視がタイマーを予約するため、
/// テスト終了前に明示的に破棄してタイマーを解消しておく
/// （そうしないと "A Timer is still pending" でテストが失敗する）。
Future<void> _disposeApp(WidgetTester tester) async {
  await tester.pumpWidget(const SizedBox());
  await tester.pump(const Duration(milliseconds: 500));
}

void main() {
  testWidgets('在庫一覧画面が起動し、初期状態が表示される', (WidgetTester tester) async {
    await _pumpApp(tester);

    expect(find.text('在庫一覧'), findsOneWidget);
    expect(find.text('該当するアイテムがありません'), findsOneWidget);
    // 大分類・中分類・小分類の3階層フィルタが一覧画面に並んでいる。
    expect(find.text('大分類'), findsOneWidget);
    expect(find.text('中分類'), findsOneWidget);
    expect(find.text('小分類'), findsOneWidget);

    await _disposeApp(tester);
  });

  testWidgets('商品登録画面に大分類ドロップダウンが表示され、デフォルトの種別1が選択されている', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pumpAndSettle();

    expect(find.text('アイテムを登録'), findsOneWidget);
    expect(find.text('大分類 *'), findsOneWidget);
    expect(find.text('種別1'), findsOneWidget);

    await _disposeApp(tester);
  });

  testWidgets('マスタ管理画面に大分類タブがあり、デフォルトの種別1を編集・削除できる', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester);

    await tester.tap(find.byIcon(Icons.settings_outlined));
    await tester.pumpAndSettle();

    expect(find.text('マスタ管理'), findsOneWidget);
    await tester.tap(find.text('大分類'));
    await tester.pumpAndSettle();

    expect(find.text('種別1'), findsOneWidget);
    expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
    expect(find.byIcon(Icons.delete_outline), findsOneWidget);

    await _disposeApp(tester);
  });

  testWidgets('在庫一覧画面の「在庫」ドロップダウンに4つの選択肢が表示される', (
    WidgetTester tester,
  ) async {
    await _pumpApp(tester);

    expect(find.text('在庫'), findsOneWidget);
    expect(find.text('在庫ありのみ表示'), findsNothing);

    await tester.tap(find.text('すべて').last);
    await tester.pumpAndSettle();

    expect(find.text('在庫あり'), findsOneWidget);
    expect(find.text('在庫不足'), findsOneWidget);
    expect(find.text('在庫0'), findsOneWidget);

    await _disposeApp(tester);
  });
}
