# my_inventory

個人用在庫管理アプリ「my在庫（My Inventory）」

不具合報告・お問い合わせは [Issues](https://github.com/uotaro/my_inventory/issues) までお願いします。

## 概要

手芸用品など、自分で用意したカテゴリー・サブカテゴリー・色・単位のマスタデータをもとに、
アイテムごとの在庫数をバーコードスキャンや手入力で増減管理できるFlutterアプリ。
iOS / Android / macOS / Windows / Linux に対応。

## 主な機能

- アイテムの登録・編集・在庫数の増減管理（増減履歴あり）
- カテゴリー・サブカテゴリー・色（カラーグループ／カラーオプション）・単位のマスタデータ管理
- バーコードスキャンによるアイテム登録（`mobile_scanner`）
- バーコード（JANコード）から商品名を自動取得
  - 未キャッシュの場合のみ、Yahoo!ショッピング商品検索API(v3)に問い合わせて取得し、端末内にキャッシュ
- アイテム写真の登録（カメラ撮影・フォトライブラリから選択、画像は端末内保存のみ）
- 日本語・英語ローカライズ対応

## 技術スタック

- **フレームワーク**: Flutter
- **アーキテクチャ**: Clean Architecture（`presentation` → `domain` ← `data`）
- **状態管理**: Riverpod（`flutter_riverpod` + `riverpod_generator`、`@riverpod`によるコード生成方式）
- **モデル定義**: Freezed（Entity / State）
- **ローカルDB**: Drift（SQLite）。マスタデータ・アイテム・在庫増減ログ・商品名キャッシュを端末内に保存
- **多言語対応**: `flutter gen-l10n`（`lib/l10n/app_ja.arb` がベース）

## データの取り扱い

- アイテム情報・マスタデータ・写真は、すべて端末内のSQLite（Drift）・ローカルストレージに保存
- 外部通信は、バーコードスキャン時の商品名取得（Yahoo!ショッピング商品検索API）のみ。送信するのはバーコード番号のみで、個人を特定する情報は送信しない
- 詳細は[プライバシーポリシー](https://uotaro.github.io/my_inventory_privacy_policy/)を参照

## ディレクトリ構成

```
lib/
  core/                     # 共通ユーティリティ、定数、外部リンク設定など
  features/
    inventory/
      data/                 # DataSource, Repository実装, DTO(Freezed)
      domain/               # Entity(Freezed), Repositoryインターフェース, UseCase
      presentation/         # Widget, Riverpod Provider(Notifier), State(Freezed)
  l10n/                     # 多言語リソース（app_ja.arb / app_en.arb）
  main.dart
```

詳細な開発ルール・アーキテクチャ方針は [CLAUDE.md](CLAUDE.md) を参照。

## 開発

```
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter analyze
flutter test
```

- `@freezed` / `@riverpod` の注釈を追加・変更した場合は、必ず `build_runner` を再実行すること
- `.arb` ファイルを変更した場合は、`app_ja.arb` / `app_en.arb` の両方を同時に更新し、`flutter gen-l10n` を実行すること
