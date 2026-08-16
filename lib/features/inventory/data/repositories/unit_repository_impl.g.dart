// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'unit_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(unitRepository)
final unitRepositoryProvider = UnitRepositoryProvider._();

final class UnitRepositoryProvider
    extends $FunctionalProvider<UnitRepository, UnitRepository, UnitRepository>
    with $Provider<UnitRepository> {
  UnitRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'unitRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$unitRepositoryHash();

  @$internal
  @override
  $ProviderElement<UnitRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  UnitRepository create(Ref ref) {
    return unitRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(UnitRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<UnitRepository>(value),
    );
  }
}

String _$unitRepositoryHash() => r'd2a353084afb0d71668724b05d2b0515866efafd';
