import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ja.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of L10n
/// returned by `L10n.of(context)`.
///
/// Applications need to include `L10n.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: L10n.localizationsDelegates,
///   supportedLocales: L10n.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the L10n.supportedLocales
/// property.
abstract class L10n {
  L10n(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n)!;
  }

  static const LocalizationsDelegate<L10n> delegate = _L10nDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ja'),
  ];

  /// アプリ名（タスク切替画面などに表示）
  ///
  /// In ja, this message translates to:
  /// **'my在庫'**
  String get appTitle;

  /// キャンセル操作の共通ボタンラベル
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get cancel;

  /// 削除操作の共通ボタンラベル
  ///
  /// In ja, this message translates to:
  /// **'削除'**
  String get delete;

  /// 保存操作の共通ボタンラベル
  ///
  /// In ja, this message translates to:
  /// **'保存'**
  String get save;

  /// 追加操作の共通ボタンラベル
  ///
  /// In ja, this message translates to:
  /// **'追加'**
  String get add;

  /// 確認ダイアログのOKボタンラベル
  ///
  /// In ja, this message translates to:
  /// **'OK'**
  String get ok;

  /// エラーダイアログのタイトル
  ///
  /// In ja, this message translates to:
  /// **'CAUTION'**
  String get errorTitle;

  /// 削除確認ダイアログのタイトル
  ///
  /// In ja, this message translates to:
  /// **'削除の確認'**
  String get confirmDeleteTitle;

  /// 分類・色などが未設定であることを示すラベル
  ///
  /// In ja, this message translates to:
  /// **'未設定'**
  String get unset;

  /// 絞り込み条件「すべて」のラベル
  ///
  /// In ja, this message translates to:
  /// **'すべて'**
  String get all;

  /// No description provided for @errorWithMessage.
  ///
  /// In ja, this message translates to:
  /// **'エラー: {message}'**
  String errorWithMessage(String message);

  /// No description provided for @saveFailedWithMessage.
  ///
  /// In ja, this message translates to:
  /// **'保存に失敗しました: {message}'**
  String saveFailedWithMessage(String message);

  /// No description provided for @deleteFailedWithMessage.
  ///
  /// In ja, this message translates to:
  /// **'削除に失敗しました: {message}'**
  String deleteFailedWithMessage(String message);

  /// No description provided for @confirmDeleteNamedMessage.
  ///
  /// In ja, this message translates to:
  /// **'「{name}」を削除しますか？'**
  String confirmDeleteNamedMessage(String name);

  /// 在庫一覧画面のタイトル
  ///
  /// In ja, this message translates to:
  /// **'在庫一覧'**
  String get itemListTitle;

  /// バーコード検索ボタンのツールチップ
  ///
  /// In ja, this message translates to:
  /// **'バーコードで検索'**
  String get searchBarcodeTooltip;

  /// 並べ替えボタンのツールチップ
  ///
  /// In ja, this message translates to:
  /// **'並べ替え'**
  String get sortTooltip;

  /// 並べ替え設定ダイアログのタイトル
  ///
  /// In ja, this message translates to:
  /// **'並べ替え設定'**
  String get sortDialogTitle;

  /// 並べ替え基準「品名」のラベル
  ///
  /// In ja, this message translates to:
  /// **'品名'**
  String get sortByNameLabel;

  /// 並べ替え基準「在庫数」のラベル
  ///
  /// In ja, this message translates to:
  /// **'在庫数'**
  String get sortByQuantityLabel;

  /// 並べ替え基準「お気に入り」のラベル
  ///
  /// In ja, this message translates to:
  /// **'お気に入り'**
  String get sortByFavoriteLabel;

  /// 並べ替え基準「分類」のラベル
  ///
  /// In ja, this message translates to:
  /// **'分類'**
  String get sortByCategoryLabel;

  /// 並び順「昇順」のラベル
  ///
  /// In ja, this message translates to:
  /// **'昇順'**
  String get sortAscendingLabel;

  /// 並び順「降順」のラベル
  ///
  /// In ja, this message translates to:
  /// **'降順'**
  String get sortDescendingLabel;

  /// 並べ替え設定をリセットするボタンのラベル
  ///
  /// In ja, this message translates to:
  /// **'リセット'**
  String get sortResetLabel;

  /// マスタ管理画面を開くボタンのツールチップ
  ///
  /// In ja, this message translates to:
  /// **'マスタ管理'**
  String get masterDataTooltip;

  /// 買い物リスト画面を開くボタンのツールチップ
  ///
  /// In ja, this message translates to:
  /// **'買い物リスト'**
  String get shoppingListTooltip;

  /// アプリ情報画面を開くボタンのツールチップ
  ///
  /// In ja, this message translates to:
  /// **'アプリ情報'**
  String get appInfoTooltip;

  /// 買い物リストへ追加するボタンのラベル
  ///
  /// In ja, this message translates to:
  /// **'追加'**
  String get addToShoppingListLabel;

  /// 既に買い物リストに追加済みであることを示すツールチップ
  ///
  /// In ja, this message translates to:
  /// **'買い物リストに追加済みです'**
  String get alreadyInShoppingListTooltip;

  /// 買い物リストから除外するボタンのラベル
  ///
  /// In ja, this message translates to:
  /// **'除外'**
  String get removeFromShoppingListLabel;

  /// 品名検索欄のラベル
  ///
  /// In ja, this message translates to:
  /// **'品名で検索'**
  String get searchByNameLabel;

  /// 検索条件をリセットするボタンのツールチップ
  ///
  /// In ja, this message translates to:
  /// **'検索リセット'**
  String get searchResetTooltip;

  /// 検索条件エリアを縮小表示に切り替えるボタンのツールチップ
  ///
  /// In ja, this message translates to:
  /// **'検索条件エリアを縮小表示'**
  String get collapseSearchAreaTooltip;

  /// 検索条件エリアを通常表示に切り替えるボタンのツールチップ
  ///
  /// In ja, this message translates to:
  /// **'検索条件エリアを通常表示'**
  String get expandSearchAreaTooltip;

  /// 大分類の絞り込みラベル
  ///
  /// In ja, this message translates to:
  /// **'大分類'**
  String get inventoryTypeLabel;

  /// 中分類の絞り込みラベル
  ///
  /// In ja, this message translates to:
  /// **'中分類'**
  String get categoryLabel;

  /// 色系統の絞り込みラベル
  ///
  /// In ja, this message translates to:
  /// **'色系統'**
  String get colorGroupLabel;

  /// 色系統「青系」のラベル
  ///
  /// In ja, this message translates to:
  /// **'青系'**
  String get colorGroupBlue;

  /// 色系統「赤系」のラベル
  ///
  /// In ja, this message translates to:
  /// **'赤系'**
  String get colorGroupRed;

  /// 色系統「緑系」のラベル
  ///
  /// In ja, this message translates to:
  /// **'緑系'**
  String get colorGroupGreen;

  /// 色系統「黄系」のラベル
  ///
  /// In ja, this message translates to:
  /// **'黄系'**
  String get colorGroupYellow;

  /// 色系統「白黒グレー系」のラベル
  ///
  /// In ja, this message translates to:
  /// **'白黒グレー系'**
  String get colorGroupMonochrome;

  /// 色系統「ベージュ・茶系」のラベル
  ///
  /// In ja, this message translates to:
  /// **'ベージュ・茶系'**
  String get colorGroupBeigeBrown;

  /// 色系統「柄・その他」のラベル
  ///
  /// In ja, this message translates to:
  /// **'柄・その他'**
  String get colorGroupPatternOther;

  /// 小分類の絞り込みラベル
  ///
  /// In ja, this message translates to:
  /// **'小分類'**
  String get subCategoryLabel;

  /// お気に入りで絞り込むボタンのラベル
  ///
  /// In ja, this message translates to:
  /// **'お気に入り'**
  String get filterByFavoriteLabel;

  /// お気に入り絞り込みダイアログのタイトル
  ///
  /// In ja, this message translates to:
  /// **'お気に入りで絞り込み'**
  String get favoriteFilterDialogTitle;

  /// お気に入り絞り込みの最小値ラベル
  ///
  /// In ja, this message translates to:
  /// **'最小'**
  String get favoriteMinLabel;

  /// お気に入り絞り込みの最大値ラベル
  ///
  /// In ja, this message translates to:
  /// **'最大'**
  String get favoriteMaxLabel;

  /// お気に入り絞り込み「すべて」のラベル
  ///
  /// In ja, this message translates to:
  /// **'すべて'**
  String get favoriteRangeAny;

  /// No description provided for @favoriteRangeAtLeast.
  ///
  /// In ja, this message translates to:
  /// **'★{min}以上'**
  String favoriteRangeAtLeast(int min);

  /// No description provided for @favoriteRangeAtMost.
  ///
  /// In ja, this message translates to:
  /// **'★{max}以下'**
  String favoriteRangeAtMost(int max);

  /// No description provided for @favoriteRangeBetween.
  ///
  /// In ja, this message translates to:
  /// **'★{min}〜{max}'**
  String favoriteRangeBetween(int min, int max);

  /// No description provided for @favoriteRangeExact.
  ///
  /// In ja, this message translates to:
  /// **'★{value}'**
  String favoriteRangeExact(int value);

  /// 在庫状況の絞り込みラベル
  ///
  /// In ja, this message translates to:
  /// **'在庫'**
  String get stockFilterLabel;

  /// 在庫状況「在庫あり」の絞り込みラベル
  ///
  /// In ja, this message translates to:
  /// **'在庫あり'**
  String get stockFilterInStock;

  /// 在庫状況「在庫不足」の絞り込みラベル
  ///
  /// In ja, this message translates to:
  /// **'在庫不足'**
  String get stockFilterLowStock;

  /// 在庫状況「在庫0」の絞り込みラベル
  ///
  /// In ja, this message translates to:
  /// **'在庫0'**
  String get stockFilterZero;

  /// 検索・絞り込み結果が0件のときのメッセージ
  ///
  /// In ja, this message translates to:
  /// **'該当するアイテムがありません'**
  String get noMatchingItems;

  /// バーコード検索で該当なしのため新規登録に進むメッセージ
  ///
  /// In ja, this message translates to:
  /// **'該当するアイテムが見つかりませんでした。新規登録します'**
  String get itemNotFoundCreatingNew;

  /// 在庫数を手動で調整した際の履歴理由
  ///
  /// In ja, this message translates to:
  /// **'手動調整'**
  String get manualAdjustmentReason;

  /// アイテム編集画面のタイトル
  ///
  /// In ja, this message translates to:
  /// **'アイテムを編集'**
  String get editItemTitle;

  /// アイテム登録画面のタイトル
  ///
  /// In ja, this message translates to:
  /// **'アイテムを登録'**
  String get addItemTitle;

  /// 入力したバーコードが他アイテムで使用済みの場合のエラーメッセージ
  ///
  /// In ja, this message translates to:
  /// **'このバーコードは既に他のアイテムに登録されています'**
  String get barcodeAlreadyRegistered;

  /// No description provided for @confirmDeleteItemMessage.
  ///
  /// In ja, this message translates to:
  /// **'「{name}」を削除しますか？'**
  String confirmDeleteItemMessage(String name);

  /// 品名入力欄のラベル
  ///
  /// In ja, this message translates to:
  /// **'品名 *'**
  String get nameLabel;

  /// 品名未入力時のバリデーションエラー
  ///
  /// In ja, this message translates to:
  /// **'品名は必須です'**
  String get nameRequiredError;

  /// 入力内容をクリアするボタンのツールチップ
  ///
  /// In ja, this message translates to:
  /// **'入力をクリア'**
  String get clearInputTooltip;

  /// 大分類選択欄（必須）のラベル
  ///
  /// In ja, this message translates to:
  /// **'大分類 *'**
  String get inventoryTypeLabelRequired;

  /// 大分類が未選択のときの案内メッセージ
  ///
  /// In ja, this message translates to:
  /// **'先に大分類を選択してください'**
  String get selectTypeFirst;

  /// 中分類選択欄（必須）のラベル
  ///
  /// In ja, this message translates to:
  /// **'中分類 *'**
  String get categoryLabelRequired;

  /// 中分類未選択時のバリデーションエラー
  ///
  /// In ja, this message translates to:
  /// **'中分類を選択してください'**
  String get categoryRequiredError;

  /// 中分類が未選択のときの案内メッセージ
  ///
  /// In ja, this message translates to:
  /// **'先に中分類を選択してください'**
  String get selectCategoryFirst;

  /// 色選択欄のラベル
  ///
  /// In ja, this message translates to:
  /// **'色'**
  String get colorLabel;

  /// 単位選択欄（必須）のラベル
  ///
  /// In ja, this message translates to:
  /// **'単位 *'**
  String get unitLabelRequired;

  /// 単位未選択時のバリデーションエラー
  ///
  /// In ja, this message translates to:
  /// **'単位を選択してください'**
  String get unitRequiredError;

  /// お気に入り度入力欄のラベル
  ///
  /// In ja, this message translates to:
  /// **'お気に入り'**
  String get favoriteRatingLabel;

  /// 在庫数入力欄のラベル
  ///
  /// In ja, this message translates to:
  /// **'在庫数 *'**
  String get quantityLabel;

  /// 数値以外が入力された場合のバリデーションエラー
  ///
  /// In ja, this message translates to:
  /// **'数値で入力してください'**
  String get invalidNumberError;

  /// 負の数が入力された場合のバリデーションエラー
  ///
  /// In ja, this message translates to:
  /// **'0以上の数値を入力してください'**
  String get negativeNumberError;

  /// 在庫不足の目安入力欄のラベル
  ///
  /// In ja, this message translates to:
  /// **'在庫不足の目安 *'**
  String get lowStockThresholdLabel;

  /// バーコード入力欄のラベル
  ///
  /// In ja, this message translates to:
  /// **'バーコード（手入力 or スキャン）'**
  String get barcodeLabel;

  /// メモ入力欄のラベル
  ///
  /// In ja, this message translates to:
  /// **'メモ'**
  String get memoLabel;

  /// カメラで撮影する選択肢のラベル
  ///
  /// In ja, this message translates to:
  /// **'カメラで撮影'**
  String get takePhoto;

  /// ギャラリーから画像を選択する選択肢のラベル
  ///
  /// In ja, this message translates to:
  /// **'ギャラリーから選択'**
  String get chooseFromGallery;

  /// 登録済み画像を削除するボタンのラベル
  ///
  /// In ja, this message translates to:
  /// **'画像削除'**
  String get deleteImageLabel;

  /// アイテム登録画面の登録ボタンラベル
  ///
  /// In ja, this message translates to:
  /// **'登録'**
  String get registerButtonLabel;

  /// バーコードスキャン画面のタイトル
  ///
  /// In ja, this message translates to:
  /// **'バーコードをスキャン'**
  String get scanBarcodeTitle;

  /// バーコードスキャン後、確認処理中であることを示すラベル
  ///
  /// In ja, this message translates to:
  /// **'確認中...'**
  String get scanConfirmingLabel;

  /// マスタ管理画面のタイトル
  ///
  /// In ja, this message translates to:
  /// **'マスタ管理'**
  String get masterDataTitle;

  /// マスタ管理画面の「大分類」タブラベル
  ///
  /// In ja, this message translates to:
  /// **'大分類'**
  String get typesTab;

  /// マスタ管理画面の「中分類」タブラベル
  ///
  /// In ja, this message translates to:
  /// **'中分類'**
  String get categoriesTab;

  /// マスタ管理画面の「小分類」タブラベル
  ///
  /// In ja, this message translates to:
  /// **'小分類'**
  String get subCategoriesTab;

  /// マスタ管理画面の「色」タブラベル
  ///
  /// In ja, this message translates to:
  /// **'色'**
  String get colorsTab;

  /// マスタ管理画面の「単位」タブラベル
  ///
  /// In ja, this message translates to:
  /// **'単位'**
  String get unitsTab;

  /// 使い方ガイドへのリンクラベル
  ///
  /// In ja, this message translates to:
  /// **'このアプリの使い方'**
  String get helpGuideLabel;

  /// プライバシーポリシーへのリンクラベル
  ///
  /// In ja, this message translates to:
  /// **'プライバシーポリシー'**
  String get privacyPolicyLabel;

  /// 外部リンクを開けなかった場合のエラーメッセージ
  ///
  /// In ja, this message translates to:
  /// **'リンクを開けませんでした'**
  String get failedToOpenLink;

  /// No description provided for @inUseCannotDelete.
  ///
  /// In ja, this message translates to:
  /// **'「{name}」は{count}件のアイテムで使われているため削除できません'**
  String inUseCannotDelete(String name, int count);

  /// No description provided for @typeInUseCannotDelete.
  ///
  /// In ja, this message translates to:
  /// **'「{name}」は{count}件の中分類で使われているため削除できません'**
  String typeInUseCannotDelete(String name, int count);

  /// No description provided for @categoryInUseBySubCategoriesCannotDelete.
  ///
  /// In ja, this message translates to:
  /// **'「{name}」には{count}件の小分類が登録されているため削除できません。先に小分類を削除してください'**
  String categoryInUseBySubCategoriesCannotDelete(String name, int count);

  /// 大分類が最後の1件で削除できない場合のエラーメッセージ
  ///
  /// In ja, this message translates to:
  /// **'大分類は1件以上データが必要です'**
  String get lastInventoryTypeCannotDelete;

  /// 大分類が1件も登録されていない場合のメッセージ
  ///
  /// In ja, this message translates to:
  /// **'大分類が登録されていません'**
  String get noTypesRegistered;

  /// No description provided for @addCategoryToType.
  ///
  /// In ja, this message translates to:
  /// **'「{typeName}」に中分類を追加'**
  String addCategoryToType(String typeName);

  /// 大分類配下に中分類が1件も無い場合のメッセージ
  ///
  /// In ja, this message translates to:
  /// **'中分類なし'**
  String get noCategoriesInType;

  /// 中分類が1件も登録されていない場合のメッセージ
  ///
  /// In ja, this message translates to:
  /// **'中分類が登録されていません'**
  String get noCategoriesRegistered;

  /// No description provided for @addSubCategoryToCategory.
  ///
  /// In ja, this message translates to:
  /// **'「{categoryName}」に小分類を追加'**
  String addSubCategoryToCategory(String categoryName);

  /// 中分類配下に小分類が1件も無い場合のメッセージ
  ///
  /// In ja, this message translates to:
  /// **'小分類なし'**
  String get noSubCategories;

  /// No description provided for @confirmDeleteSubCategoryMessage.
  ///
  /// In ja, this message translates to:
  /// **'「{name}」を削除しますか？\nこの小分類が設定されているアイテムは「未設定」になります。'**
  String confirmDeleteSubCategoryMessage(String name);

  /// 色が1件も登録されていない場合のメッセージ
  ///
  /// In ja, this message translates to:
  /// **'色が登録されていません'**
  String get noColorsRegistered;

  /// No description provided for @confirmDeleteColorMessage.
  ///
  /// In ja, this message translates to:
  /// **'「{name}」を削除しますか？\nこの色が設定されているアイテムは「未設定」になります。'**
  String confirmDeleteColorMessage(String name);

  /// 単位が1件も登録されていない場合のメッセージ
  ///
  /// In ja, this message translates to:
  /// **'単位が登録されていません'**
  String get noUnitsRegistered;

  /// アプリ情報画面のタイトル
  ///
  /// In ja, this message translates to:
  /// **'アプリ情報'**
  String get appInfoTitle;

  /// No description provided for @appVersionWithBuild.
  ///
  /// In ja, this message translates to:
  /// **'バージョン {version} ({buildNumber})'**
  String appVersionWithBuild(String version, String buildNumber);

  /// Yahoo! JAPAN Web APIを利用していることを示すクレジット表記
  ///
  /// In ja, this message translates to:
  /// **'Web Services by Yahoo! JAPAN'**
  String get yahooAttributionLabel;

  /// 汎用的な名前未入力時のバリデーションエラー
  ///
  /// In ja, this message translates to:
  /// **'名前を入力してください'**
  String get nameRequiredGeneric;

  /// 大分類追加ダイアログのタイトル
  ///
  /// In ja, this message translates to:
  /// **'新しい大分類を追加'**
  String get addTypeTitle;

  /// 大分類名入力欄のヒントテキスト
  ///
  /// In ja, this message translates to:
  /// **'大分類名（例: 手芸用品）'**
  String get typeNameHint;

  /// 大分類名が重複している場合のエラーメッセージ
  ///
  /// In ja, this message translates to:
  /// **'同じ名前の大分類がすでに登録されています'**
  String get duplicateTypeName;

  /// 大分類編集ダイアログのタイトル
  ///
  /// In ja, this message translates to:
  /// **'大分類を編集'**
  String get editTypeTitle;

  /// 大分類名入力欄のラベル
  ///
  /// In ja, this message translates to:
  /// **'大分類名'**
  String get typeNameLabel;

  /// 中分類名入力欄のヒントテキスト
  ///
  /// In ja, this message translates to:
  /// **'中分類名（例: 布）'**
  String get categoryNameHint;

  /// 中分類名が重複している場合のエラーメッセージ
  ///
  /// In ja, this message translates to:
  /// **'同じ名前の中分類がすでに登録されています'**
  String get duplicateCategoryName;

  /// 中分類編集ダイアログのタイトル
  ///
  /// In ja, this message translates to:
  /// **'中分類を編集'**
  String get editCategoryTitle;

  /// 中分類名入力欄のラベル
  ///
  /// In ja, this message translates to:
  /// **'中分類名'**
  String get categoryNameLabel;

  /// 小分類名入力欄のヒントテキスト
  ///
  /// In ja, this message translates to:
  /// **'小分類名（例: フェルト）'**
  String get subCategoryNameHint;

  /// 小分類名が同一中分類内で重複している場合のエラーメッセージ
  ///
  /// In ja, this message translates to:
  /// **'この中分類には同じ名前の小分類がすでに登録されています'**
  String get duplicateSubCategoryName;

  /// No description provided for @editSubCategoryOfCategory.
  ///
  /// In ja, this message translates to:
  /// **'「{categoryName}」の小分類を編集'**
  String editSubCategoryOfCategory(String categoryName);

  /// 小分類名入力欄のラベル
  ///
  /// In ja, this message translates to:
  /// **'小分類名'**
  String get subCategoryNameLabel;

  /// No description provided for @fetchColorGroupsFailed.
  ///
  /// In ja, this message translates to:
  /// **'色系統の取得に失敗しました: {message}'**
  String fetchColorGroupsFailed(String message);

  /// 色系統データが取得できなかった場合のメッセージ
  ///
  /// In ja, this message translates to:
  /// **'色系統が見つかりませんでした'**
  String get noColorGroupsFound;

  /// 色追加ダイアログのタイトル
  ///
  /// In ja, this message translates to:
  /// **'新しい色を追加'**
  String get addColorOptionTitle;

  /// 色編集ダイアログのタイトル
  ///
  /// In ja, this message translates to:
  /// **'色を編集'**
  String get editColorOptionTitle;

  /// 色選択ダイアログのタイトル
  ///
  /// In ja, this message translates to:
  /// **'色を選択'**
  String get selectColorTitle;

  /// 色選択ダイアログの決定ボタンラベル
  ///
  /// In ja, this message translates to:
  /// **'決定'**
  String get decide;

  /// 色名未入力時のバリデーションエラー
  ///
  /// In ja, this message translates to:
  /// **'色名を入力してください'**
  String get colorNameRequiredError;

  /// 色名が重複している場合のエラーメッセージ
  ///
  /// In ja, this message translates to:
  /// **'同じ名前の色がすでに登録されています'**
  String get duplicateColorName;

  /// 色名入力欄のヒントテキスト
  ///
  /// In ja, this message translates to:
  /// **'色名（例: 水色）'**
  String get colorNameHint;

  /// カラーコード入力欄のヒントテキスト
  ///
  /// In ja, this message translates to:
  /// **'カラーコード（任意, 例: #64B5F6）'**
  String get hexCodeHint;

  /// 単位追加ダイアログのタイトル
  ///
  /// In ja, this message translates to:
  /// **'新しい単位を追加'**
  String get addUnitTitle;

  /// 単位名入力欄のヒントテキスト
  ///
  /// In ja, this message translates to:
  /// **'単位名（例: 巻）'**
  String get unitNameHint;

  /// 単位名が重複している場合のエラーメッセージ
  ///
  /// In ja, this message translates to:
  /// **'同じ名前の単位がすでに登録されています'**
  String get duplicateUnitName;

  /// 単位編集ダイアログのタイトル
  ///
  /// In ja, this message translates to:
  /// **'単位を編集'**
  String get editUnitTitle;

  /// 単位名入力欄のラベル
  ///
  /// In ja, this message translates to:
  /// **'単位名'**
  String get unitNameLabel;

  /// 買い物リスト画面のタイトル
  ///
  /// In ja, this message translates to:
  /// **'買い物リスト'**
  String get shoppingListTitle;

  /// 買い物リストが空の場合のメッセージ
  ///
  /// In ja, this message translates to:
  /// **'買い物リストは空です'**
  String get shoppingListEmptyMessage;

  /// 購入操作ボタンのツールチップ
  ///
  /// In ja, this message translates to:
  /// **'購入'**
  String get purchaseTooltip;

  /// 購入数入力欄のラベル
  ///
  /// In ja, this message translates to:
  /// **'購入数'**
  String get purchaseQuantityLabel;

  /// 買い物リストの全アイテムを一括購入するボタンのラベル
  ///
  /// In ja, this message translates to:
  /// **'一括購入'**
  String get purchaseAllButton;

  /// 在庫一覧画面へ戻るボタンのラベル
  ///
  /// In ja, this message translates to:
  /// **'在庫一覧へ戻る'**
  String get backToItemListButton;

  /// 買い物リストからの購入時の在庫増加履歴理由
  ///
  /// In ja, this message translates to:
  /// **'買い物リストからの購入'**
  String get shoppingListPurchaseReason;
}

class _L10nDelegate extends LocalizationsDelegate<L10n> {
  const _L10nDelegate();

  @override
  Future<L10n> load(Locale locale) {
    return SynchronousFuture<L10n>(lookupL10n(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ja'].contains(locale.languageCode);

  @override
  bool shouldReload(_L10nDelegate old) => false;
}

L10n lookupL10n(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return L10nEn();
    case 'ja':
      return L10nJa();
  }

  throw FlutterError(
    'L10n.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
