// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sub_category_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(subCategoryRepository)
final subCategoryRepositoryProvider = SubCategoryRepositoryProvider._();

final class SubCategoryRepositoryProvider
    extends
        $FunctionalProvider<
          SubCategoryRepository,
          SubCategoryRepository,
          SubCategoryRepository
        >
    with $Provider<SubCategoryRepository> {
  SubCategoryRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'subCategoryRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$subCategoryRepositoryHash();

  @$internal
  @override
  $ProviderElement<SubCategoryRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SubCategoryRepository create(Ref ref) {
    return subCategoryRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SubCategoryRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SubCategoryRepository>(value),
    );
  }
}

String _$subCategoryRepositoryHash() =>
    r'1d03a79b0a8a7f491faea24bbaa8c12a50ccbe40';
