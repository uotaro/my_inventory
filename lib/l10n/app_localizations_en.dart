// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class L10nEn extends L10n {
  L10nEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'My Inventory';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get save => 'Save';

  @override
  String get add => 'Add';

  @override
  String get ok => 'OK';

  @override
  String get errorTitle => 'Error';

  @override
  String get confirmDeleteTitle => 'Confirm Delete';

  @override
  String get unset => 'Not set';

  @override
  String get all => 'All';

  @override
  String errorWithMessage(String message) {
    return 'Error: $message';
  }

  @override
  String saveFailedWithMessage(String message) {
    return 'Failed to save: $message';
  }

  @override
  String deleteFailedWithMessage(String message) {
    return 'Failed to delete: $message';
  }

  @override
  String confirmDeleteNamedMessage(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get itemListTitle => 'Inventory';

  @override
  String get searchBarcodeTooltip => 'Search by barcode';

  @override
  String get sortTooltip => 'Sort';

  @override
  String get sortDialogTitle => 'Sort Settings';

  @override
  String get sortByNameLabel => 'Name';

  @override
  String get sortByQuantityLabel => 'Quantity';

  @override
  String get sortByFavoriteLabel => 'Favorite';

  @override
  String get sortAscendingLabel => 'Ascending';

  @override
  String get sortDescendingLabel => 'Descending';

  @override
  String get sortResetLabel => 'Reset';

  @override
  String get masterDataTooltip => 'Manage master data';

  @override
  String get appInfoTooltip => 'App info';

  @override
  String get searchByNameLabel => 'Search by name';

  @override
  String get categoryLabel => 'Category';

  @override
  String get colorGroupLabel => 'Color group';

  @override
  String get colorGroupBlue => 'Blue';

  @override
  String get colorGroupRed => 'Red';

  @override
  String get colorGroupGreen => 'Green';

  @override
  String get colorGroupYellow => 'Yellow';

  @override
  String get colorGroupMonochrome => 'Black, White & Gray';

  @override
  String get colorGroupBeigeBrown => 'Beige & Brown';

  @override
  String get colorGroupPatternOther => 'Pattern & Other';

  @override
  String get subCategoryLabel => 'Subcategory';

  @override
  String get filterByFavoriteLabel => 'Filter by favorite';

  @override
  String get favoriteFilterDialogTitle => 'Filter by Favorite';

  @override
  String get favoriteMinLabel => 'Min';

  @override
  String get favoriteMaxLabel => 'Max';

  @override
  String get favoriteRangeAny => 'Any';

  @override
  String favoriteRangeAtLeast(int min) {
    return '$min+ stars';
  }

  @override
  String favoriteRangeAtMost(int max) {
    return 'Up to $max stars';
  }

  @override
  String favoriteRangeBetween(int min, int max) {
    return '$min–$max stars';
  }

  @override
  String favoriteRangeExact(int value) {
    return '$value stars';
  }

  @override
  String get inStockOnlyLabel => 'Show in-stock only';

  @override
  String get noMatchingItems => 'No matching items';

  @override
  String get itemNotFoundCreatingNew =>
      'No matching item found. Creating a new one';

  @override
  String get manualAdjustmentReason => 'Manual adjustment';

  @override
  String get editItemTitle => 'Edit Item';

  @override
  String get addItemTitle => 'Add Item';

  @override
  String get selectCategoryAndUnit => 'Please select a category and a unit';

  @override
  String get barcodeAlreadyRegistered =>
      'This barcode is already registered to another item';

  @override
  String confirmDeleteItemMessage(String name) {
    return 'Delete \"$name\"?';
  }

  @override
  String get nameLabel => 'Name *';

  @override
  String get nameRequiredError => 'Name is required';

  @override
  String get clearInputTooltip => 'Clear input';

  @override
  String get categoryLabelRequired => 'Category *';

  @override
  String get selectCategoryFirst => 'Please select a category first';

  @override
  String get colorLabel => 'Color';

  @override
  String get unitLabelRequired => 'Unit *';

  @override
  String get favoriteRatingLabel => 'Favorite';

  @override
  String get quantityLabel => 'Quantity *';

  @override
  String get invalidNumberError => 'Please enter a number';

  @override
  String get negativeNumberError => 'Please enter a number of 0 or more';

  @override
  String get lowStockThresholdLabel => 'Low stock threshold';

  @override
  String get barcodeLabel => 'Barcode (type or scan)';

  @override
  String get memoLabel => 'Memo';

  @override
  String get takePhoto => 'Take photo';

  @override
  String get chooseFromGallery => 'Choose from gallery';

  @override
  String get deleteImageLabel => 'Remove image';

  @override
  String get registerButtonLabel => 'Register';

  @override
  String get scanBarcodeTitle => 'Scan Barcode';

  @override
  String get scanConfirmingLabel => 'Confirming...';

  @override
  String get masterDataTitle => 'Manage Master Data';

  @override
  String get categoriesTab => 'Categories';

  @override
  String get subCategoriesTab => 'Subcategories';

  @override
  String get colorsTab => 'Colors';

  @override
  String get unitsTab => 'Units';

  @override
  String get privacyPolicyLabel => 'Privacy Policy';

  @override
  String get failedToOpenLink => 'Failed to open the link';

  @override
  String inUseCannotDelete(String name, int count) {
    return '\"$name\" is used by $count item(s) and cannot be deleted';
  }

  @override
  String get noCategoriesRegistered => 'No categories registered';

  @override
  String addSubCategoryToCategory(String categoryName) {
    return 'Add subcategory to \"$categoryName\"';
  }

  @override
  String get noSubCategories => 'No subcategories';

  @override
  String confirmDeleteSubCategoryMessage(String name) {
    return 'Delete \"$name\"?\nItems using this subcategory will be set to unset.';
  }

  @override
  String get noColorsRegistered => 'No colors registered';

  @override
  String confirmDeleteColorMessage(String name) {
    return 'Delete \"$name\"?\nItems using this color will be set to unset.';
  }

  @override
  String get noUnitsRegistered => 'No units registered';

  @override
  String get appInfoTitle => 'App Info';

  @override
  String appVersionWithBuild(String version, String buildNumber) {
    return 'Version $version ($buildNumber)';
  }

  @override
  String get yahooAttributionLabel => 'Web Services by Yahoo! JAPAN';

  @override
  String get nameRequiredGeneric => 'Please enter a name';

  @override
  String fetchInventoryTypesFailed(String message) {
    return 'Failed to fetch inventory types: $message';
  }

  @override
  String get noInventoryTypesFound => 'No inventory types found';

  @override
  String get addCategoryTitle => 'Add Category';

  @override
  String get categoryNameHint => 'Category name (e.g. Fabric)';

  @override
  String get duplicateCategoryName =>
      'A category with this name already exists';

  @override
  String get editCategoryTitle => 'Edit Category';

  @override
  String get categoryNameLabel => 'Category name';

  @override
  String get subCategoryNameHint => 'Subcategory name (e.g. Felt)';

  @override
  String get duplicateSubCategoryName =>
      'A subcategory with this name already exists in this category';

  @override
  String editSubCategoryOfCategory(String categoryName) {
    return 'Edit subcategory of \"$categoryName\"';
  }

  @override
  String get subCategoryNameLabel => 'Subcategory name';

  @override
  String fetchColorGroupsFailed(String message) {
    return 'Failed to fetch color groups: $message';
  }

  @override
  String get noColorGroupsFound => 'No color groups found';

  @override
  String get addColorOptionTitle => 'Add Color';

  @override
  String get editColorOptionTitle => 'Edit Color';

  @override
  String get selectColorTitle => 'Select Color';

  @override
  String get decide => 'OK';

  @override
  String get colorNameRequiredError => 'Please enter a color name';

  @override
  String get duplicateColorName => 'A color with this name already exists';

  @override
  String get colorNameHint => 'Color name (e.g. Light blue)';

  @override
  String get hexCodeHint => 'Color code (optional, e.g. #64B5F6)';

  @override
  String get addUnitTitle => 'Add Unit';

  @override
  String get unitNameHint => 'Unit name (e.g. Roll)';

  @override
  String get duplicateUnitName => 'A unit with this name already exists';

  @override
  String get editUnitTitle => 'Edit Unit';

  @override
  String get unitNameLabel => 'Unit name';
}
