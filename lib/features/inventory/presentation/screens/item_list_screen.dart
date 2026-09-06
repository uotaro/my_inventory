import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:my_inventory/l10n/app_localizations.dart';

import '../../data/local/item_image_storage.dart';
import '../../data/repositories/item_repository_impl.dart';
import '../../data/repositories/product_lookup_repository_impl.dart';
import '../../data/repositories/shopping_list_repository_impl.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/sub_category.dart';
import '../providers/filtered_items_provider.dart';
import '../providers/item_filter_controller.dart';
import '../providers/master_data_providers.dart';
import '../providers/shopping_list_provider.dart';
import '../widgets/color_group_label.dart';
import '../widgets/color_hex.dart';
import '../widgets/favorite_filter_dialog.dart';
import '../widgets/favorite_stars.dart';
import '../widgets/sort_options_dialog.dart';
import 'app_info_screen.dart';
import 'barcode_scanner_screen.dart';
import 'item_form_screen.dart';
import 'master_data_screen.dart';
import 'shopping_list_screen.dart';

Future<void> _scanAndLookup(BuildContext context, WidgetRef ref) async {
  final code = await scanBarcode(context);
  if (code == null || !context.mounted) return;

  final item = await ref.read(itemRepositoryProvider).findByBarcode(code);
  if (!context.mounted) return;

  String? suggestedName;
  if (item == null) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (_) => const Center(child: CircularProgressIndicator()),
    );
    suggestedName = await ref
        .read(productLookupRepositoryProvider)
        .lookupName(code);
    if (!context.mounted) return;
    Navigator.pop(context);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(L10n.of(context).itemNotFoundCreatingNew)),
    );
  }

  await Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => ItemFormScreen(
        initialItem: item,
        initialBarcode: item == null ? code : null,
        initialName: suggestedName,
      ),
    ),
  );
}

class ItemListScreen extends ConsumerStatefulWidget {
  const ItemListScreen({super.key});

  @override
  ConsumerState<ItemListScreen> createState() => _ItemListScreenState();
}

class _ItemListScreenState extends ConsumerState<ItemListScreen> {
  late final TextEditingController _searchController;

  @override
  void initState() {
    super.initState();
    _searchController = TextEditingController();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  String _favoriteRangeSummary(L10n l10n, int? min, int? max) {
    if (min == null && max == null) return l10n.favoriteRangeAny;
    if (min != null && max != null) {
      return min == max
          ? l10n.favoriteRangeExact(min)
          : l10n.favoriteRangeBetween(min, max);
    }
    if (min != null) return l10n.favoriteRangeAtLeast(min);
    return l10n.favoriteRangeAtMost(max!);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final filter = ref.watch(itemFilterControllerProvider);
    final filterController = ref.read(itemFilterControllerProvider.notifier);
    final inventoryTypes = ref.watch(inventoryTypeListProvider).value ?? [];
    final categories =
        ref
            .watch(
              categoryListProvider(inventoryTypeId: filter.inventoryTypeId),
            )
            .value ??
        [];
    final subCategories = filter.categoryId == null
        ? <SubCategory>[]
        : ref
                  .watch(subCategoryListProvider(categoryId: filter.categoryId))
                  .value ??
              [];
    final colorGroups = ref.watch(colorGroupListProvider).value ?? [];
    final itemsAsync = ref.watch(filteredItemsProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.itemListTitle),
        actions: [
          IconButton(
            icon: const Icon(Icons.qr_code_scanner),
            tooltip: l10n.searchBarcodeTooltip,
            onPressed: () => _scanAndLookup(context, ref),
          ),
          IconButton(
            icon: const Icon(Icons.sort),
            tooltip: l10n.sortTooltip,
            onPressed: () => showSortOptionsDialog(context),
          ),
          IconButton(
            icon: const Icon(Icons.shopping_cart_outlined),
            tooltip: l10n.shoppingListTooltip,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const ShoppingListScreen(),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: l10n.masterDataTooltip,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const MasterDataScreen()),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.info_outline),
            tooltip: l10n.appInfoTooltip,
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const AppInfoScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                labelText: l10n.searchByNameLabel,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: IconButton(
                  icon: const Icon(Icons.restart_alt),
                  tooltip: l10n.searchResetTooltip,
                  onPressed: () {
                    _searchController.clear();
                    filterController.resetSearchConditions();
                  },
                ),
              ),
              onChanged: filterController.setNameQuery,
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: filter.inventoryTypeId,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: l10n.inventoryTypeLabel,
                    ),
                    items: [
                      DropdownMenuItem(value: null, child: Text(l10n.all)),
                      ...inventoryTypes.map(
                        (t) => DropdownMenuItem(
                          value: t.id,
                          child: Text(
                            t.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                    onChanged: filterController.setInventoryType,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: filter.categoryId,
                    isExpanded: true,
                    decoration: InputDecoration(labelText: l10n.categoryLabel),
                    items: [
                      DropdownMenuItem(value: null, child: Text(l10n.all)),
                      ...categories.map(
                        (c) => DropdownMenuItem(
                          value: c.id,
                          child: Text(
                            c.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                    onChanged: filterController.setCategory,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: filter.subCategoryId,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: l10n.subCategoryLabel,
                    ),
                    items: [
                      DropdownMenuItem(value: null, child: Text(l10n.all)),
                      ...subCategories.map(
                        (s) => DropdownMenuItem(
                          value: s.id,
                          child: Text(
                            s.name,
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                    onChanged: filter.categoryId == null
                        ? null
                        : filterController.setSubCategory,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
            child: Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: filter.colorGroupId,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: l10n.colorGroupLabel,
                    ),
                    items: [
                      DropdownMenuItem(value: null, child: Text(l10n.all)),
                      ...colorGroups.map(
                        (g) => DropdownMenuItem(
                          value: g.id,
                          child: Text(
                            colorGroupLabel(context, g.name),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ],
                    onChanged: filterController.setColorGroup,
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: InkWell(
                    onTap: () => showFavoriteFilterDialog(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: l10n.filterByFavoriteLabel,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              _favoriteRangeSummary(
                                l10n,
                                filter.favoriteMin,
                                filter.favoriteMax,
                              ),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Icon(
                            Icons.arrow_drop_down,
                            color:
                                Theme.brightnessOf(context) == Brightness.light
                                ? Colors.grey.shade700
                                : Colors.white70,
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: DropdownButtonFormField<StockFilter>(
                    initialValue: filter.stockFilter,
                    isExpanded: true,
                    decoration: InputDecoration(
                      labelText: l10n.stockFilterLabel,
                    ),
                    items: [
                      DropdownMenuItem(
                        value: StockFilter.all,
                        child: Text(l10n.all),
                      ),
                      DropdownMenuItem(
                        value: StockFilter.inStock,
                        child: Text(l10n.stockFilterInStock),
                      ),
                      DropdownMenuItem(
                        value: StockFilter.lowStock,
                        child: Text(l10n.stockFilterLowStock),
                      ),
                      DropdownMenuItem(
                        value: StockFilter.zero,
                        child: Text(l10n.stockFilterZero),
                      ),
                    ],
                    onChanged: (value) {
                      if (value != null) filterController.setStockFilter(value);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 4),
          const Divider(height: 1),
          Expanded(
            child: ClipRect(
              child: itemsAsync.when(
                data: (items) => items.isEmpty
                    ? Center(child: Text(l10n.noMatchingItems))
                    : ListView.separated(
                        itemCount: items.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) =>
                            _ItemTile(item: items[index]),
                      ),
                loading: () => const Center(child: CircularProgressIndicator()),
                error: (error, stack) => Center(
                  child: Text(l10n.errorWithMessage(error.toString())),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => const ItemFormScreen()),
        ),
        child: const Icon(Icons.add),
      ),
    );
  }
}

Future<void> _confirmAndDeleteItem(
  BuildContext context,
  WidgetRef ref,
  Item item,
) async {
  final l10n = L10n.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.confirmDeleteTitle),
      content: Text(l10n.confirmDeleteItemMessage(item.name)),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: Colors.red),
          onPressed: () => Navigator.pop(context, true),
          child: Text(l10n.delete),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    await ref.read(itemRepositoryProvider).deleteItem(item.id);
  }
}

class _ItemTile extends ConsumerWidget {
  const _ItemTile({required this.item});

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final isLowStock = item.quantity <= item.lowStockThreshold;
    final swatchColor = parseHexColor(item.color?.hexCode);
    final imageFile = item.imagePath == null
        ? null
        : resolveItemImageFile(item.imagePath!);
    final hasImage = imageFile != null && imageFile.existsSync();
    final isInShoppingList =
        (ref.watch(shoppingListItemIdsProvider).value ?? const {}).contains(
          item.id,
        );

    final subtitleParts = [
      item.inventoryType.name,
      item.category.name,
      if (item.subCategory != null) item.subCategory!.name,
      if (item.color != null) item.color!.name,
    ];

    return Slidable(
      key: ValueKey(item.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.5,
        children: [
          SlidableAction(
            onPressed: isInShoppingList
                ? null
                : (_) =>
                      ref.read(shoppingListRepositoryProvider).addItem(item.id),
            backgroundColor: isInShoppingList ? Colors.grey : Colors.blue,
            foregroundColor: Colors.white,
            icon: Icons.add_shopping_cart,
            label: l10n.addToShoppingListLabel,
          ),
          SlidableAction(
            onPressed: (_) => _confirmAndDeleteItem(context, ref, item),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.delete,
            label: l10n.delete,
          ),
        ],
      ),
      child: Container(
        color: isLowStock ? const Color(0xFFFFCFD6) : null,
        child: ListTile(
          leading: hasImage
              ? CircleAvatar(backgroundImage: FileImage(imageFile))
              : CircleAvatar(
                  backgroundColor: swatchColor ?? Colors.grey.shade300,
                  child: swatchColor == null
                      ? Text(item.category.name.characters.first)
                      : null,
                ),
          title: Text(item.name, maxLines: 1, overflow: TextOverflow.ellipsis),
          subtitle: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                subtitleParts.join(' / '),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (item.favoriteRating > 0)
                FavoriteStarsDisplay(rating: item.favoriteRating, size: 14),
            ],
          ),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                icon: const Icon(Icons.remove_circle_outline),
                iconSize: 20,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: () => ref
                    .read(itemRepositoryProvider)
                    .adjustQuantity(
                      item.id,
                      -1,
                      reason: l10n.manualAdjustmentReason,
                    ),
              ),
              SizedBox(
                width: 40,
                child: Text(
                  '${item.quantity} ${item.unit.name}',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add_circle_outline),
                iconSize: 20,
                visualDensity: VisualDensity.compact,
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
                onPressed: () => ref
                    .read(itemRepositoryProvider)
                    .adjustQuantity(
                      item.id,
                      1,
                      reason: l10n.manualAdjustmentReason,
                    ),
              ),
            ],
          ),
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ItemFormScreen(initialItem: item),
            ),
          ),
        ),
      ),
    );
  }
}
