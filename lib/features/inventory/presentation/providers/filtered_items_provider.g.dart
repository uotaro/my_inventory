// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'filtered_items_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(filteredItems)
final filteredItemsProvider = FilteredItemsProvider._();

final class FilteredItemsProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<Item>>,
          List<Item>,
          Stream<List<Item>>
        >
    with $FutureModifier<List<Item>>, $StreamProvider<List<Item>> {
  FilteredItemsProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'filteredItemsProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$filteredItemsHash();

  @$internal
  @override
  $StreamProviderElement<List<Item>> $createElement($ProviderPointer pointer) =>
      $StreamProviderElement(pointer);

  @override
  Stream<List<Item>> create(Ref ref) {
    return filteredItems(ref);
  }
}

String _$filteredItemsHash() => r'6f6d5182ead05b9bd3737a8195270d2e91f8d79a';
