import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:my_inventory/features/inventory/data/local/app_database.dart';
import 'package:my_inventory/features/inventory/data/local/app_database_provider.dart';
import 'package:my_inventory/main.dart';

void main() {
  testWidgets('在庫一覧画面が起動し、初期状態が表示される', (WidgetTester tester) async {
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

    expect(find.text('在庫一覧'), findsOneWidget);
    expect(find.text('該当するアイテムがありません'), findsOneWidget);

    // ProviderScope破棄時にdriftのストリーム監視がタイマーを予約するため、
    // テスト終了前に明示的に破棄してタイマーを解消しておく
    // （そうしないと "A Timer is still pending" でテストが失敗する）。
    await tester.pumpWidget(const SizedBox());
    await tester.pump(const Duration(milliseconds: 500));
  });
}
