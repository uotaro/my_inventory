// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stock_log_repository_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(stockLogRepository)
final stockLogRepositoryProvider = StockLogRepositoryProvider._();

final class StockLogRepositoryProvider
    extends
        $FunctionalProvider<
          StockLogRepository,
          StockLogRepository,
          StockLogRepository
        >
    with $Provider<StockLogRepository> {
  StockLogRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'stockLogRepositoryProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$stockLogRepositoryHash();

  @$internal
  @override
  $ProviderElement<StockLogRepository> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  StockLogRepository create(Ref ref) {
    return stockLogRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(StockLogRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<StockLogRepository>(value),
    );
  }
}

String _$stockLogRepositoryHash() =>
    r'3cbaddbd575d5e31b48d9de99c9422e5af20b841';
