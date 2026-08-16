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

  /// No description provided for @cancel.
  ///
  /// In ja, this message translates to:
  /// **'キャンセル'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In ja, this message translates to:
  /// **'削除'**
  String get delete;

  /// No description provided for @save.
  ///
  /// In ja, this message translates to:
  /// **'保存'**
  String get save;

  /// No description provided for @add.
  ///
  /// In ja, this message translates to:
  /// **'追加'**
  String get add;

  /// No description provided for @ok.
  ///
  /// In ja, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @errorTitle.
  ///
  /// In ja, this message translates to:
  /// **'エラー'**
  String get errorTitle;

  /// No description provided for @confirmDeleteTitle.
  ///
  /// In ja, this message translates to:
  /// **'削除の確認'**
  String get confirmDeleteTitle;

  /// No description provided for @unset.
  ///
  /// In ja, this message translates to:
  /// **'未設定'**
  String get unset;

  /// No description provided for @all.
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

  /// No description provided for @itemListTitle.
  ///
  /// In ja, this message translates to:
  /// **'在庫一覧'**
  String get itemListTitle;

  /// No description provided for @searchBarcodeTooltip.
  ///
  /// In ja, this message translates to:
  /// **'バーコードで検索'**
  String get searchBarcodeTooltip;

  /// No description provided for @sortTooltip.
  ///
  /// In ja, this message translates to:
  /// **'並べ替え'**
  String get sortTooltip;

  /// No description provided for @sortDialogTitle.
  ///
  /// In ja, this message translates to:
  /// **'並べ替え設定'**
  String get sortDialogTitle;

  /// No description provided for @sortByNameLabel.
  ///
  /// In ja, this message translates to:
  /// **'品名'**
  String get sortByNameLabel;

  /// No description provided for @sortByQuantityLabel.
  ///
  /// In ja, this message translates to:
  /// **'在庫数'**
  String get sortByQuantityLabel;

  /// No description provided for @sortByFavoriteLabel.
  ///
  /// In ja, this message translates to:
  /// **'お気に入り'**
  String get sortByFavoriteLabel;

  /// No description provided for @sortAscendingLabel.
  ///
  /// In ja, this message translates to:
  /// **'昇順'**
  String get sortAscendingLabel;

  /// No description provided for @sortDescendingLabel.
  ///
  /// In ja, this message translates to:
  /// **'降順'**
  String get sortDescendingLabel;

  /// No description provided for @sortResetLabel.
  ///
  /// In ja, this message translates to:
  /// **'リセット'**
  String get sortResetLabel;

  /// No description provided for @masterDataTooltip.
  ///
  /// In ja, this message translates to:
  /// **'マスタ管理'**
  String get masterDataTooltip;

  /// No description provided for @appInfoTooltip.
  ///
  /// In ja, this message translates to:
  /// **'アプリ情報'**
  String get appInfoTooltip;

  /// No description provided for @searchByNameLabel.
  ///
  /// In ja, this message translates to:
  /// **'品名で検索'**
  String get searchByNameLabel;

  /// No description provided for @categoryLabel.
  ///
  /// In ja, this message translates to:
  /// **'カテゴリー'**
  String get categoryLabel;

  /// No description provided for @colorGroupLabel.
  ///
  /// In ja, this message translates to:
  /// **'色系統'**
  String get colorGroupLabel;

  /// No description provided for @colorGroupBlue.
  ///
  /// In ja, this message translates to:
  /// **'青系'**
  String get colorGroupBlue;

  /// No description provided for @colorGroupRed.
  ///
  /// In ja, this message translates to:
  /// **'赤系'**
  String get colorGroupRed;

  /// No description provided for @colorGroupGreen.
  ///
  /// In ja, this message translates to:
  /// **'緑系'**
  String get colorGroupGreen;

  /// No description provided for @colorGroupYellow.
  ///
  /// In ja, this message translates to:
  /// **'黄系'**
  String get colorGroupYellow;

  /// No description provided for @colorGroupMonochrome.
  ///
  /// In ja, this message translates to:
  /// **'白黒グレー系'**
  String get colorGroupMonochrome;

  /// No description provided for @colorGroupBeigeBrown.
  ///
  /// In ja, this message translates to:
  /// **'ベージュ・茶系'**
  String get colorGroupBeigeBrown;

  /// No description provided for @colorGroupPatternOther.
  ///
  /// In ja, this message translates to:
  /// **'柄・その他'**
  String get colorGroupPatternOther;

  /// No description provided for @subCategoryLabel.
  ///
  /// In ja, this message translates to:
  /// **'サブカテゴリー'**
  String get subCategoryLabel;

  /// No description provided for @filterByFavoriteLabel.
  ///
  /// In ja, this message translates to:
  /// **'お気に入りで絞り込み'**
  String get filterByFavoriteLabel;

  /// No description provided for @favoriteFilterDialogTitle.
  ///
  /// In ja, this message translates to:
  /// **'お気に入りで絞り込み'**
  String get favoriteFilterDialogTitle;

  /// No description provided for @favoriteMinLabel.
  ///
  /// In ja, this message translates to:
  /// **'最小'**
  String get favoriteMinLabel;

  /// No description provided for @favoriteMaxLabel.
  ///
  /// In ja, this message translates to:
  /// **'最大'**
  String get favoriteMaxLabel;

  /// No description provided for @favoriteRangeAny.
  ///
  /// In ja, this message translates to:
  /// **'指定なし'**
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

  /// No description provided for @inStockOnlyLabel.
  ///
  /// In ja, this message translates to:
  /// **'在庫ありのみ表示'**
  String get inStockOnlyLabel;

  /// No description provided for @noMatchingItems.
  ///
  /// In ja, this message translates to:
  /// **'該当するアイテムがありません'**
  String get noMatchingItems;

  /// No description provided for @itemNotFoundCreatingNew.
  ///
  /// In ja, this message translates to:
  /// **'該当するアイテムが見つかりませんでした。新規登録します'**
  String get itemNotFoundCreatingNew;

  /// No description provided for @manualAdjustmentReason.
  ///
  /// In ja, this message translates to:
  /// **'手動調整'**
  String get manualAdjustmentReason;

  /// No description provided for @editItemTitle.
  ///
  /// In ja, this message translates to:
  /// **'アイテムを編集'**
  String get editItemTitle;

  /// No description provided for @addItemTitle.
  ///
  /// In ja, this message translates to:
  /// **'アイテムを登録'**
  String get addItemTitle;

  /// No description provided for @selectCategoryAndUnit.
  ///
  /// In ja, this message translates to:
  /// **'カテゴリーと単位を選択してください'**
  String get selectCategoryAndUnit;

  /// No description provided for @barcodeAlreadyRegistered.
  ///
  /// In ja, this message translates to:
  /// **'このバーコードは既に他のアイテムに登録されています'**
  String get barcodeAlreadyRegistered;

  /// No description provided for @confirmDeleteItemMessage.
  ///
  /// In ja, this message translates to:
  /// **'「{name}」を削除しますか？'**
  String confirmDeleteItemMessage(String name);

  /// No description provided for @nameLabel.
  ///
  /// In ja, this message translates to:
  /// **'品名 *'**
  String get nameLabel;

  /// No description provided for @nameRequiredError.
  ///
  /// In ja, this message translates to:
  /// **'品名は必須です'**
  String get nameRequiredError;

  /// No description provided for @clearInputTooltip.
  ///
  /// In ja, this message translates to:
  /// **'入力をクリア'**
  String get clearInputTooltip;

  /// No description provided for @categoryLabelRequired.
  ///
  /// In ja, this message translates to:
  /// **'カテゴリー *'**
  String get categoryLabelRequired;

  /// No description provided for @selectCategoryFirst.
  ///
  /// In ja, this message translates to:
  /// **'先にカテゴリーを選択してください'**
  String get selectCategoryFirst;

  /// No description provided for @colorLabel.
  ///
  /// In ja, this message translates to:
  /// **'色'**
  String get colorLabel;

  /// No description provided for @unitLabelRequired.
  ///
  /// In ja, this message translates to:
  /// **'単位 *'**
  String get unitLabelRequired;

  /// No description provided for @favoriteRatingLabel.
  ///
  /// In ja, this message translates to:
  /// **'お気に入り'**
  String get favoriteRatingLabel;

  /// No description provided for @quantityLabel.
  ///
  /// In ja, this message translates to:
  /// **'在庫数 *'**
  String get quantityLabel;

  /// No description provided for @invalidNumberError.
  ///
  /// In ja, this message translates to:
  /// **'数値で入力してください'**
  String get invalidNumberError;

  /// No description provided for @negativeNumberError.
  ///
  /// In ja, this message translates to:
  /// **'0以上の数値を入力してください'**
  String get negativeNumberError;

  /// No description provided for @lowStockThresholdLabel.
  ///
  /// In ja, this message translates to:
  /// **'在庫不足の目安'**
  String get lowStockThresholdLabel;

  /// No description provided for @barcodeLabel.
  ///
  /// In ja, this message translates to:
  /// **'バーコード（手入力 or スキャン）'**
  String get barcodeLabel;

  /// No description provided for @memoLabel.
  ///
  /// In ja, this message translates to:
  /// **'メモ'**
  String get memoLabel;

  /// No description provided for @takePhoto.
  ///
  /// In ja, this message translates to:
  /// **'カメラで撮影'**
  String get takePhoto;

  /// No description provided for @chooseFromGallery.
  ///
  /// In ja, this message translates to:
  /// **'ギャラリーから選択'**
  String get chooseFromGallery;

  /// No description provided for @deleteImageLabel.
  ///
  /// In ja, this message translates to:
  /// **'画像削除'**
  String get deleteImageLabel;

  /// No description provided for @registerButtonLabel.
  ///
  /// In ja, this message translates to:
  /// **'登録'**
  String get registerButtonLabel;

  /// No description provided for @scanBarcodeTitle.
  ///
  /// In ja, this message translates to:
  /// **'バーコードをスキャン'**
  String get scanBarcodeTitle;

  /// No description provided for @scanConfirmingLabel.
  ///
  /// In ja, this message translates to:
  /// **'確認中...'**
  String get scanConfirmingLabel;

  /// No description provided for @masterDataTitle.
  ///
  /// In ja, this message translates to:
  /// **'マスタ管理'**
  String get masterDataTitle;

  /// No description provided for @categoriesTab.
  ///
  /// In ja, this message translates to:
  /// **'カテゴリー'**
  String get categoriesTab;

  /// No description provided for @subCategoriesTab.
  ///
  /// In ja, this message translates to:
  /// **'サブカテゴリー'**
  String get subCategoriesTab;

  /// No description provided for @colorsTab.
  ///
  /// In ja, this message translates to:
  /// **'色'**
  String get colorsTab;

  /// No description provided for @unitsTab.
  ///
  /// In ja, this message translates to:
  /// **'単位'**
  String get unitsTab;

  /// No description provided for @privacyPolicyLabel.
  ///
  /// In ja, this message translates to:
  /// **'プライバシーポリシー'**
  String get privacyPolicyLabel;

  /// No description provided for @failedToOpenLink.
  ///
  /// In ja, this message translates to:
  /// **'リンクを開けませんでした'**
  String get failedToOpenLink;

  /// No description provided for @inUseCannotDelete.
  ///
  /// In ja, this message translates to:
  /// **'「{name}」は{count}件のアイテムで使われているため削除できません'**
  String inUseCannotDelete(String name, int count);

  /// No description provided for @noCategoriesRegistered.
  ///
  /// In ja, this message translates to:
  /// **'カテゴリーが登録されていません'**
  String get noCategoriesRegistered;

  /// No description provided for @addSubCategoryToCategory.
  ///
  /// In ja, this message translates to:
  /// **'「{categoryName}」にサブカテゴリーを追加'**
  String addSubCategoryToCategory(String categoryName);

  /// No description provided for @noSubCategories.
  ///
  /// In ja, this message translates to:
  /// **'サブカテゴリーなし'**
  String get noSubCategories;

  /// No description provided for @confirmDeleteSubCategoryMessage.
  ///
  /// In ja, this message translates to:
  /// **'「{name}」を削除しますか？\nこのサブカテゴリーが設定されているアイテムは「未設定」になります。'**
  String confirmDeleteSubCategoryMessage(String name);

  /// No description provided for @noColorsRegistered.
  ///
  /// In ja, this message translates to:
  /// **'色が登録されていません'**
  String get noColorsRegistered;

  /// No description provided for @confirmDeleteColorMessage.
  ///
  /// In ja, this message translates to:
  /// **'「{name}」を削除しますか？\nこの色が設定されているアイテムは「未設定」になります。'**
  String confirmDeleteColorMessage(String name);

  /// No description provided for @noUnitsRegistered.
  ///
  /// In ja, this message translates to:
  /// **'単位が登録されていません'**
  String get noUnitsRegistered;

  /// No description provided for @appInfoTitle.
  ///
  /// In ja, this message translates to:
  /// **'アプリ情報'**
  String get appInfoTitle;

  /// No description provided for @appVersionWithBuild.
  ///
  /// In ja, this message translates to:
  /// **'バージョン {version} ({buildNumber})'**
  String appVersionWithBuild(String version, String buildNumber);

  /// No description provided for @yahooAttributionLabel.
  ///
  /// In ja, this message translates to:
  /// **'Web Services by Yahoo! JAPAN'**
  String get yahooAttributionLabel;

  /// No description provided for @nameRequiredGeneric.
  ///
  /// In ja, this message translates to:
  /// **'名前を入力してください'**
  String get nameRequiredGeneric;

  /// No description provided for @fetchInventoryTypesFailed.
  ///
  /// In ja, this message translates to:
  /// **'在庫の種類の取得に失敗しました: {message}'**
  String fetchInventoryTypesFailed(String message);

  /// No description provided for @noInventoryTypesFound.
  ///
  /// In ja, this message translates to:
  /// **'在庫の種類（手芸用品など）が見つかりませんでした'**
  String get noInventoryTypesFound;

  /// No description provided for @addCategoryTitle.
  ///
  /// In ja, this message translates to:
  /// **'新しいカテゴリーを追加'**
  String get addCategoryTitle;

  /// No description provided for @categoryNameHint.
  ///
  /// In ja, this message translates to:
  /// **'カテゴリー名（例: 布）'**
  String get categoryNameHint;

  /// No description provided for @duplicateCategoryName.
  ///
  /// In ja, this message translates to:
  /// **'同じ名前のカテゴリーがすでに登録されています'**
  String get duplicateCategoryName;

  /// No description provided for @editCategoryTitle.
  ///
  /// In ja, this message translates to:
  /// **'カテゴリーを編集'**
  String get editCategoryTitle;

  /// No description provided for @categoryNameLabel.
  ///
  /// In ja, this message translates to:
  /// **'カテゴリー名'**
  String get categoryNameLabel;

  /// No description provided for @subCategoryNameHint.
  ///
  /// In ja, this message translates to:
  /// **'サブカテゴリー名（例: フェルト）'**
  String get subCategoryNameHint;

  /// No description provided for @duplicateSubCategoryName.
  ///
  /// In ja, this message translates to:
  /// **'このカテゴリーには同じ名前のサブカテゴリーがすでに登録されています'**
  String get duplicateSubCategoryName;

  /// No description provided for @editSubCategoryOfCategory.
  ///
  /// In ja, this message translates to:
  /// **'「{categoryName}」のサブカテゴリーを編集'**
  String editSubCategoryOfCategory(String categoryName);

  /// No description provided for @subCategoryNameLabel.
  ///
  /// In ja, this message translates to:
  /// **'サブカテゴリー名'**
  String get subCategoryNameLabel;

  /// No description provided for @fetchColorGroupsFailed.
  ///
  /// In ja, this message translates to:
  /// **'色系統の取得に失敗しました: {message}'**
  String fetchColorGroupsFailed(String message);

  /// No description provided for @noColorGroupsFound.
  ///
  /// In ja, this message translates to:
  /// **'色系統が見つかりませんでした'**
  String get noColorGroupsFound;

  /// No description provided for @addColorOptionTitle.
  ///
  /// In ja, this message translates to:
  /// **'新しい色を追加'**
  String get addColorOptionTitle;

  /// No description provided for @editColorOptionTitle.
  ///
  /// In ja, this message translates to:
  /// **'色を編集'**
  String get editColorOptionTitle;

  /// No description provided for @selectColorTitle.
  ///
  /// In ja, this message translates to:
  /// **'色を選択'**
  String get selectColorTitle;

  /// No description provided for @decide.
  ///
  /// In ja, this message translates to:
  /// **'決定'**
  String get decide;

  /// No description provided for @colorNameRequiredError.
  ///
  /// In ja, this message translates to:
  /// **'色名を入力してください'**
  String get colorNameRequiredError;

  /// No description provided for @duplicateColorName.
  ///
  /// In ja, this message translates to:
  /// **'同じ名前の色がすでに登録されています'**
  String get duplicateColorName;

  /// No description provided for @colorNameHint.
  ///
  /// In ja, this message translates to:
  /// **'色名（例: 水色）'**
  String get colorNameHint;

  /// No description provided for @hexCodeHint.
  ///
  /// In ja, this message translates to:
  /// **'カラーコード（任意, 例: #64B5F6）'**
  String get hexCodeHint;

  /// No description provided for @addUnitTitle.
  ///
  /// In ja, this message translates to:
  /// **'新しい単位を追加'**
  String get addUnitTitle;

  /// No description provided for @unitNameHint.
  ///
  /// In ja, this message translates to:
  /// **'単位名（例: 巻）'**
  String get unitNameHint;

  /// No description provided for @duplicateUnitName.
  ///
  /// In ja, this message translates to:
  /// **'同じ名前の単位がすでに登録されています'**
  String get duplicateUnitName;

  /// No description provided for @editUnitTitle.
  ///
  /// In ja, this message translates to:
  /// **'単位を編集'**
  String get editUnitTitle;

  /// No description provided for @unitNameLabel.
  ///
  /// In ja, this message translates to:
  /// **'単位名'**
  String get unitNameLabel;
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
