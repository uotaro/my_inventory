import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_inventory/l10n/app_localizations.dart';

import '../../data/local/item_image_storage.dart';
import '../../data/repositories/item_repository_impl.dart';
import '../../data/repositories/product_lookup_repository_impl.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/sub_category.dart';
import '../providers/filtered_items_provider.dart';
import '../providers/item_filter_controller.dart';
import '../providers/master_data_providers.dart';
import '../widgets/color_group_label.dart';
import '../widgets/color_hex.dart';
import '../widgets/favorite_filter_dialog.dart';
import '../widgets/favorite_stars.dart';
import '../widgets/sort_options_dialog.dart';
import 'app_info_screen.dart';
import 'barcode_scanner_screen.dart';
import 'item_form_screen.dart';
import 'master_data_screen.dart';

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
    final categories = ref.watch(categoryListProvider).value ?? [];
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
                    initialValue: filter.categoryId,
                    decoration: InputDecoration(labelText: l10n.categoryLabel),
                    items: [
                      DropdownMenuItem(value: null, child: Text(l10n.all)),
                      ...categories.map(
                        (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                      ),
                    ],
                    onChanged: filterController.setCategory,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: DropdownButtonFormField<int>(
                    initialValue: filter.colorGroupId,
                    decoration: InputDecoration(labelText: l10n.colorGroupLabel),
                    items: [
                      DropdownMenuItem(value: null, child: Text(l10n.all)),
                      ...colorGroups.map(
                        (g) => DropdownMenuItem(
                          value: g.id,
                          child: Text(colorGroupLabel(context, g.name)),
                        ),
                      ),
                    ],
                    onChanged: filterController.setColorGroup,
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
                    initialValue: filter.subCategoryId,
                    decoration: InputDecoration(labelText: l10n.subCategoryLabel),
                    items: [
                      DropdownMenuItem(value: null, child: Text(l10n.all)),
                      ...subCategories.map(
                        (s) => DropdownMenuItem(value: s.id, child: Text(s.name)),
                      ),
                    ],
                    onChanged: filter.categoryId == null
                        ? null
                        : filterController.setSubCategory,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: InkWell(
                    onTap: () => showFavoriteFilterDialog(context),
                    child: InputDecorator(
                      decoration: InputDecoration(
                        labelText: l10n.filterByFavoriteLabel,
                      ),
                      child: Text(
                        _favoriteRangeSummary(
                          l10n,
                          filter.favoriteMin,
                          filter.favoriteMax,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SwitchListTile(
            title: Text(l10n.inStockOnlyLabel),
            value: filter.inStockOnly,
            onChanged: filterController.setInStockOnly,
          ),
          const Divider(height: 1),
          Expanded(
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
              error: (error, stack) =>
                  Center(child: Text(l10n.errorWithMessage(error.toString()))),
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

class _ItemTile extends ConsumerWidget {
  const _ItemTile({required this.item});

  final Item item;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final isLowStock =
        item.lowStockThreshold != null &&
        item.quantity <= item.lowStockThreshold!;
    final swatchColor = parseHexColor(item.color?.hexCode);
    final imageFile = item.imagePath == null
        ? null
        : resolveItemImageFile(item.imagePath!);
    final hasImage = imageFile != null && imageFile.existsSync();

    final subtitleParts = [
      item.category.name,
      if (item.subCategory != null) item.subCategory!.name,
      if (item.color != null) item.color!.name,
    ];

    return ListTile(
      leading: hasImage
          ? CircleAvatar(backgroundImage: FileImage(imageFile))
          : CircleAvatar(
              backgroundColor: swatchColor ?? Colors.grey.shade300,
              child: swatchColor == null
                  ? Text(item.category.name.characters.first)
                  : null,
            ),
      title: Row(
        children: [
          Flexible(
            child: Text(
              item.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isLowStock) ...[
            const SizedBox(width: 6),
            const Icon(Icons.warning_amber, color: Colors.orange, size: 18),
          ],
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(subtitleParts.join(' / ')),
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
            onPressed: () => ref.read(itemRepositoryProvider).adjustQuantity(
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
            onPressed: () => ref.read(itemRepositoryProvider).adjustQuantity(
              item.id,
              1,
              reason: l10n.manualAdjustmentReason,
            ),
          ),
        ],
      ),
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ItemFormScreen(initialItem: item)),
      ),
    );
  }
}
