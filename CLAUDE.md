# CLAUDE.md

## コミュニケーション
- やり取りは常に**日本語**で行うこと。コード中のコメント・commit メッセージも日本語で統一する。
- 実装方針に複数の選択肢がある場合は、実装前に日本語で簡潔に確認すること。

## プロジェクト概要
- Flutter 製の在庫管理アプリ「my在庫（My Inventory）」（パッケージ名: my_inventory）。
- 状態管理: Riverpod（`flutter_riverpod` + `riverpod_annotation` + `riverpod_generator`）
- アーキテクチャ: Clean Architecture
- モデル定義: Freezed（`freezed` + `freezed_annotation`）

## アーキテクチャ（Clean Architecture）
`lib/` 配下は以下の層構造を厳守すること。新しい機能を追加する際も、この構造を崩さずに従うこと。

```
lib/
  core/                     # 共通ユーティリティ、定数、例外、DIの土台など
  features/
    <feature_name>/
      data/                 # DataSource, Repository実装, DTO(Freezed)
      domain/               # Entity(Freezed), Repositoryインターフェース, UseCase
      presentation/         # Widget, Riverpod Provider(Notifier), State(Freezed)
  l10n/                     # 多言語リソース（既存のarbファイル群）
  main.dart
```

- 依存の向きは `presentation -> domain <- data` を厳守（domain は他層に依存しない）。
- 既存のフォルダ構造・命名規則を変更する提案は行わない。新規ファイルは既存構造に合わせて配置すること。

## 状態管理（Riverpod）
- Provider/Notifier は `riverpod_generator` を使ったコード生成方式（`@riverpod` アノテーション）で統一する。手書きの `StateNotifierProvider` 等は新規に追加しない。
- `ref.watch` / `ref.read` の使い分けはRiverpodの一般的なベストプラクティスに従う。

## データモデル（Freezed）
- Entity・DTO・State クラスは Freezed を使用して定義する（`@freezed`）。
- JSON変換が必要なモデルは `freezed` + `json_serializable` を併用する。

## コード生成（build_runner）
- `@freezed` / `@riverpod` 等の注釈を追加・変更した場合、必ず build_runner を実行して生成物を最新化すること。
  ```
  dart run build_runner build --delete-conflicting-outputs
  ```
- 生成ファイル（`*.freezed.dart`, `*.g.dart`）を手動で編集しない。

## 多言語対応（l10n）
- 翻訳リソースは `lib/l10n/` 配下（`app_ja.arb` がベースファイル）。
- 文言を追加・変更する場合は、**`lib/l10n/` 配下の全ての `.arb` ファイルを必ず同時に更新すること**（1言語だけの更新は禁止）。
- `.arb` 更新後は `flutter gen-l10n` を実行し、生成物（`app_localizations*.dart`）を最新化する。

## よく使うコマンド
```
flutter pub get
dart run build_runner build --delete-conflicting-outputs
flutter gen-l10n
flutter analyze
flutter test
```
