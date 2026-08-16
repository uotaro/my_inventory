// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_lookup_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(productLookupRepository)
final productLookupRepositoryProvider = ProductLookupRepositoryProvider._();

final class ProductLookupRepositoryProvider
    extends
        $FunctionalProvider<
          ProductLookupRepository,
          ProductLookupRepository,
          ProductLookupRepository
        >
    with $Provider<ProductLookupRepository> {
  ProductLookupRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'productLookupRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$productLookupRepositoryHash();

  @$internal
  @override
  $ProviderElement<ProductLookupRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ProductLookupRepository create(Ref ref) {
    return productLookupRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ProductLookupRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ProductLookupRepository>(value),
    );
  }
}

String _$productLookupRepositoryHash() =>
    r'86f88a5a1378885ac4c81b1529701f341d3c59c5';
