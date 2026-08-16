// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'color_group_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(colorGroupRepository)
final colorGroupRepositoryProvider = ColorGroupRepositoryProvider._();

final class ColorGroupRepositoryProvider
    extends
        $FunctionalProvider<
          ColorGroupRepository,
          ColorGroupRepository,
          ColorGroupRepository
        >
    with $Provider<ColorGroupRepository> {
  ColorGroupRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'colorGroupRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$colorGroupRepositoryHash();

  @$internal
  @override
  $ProviderElement<ColorGroupRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  ColorGroupRepository create(Ref ref) {
    return colorGroupRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ColorGroupRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ColorGroupRepository>(value),
    );
  }
}

String _$colorGroupRepositoryHash() =>
    r'eace0cad7be80f7cd5339b379215a7aaa0762149';
