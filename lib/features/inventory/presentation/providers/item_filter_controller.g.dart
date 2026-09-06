// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_filter_controller.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(ItemFilterController)
final itemFilterControllerProvider = ItemFilterControllerProvider._();

final class ItemFilterControllerProvider
    extends $NotifierProvider<ItemFilterController, ItemFilter> {
  ItemFilterControllerProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'itemFilterControllerProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$itemFilterControllerHash();

  @$internal
  @override
  ItemFilterController create() => ItemFilterController();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ItemFilter value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ItemFilter>(value),
    );
  }
}

String _$itemFilterControllerHash() =>
    r'f79c2bd7665e7264f4ca0ae77be9d46722d0a26e';

abstract class _$ItemFilterController extends $Notifier<ItemFilter> {
  ItemFilter build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ItemFilter, ItemFilter>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ItemFilter, ItemFilter>,
              ItemFilter,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
