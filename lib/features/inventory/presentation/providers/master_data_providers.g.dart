// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'master_data_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(categoryList)
final categoryListProvider = CategoryListProvider._();

final class CategoryListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Category>>,
          List<Category>,
          Stream<List<Category>>
        >
    with $FutureModifier<List<Category>>, $StreamProvider<List<Category>> {
  CategoryListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'categoryListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$categoryListHash();

  @$internal
  @override
  $StreamProviderElement<List<Category>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<Category>> create(Ref ref) {
    return categoryList(ref);
  }
}

String _$categoryListHash() => r'a2d928661cc45fa4fbf9a4865f54a87fff67be89';

@ProviderFor(subCategoryList)
final subCategoryListProvider = SubCategoryListFamily._();

final class SubCategoryListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SubCategory>>,
          List<SubCategory>,
          Stream<List<SubCategory>>
        >
    with
        $FutureModifier<List<SubCategory>>,
        $StreamProvider<List<SubCategory>> {
  SubCategoryListProvider._({
    required SubCategoryListFamily super.from,
    required int? super.argument,
  }) : super(
         retry: null,
         name: r'subCategoryListProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$subCategoryListHash();

  @override
  String toString() {
    return r'subCategoryListProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  $StreamProviderElement<List<SubCategory>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<SubCategory>> create(Ref ref) {
    final argument = this.argument as int?;
    return subCategoryList(ref, categoryId: argument);
  }

  @override
  bool operator ==(Object other) {
    return other is SubCategoryListProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$subCategoryListHash() => r'2ef3993dd8a97397c13b3cf1796653893681e360';

final class SubCategoryListFamily extends $Family
    with $FunctionalFamilyOverride<Stream<List<SubCategory>>, int?> {
  SubCategoryListFamily._()
    : super(
        retry: null,
        name: r'subCategoryListProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  SubCategoryListProvider call({int? categoryId}) =>
      SubCategoryListProvider._(argument: categoryId, from: this);

  @override
  String toString() => r'subCategoryListProvider';
}

@ProviderFor(colorGroupList)
final colorGroupListProvider = ColorGroupListProvider._();

final class ColorGroupListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ColorGroup>>,
          List<ColorGroup>,
          Stream<List<ColorGroup>>
        >
    with $FutureModifier<List<ColorGroup>>, $StreamProvider<List<ColorGroup>> {
  ColorGroupListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'colorGroupListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$colorGroupListHash();

  @$internal
  @override
  $StreamProviderElement<List<ColorGroup>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ColorGroup>> create(Ref ref) {
    return colorGroupList(ref);
  }
}

String _$colorGroupListHash() => r'c8d30ef8ff821c91a53f80b88230c8e59ec3bf5d';

@ProviderFor(colorOptionList)
final colorOptionListProvider = ColorOptionListProvider._();

final class ColorOptionListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<ColorOption>>,
          List<ColorOption>,
          Stream<List<ColorOption>>
        >
    with
        $FutureModifier<List<ColorOption>>,
        $StreamProvider<List<ColorOption>> {
  ColorOptionListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'colorOptionListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$colorOptionListHash();

  @$internal
  @override
  $StreamProviderElement<List<ColorOption>> $createElement(
    $ProviderPointer pointer,
  ) => $StreamProviderElement(pointer);

  @override
  Stream<List<ColorOption>> create(Ref ref) {
    return colorOptionList(ref);
  }
}

String _$colorOptionListHash() => r'47ddb0915e5a34a3d6f409daab69aa6f2df6e2f0';

@ProviderFor(unitList)
final unitListProvider = UnitListProvider._();

final class UnitListProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Unit>>,
          List<Unit>,
          Stream<List<Unit>>
        >
    with $FutureModifier<List<Unit>>, $StreamProvider<List<Unit>> {
  UnitListProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unitListProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unitListHash();

  @$internal
  @override
  $StreamProviderElement<List<Unit>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Unit>> create(Ref ref) {
    return unitList(ref);
  }
}

String _$unitListHash() => r'f7a4563928e63c6845a4c0357853dcc5876930ba';
