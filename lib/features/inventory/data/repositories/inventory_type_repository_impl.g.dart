// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'inventory_type_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(inventoryTypeRepository)
final inventoryTypeRepositoryProvider = InventoryTypeRepositoryProvider._();

final class InventoryTypeRepositoryProvider
    extends
        $FunctionalProvider<
          InventoryTypeRepository,
          InventoryTypeRepository,
          InventoryTypeRepository
        >
    with $Provider<InventoryTypeRepository> {
  InventoryTypeRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'inventoryTypeRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$inventoryTypeRepositoryHash();

  @$internal
  @override
  $ProviderElement<InventoryTypeRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  InventoryTypeRepository create(Ref ref) {
    return inventoryTypeRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(InventoryTypeRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<InventoryTypeRepository>(value),
    );
  }
}

String _$inventoryTypeRepositoryHash() =>
    r'6a2505106613e91e5b2b38e6fe19777a2286c201';
