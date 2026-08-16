import 'dart:async';

import 'package:my_inventory/features/inventory/data/local/item_image_storage.dart';
import 'package:my_inventory/features/inventory/presentation/screens/item_list_screen.dart';
import 'package:my_inventory/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // 初回フレーム表示をブロックしないよう、runApp を待たせずに並行して行う。
  unawaited(warmUpItemImagesDirectory());
  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: L10n.localizationsDelegates,
      supportedLocales: L10n.supportedLocales,
      onGenerateTitle: (context) => L10n.of(context).appTitle,
      theme: ThemeData(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueGrey),
      ),
      home: const ItemListScreen(),
    );
  }
}
