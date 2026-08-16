// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Japanese (`ja`).
class L10nJa extends L10n {
  L10nJa([String locale = 'ja']) : super(locale);

  @override
  String get appTitle => 'my在庫';

  @override
  String get cancel => 'キャンセル';

  @override
  String get delete => '削除';

  @override
  String get save => '保存';

  @override
  String get add => '追加';

  @override
  String get ok => 'OK';

  @override
  String get errorTitle => 'エラー';

  @override
  String get confirmDeleteTitle => '削除の確認';

  @override
  String get unset => '未設定';

  @override
  String get all => 'すべて';

  @override
  String errorWithMessage(String message) {
    return 'エラー: $message';
  }

  @override
  String saveFailedWithMessage(String message) {
    return '保存に失敗しました: $message';
  }

  @override
  String deleteFailedWithMessage(String message) {
    return '削除に失敗しました: $message';
  }

  @override
  String confirmDeleteNamedMessage(String name) {
    return '「$name」を削除しますか？';
  }

  @override
  String get itemListTitle => '在庫一覧';

  @override
  String get searchBarcodeTooltip => 'バーコードで検索';

  @override
  String get sortTooltip => '並べ替え';

  @override
  String get sortDialogTitle => '並べ替え設定';

  @override
  String get sortByNameLabel => '品名';

  @override
  String get sortByQuantityLabel => '在庫数';

  @override
  String get sortByFavoriteLabel => 'お気に入り';

  @override
  String get sortAscendingLabel => '昇順';

  @override
  String get sortDescendingLabel => '降順';

  @override
  String get sortResetLabel => 'リセット';

  @override
  String get masterDataTooltip => 'マスタ管理';

  @override
  String get appInfoTooltip => 'アプリ情報';

  @override
  String get searchByNameLabel => '品名で検索';

  @override
  String get categoryLabel => 'カテゴリー';

  @override
  String get colorGroupLabel => '色系統';

  @override
  String get colorGroupBlue => '青系';

  @override
  String get colorGroupRed => '赤系';

  @override
  String get colorGroupGreen => '緑系';

  @override
  String get colorGroupYellow => '黄系';

  @override
  String get colorGroupMonochrome => '白黒グレー系';

  @override
  String get colorGroupBeigeBrown => 'ベージュ・茶系';

  @override
  String get colorGroupPatternOther => '柄・その他';

  @override
  String get subCategoryLabel => 'サブカテゴリー';

  @override
  String get filterByFavoriteLabel => 'お気に入りで絞り込み';

  @override
  String get favoriteFilterDialogTitle => 'お気に入りで絞り込み';

  @override
  String get favoriteMinLabel => '最小';

  @override
  String get favoriteMaxLabel => '最大';

  @override
  String get favoriteRangeAny => '指定なし';

  @override
  String favoriteRangeAtLeast(int min) {
    return '★$min以上';
  }

  @override
  String favoriteRangeAtMost(int max) {
    return '★$max以下';
  }

  @override
  String favoriteRangeBetween(int min, int max) {
    return '★$min〜$max';
  }

  @override
  String favoriteRangeExact(int value) {
    return '★$value';
  }

  @override
  String get inStockOnlyLabel => '在庫ありのみ表示';

  @override
  String get noMatchingItems => '該当するアイテムがありません';

  @override
  String get itemNotFoundCreatingNew => '該当するアイテムが見つかりませんでした。新規登録します';

  @override
  String get manualAdjustmentReason => '手動調整';

  @override
  String get editItemTitle => 'アイテムを編集';

  @override
  String get addItemTitle => 'アイテムを登録';

  @override
  String get selectCategoryAndUnit => 'カテゴリーと単位を選択してください';

  @override
  String get barcodeAlreadyRegistered => 'このバーコードは既に他のアイテムに登録されています';

  @override
  String confirmDeleteItemMessage(String name) {
    return '「$name」を削除しますか？';
  }

  @override
  String get nameLabel => '品名 *';

  @override
  String get nameRequiredError => '品名は必須です';

  @override
  String get clearInputTooltip => '入力をクリア';

  @override
  String get categoryLabelRequired => 'カテゴリー *';

  @override
  String get selectCategoryFirst => '先にカテゴリーを選択してください';

  @override
  String get colorLabel => '色';

  @override
  String get unitLabelRequired => '単位 *';

  @override
  String get favoriteRatingLabel => 'お気に入り';

  @override
  String get quantityLabel => '在庫数 *';

  @override
  String get invalidNumberError => '数値で入力してください';

  @override
  String get negativeNumberError => '0以上の数値を入力してください';

  @override
  String get lowStockThresholdLabel => '在庫不足の目安';

  @override
  String get barcodeLabel => 'バーコード（手入力 or スキャン）';

  @override
  String get memoLabel => 'メモ';

  @override
  String get takePhoto => 'カメラで撮影';

  @override
  String get chooseFromGallery => 'ギャラリーから選択';

  @override
  String get deleteImageLabel => '画像削除';

  @override
  String get registerButtonLabel => '登録';

  @override
  String get scanBarcodeTitle => 'バーコードをスキャン';

  @override
  String get scanConfirmingLabel => '確認中...';

  @override
  String get masterDataTitle => 'マスタ管理';

  @override
  String get categoriesTab => 'カテゴリー';

  @override
  String get subCategoriesTab => 'サブカテゴリー';

  @override
  String get colorsTab => '色';

  @override
  String get unitsTab => '単位';

  @override
  String get privacyPolicyLabel => 'プライバシーポリシー';

  @override
  String get failedToOpenLink => 'リンクを開けませんでした';

  @override
  String inUseCannotDelete(String name, int count) {
    return '「$name」は$count件のアイテムで使われているため削除できません';
  }

  @override
  String get noCategoriesRegistered => 'カテゴリーが登録されていません';

  @override
  String addSubCategoryToCategory(String categoryName) {
    return '「$categoryName」にサブカテゴリーを追加';
  }

  @override
  String get noSubCategories => 'サブカテゴリーなし';

  @override
  String confirmDeleteSubCategoryMessage(String name) {
    return '「$name」を削除しますか？\nこのサブカテゴリーが設定されているアイテムは「未設定」になります。';
  }

  @override
  String get noColorsRegistered => '色が登録されていません';

  @override
  String confirmDeleteColorMessage(String name) {
    return '「$name」を削除しますか？\nこの色が設定されているアイテムは「未設定」になります。';
  }

  @override
  String get noUnitsRegistered => '単位が登録されていません';

  @override
  String get appInfoTitle => 'アプリ情報';

  @override
  String appVersionWithBuild(String version, String buildNumber) {
    return 'バージョン $version ($buildNumber)';
  }

  @override
  String get yahooAttributionLabel => 'Web Services by Yahoo! JAPAN';

  @override
  String get nameRequiredGeneric => '名前を入力してください';

  @override
  String fetchInventoryTypesFailed(String message) {
    return '在庫の種類の取得に失敗しました: $message';
  }

  @override
  String get noInventoryTypesFound => '在庫の種類（手芸用品など）が見つかりませんでした';

  @override
  String get addCategoryTitle => '新しいカテゴリーを追加';

  @override
  String get categoryNameHint => 'カテゴリー名（例: 布）';

  @override
  String get duplicateCategoryName => '同じ名前のカテゴリーがすでに登録されています';

  @override
  String get editCategoryTitle => 'カテゴリーを編集';

  @override
  String get categoryNameLabel => 'カテゴリー名';

  @override
  String get subCategoryNameHint => 'サブカテゴリー名（例: フェルト）';

  @override
  String get duplicateSubCategoryName => 'このカテゴリーには同じ名前のサブカテゴリーがすでに登録されています';

  @override
  String editSubCategoryOfCategory(String categoryName) {
    return '「$categoryName」のサブカテゴリーを編集';
  }

  @override
  String get subCategoryNameLabel => 'サブカテゴリー名';

  @override
  String fetchColorGroupsFailed(String message) {
    return '色系統の取得に失敗しました: $message';
  }

  @override
  String get noColorGroupsFound => '色系統が見つかりませんでした';

  @override
  String get addColorOptionTitle => '新しい色を追加';

  @override
  String get editColorOptionTitle => '色を編集';

  @override
  String get selectColorTitle => '色を選択';

  @override
  String get decide => '決定';

  @override
  String get colorNameRequiredError => '色名を入力してください';

  @override
  String get duplicateColorName => '同じ名前の色がすでに登録されています';

  @override
  String get colorNameHint => '色名（例: 水色）';

  @override
  String get hexCodeHint => 'カラーコード（任意, 例: #64B5F6）';

  @override
  String get addUnitTitle => '新しい単位を追加';

  @override
  String get unitNameHint => '単位名（例: 巻）';

  @override
  String get duplicateUnitName => '同じ名前の単位がすでに登録されています';

  @override
  String get editUnitTitle => '単位を編集';

  @override
  String get unitNameLabel => '単位名';
}
