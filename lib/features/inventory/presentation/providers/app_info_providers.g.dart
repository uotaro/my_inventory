// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_info_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(appPackageInfo)
final appPackageInfoProvider = AppPackageInfoProvider._();

final class AppPackageInfoProvider
    extends
        $FunctionalProvider<
          AsyncValue<PackageInfo>,
          PackageInfo,
          FutureOr<PackageInfo>
        >
    with $FutureModifier<PackageInfo>, $FutureProvider<PackageInfo> {
  AppPackageInfoProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appPackageInfoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$appPackageInfoHash();

  @$internal
  @override
  $FutureProviderElement<PackageInfo> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<PackageInfo> create(Ref ref) {
    return appPackageInfo(ref);
  }
}

String _$appPackageInfoHash() => r'2dd3515f51fdcb01b51d4a3c5a9c489d86823b82';
