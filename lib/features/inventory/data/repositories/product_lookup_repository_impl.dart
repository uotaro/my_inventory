import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/repositories/product_lookup_repository.dart';
import '../local/app_database.dart' as local;
import '../local/app_database_provider.dart';
import '../remote/yahoo_shopping_api_client.dart';

part 'product_lookup_repository_impl.g.dart';

class ProductLookupRepositoryImpl implements ProductLookupRepository {
  ProductLookupRepositoryImpl(this._db, this._apiClient);

  final local.AppDatabase _db;
  final YahooShoppingApiClient _apiClient;

  @override
  Future<String?> lookupName(String barcode) async {
    final cached = await (_db.select(
      _db.productNameCache,
    )..where((t) => t.barcode.equals(barcode))).getSingleOrNull();
    if (cached != null) return cached.name;

    return _apiClient.searchNameByJanCode(barcode);
  }

  @override
  Future<void> saveName(String barcode, String name) async {
    await _db
        .into(_db.productNameCache)
        .insertOnConflictUpdate(
          local.ProductNameCacheCompanion.insert(barcode: barcode, name: name),
        );
  }
}

@Riverpod(keepAlive: true)
ProductLookupRepository productLookupRepository(Ref ref) {
  return ProductLookupRepositoryImpl(
    ref.watch(appDatabaseProvider),
    YahooShoppingApiClient(),
  );
}
