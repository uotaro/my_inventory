// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_option_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(colorOptionRepository)
final colorOptionRepositoryProvider = ColorOptionRepositoryProvider._();

final class ColorOptionRepositoryProvider
    extends
        $FunctionalProvider<
          ColorOptionRepository,
          ColorOptionRepository,
          ColorOptionRepository
        >
    with $Provider<ColorOptionRepository> {
  ColorOptionRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'colorOptionRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$colorOptionRepositoryHash();

  @$internal
  @override
  $ProviderElement<ColorOptionRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ColorOptionRepository create(Ref ref) {
    return colorOptionRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ColorOptionRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ColorOptionRepository>(value),
    );
  }
}

String _$colorOptionRepositoryHash() =>
    r'834963fdd0bf3a2af079d3c93df5130889b68037';
