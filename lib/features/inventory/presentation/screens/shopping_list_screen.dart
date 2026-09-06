import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_slidable/flutter_slidable.dart';

import 'package:my_inventory/l10n/app_localizations.dart';

import '../../data/local/item_image_storage.dart';
import '../../data/repositories/shopping_list_repository_impl.dart';
import '../../domain/entities/shopping_list_entry.dart';
import '../providers/shopping_list_provider.dart';
import '../widgets/color_hex.dart';

class ShoppingListScreen extends ConsumerWidget {
  const ShoppingListScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final entriesAsync = ref.watch(shoppingListProvider);
    final entries = entriesAsync.value ?? const <ShoppingListEntry>[];
    final canPurchaseAll = entries.any((e) => e.purchaseQuantity > 0);

    return Scaffold(
      appBar: AppBar(title: Text(l10n.shoppingListTitle)),
      body: entriesAsync.when(
        data: (list) => list.isEmpty
            ? Center(child: Text(l10n.shoppingListEmptyMessage))
            : ListView.separated(
                itemCount: list.length,
                separatorBuilder: (_, _) => const Divider(height: 1),
                itemBuilder: (context, index) =>
                    _ShoppingListTile(entry: list[index]),
              ),
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) =>
            Center(child: Text(l10n.errorWithMessage(error.toString()))),
      ),
      bottomNavigationBar: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton(
                onPressed: canPurchaseAll
                    ? () => ref
                          .read(shoppingListRepositoryProvider)
                          .purchaseAll(reason: l10n.shoppingListPurchaseReason)
                    : null,
                child: Text(l10n.purchaseAllButton),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: Text('< ${l10n.backToItemListButton}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> _editPurchaseQuantity(
  BuildContext context,
  WidgetRef ref,
  ShoppingListEntry entry,
) async {
  final l10n = L10n.of(context);
  final formKey = GlobalKey<FormState>();
  final controller = TextEditingController(
    text: entry.purchaseQuantity.toString(),
  );

  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.purchaseQuantityLabel),
      content: Form(
        key: formKey,
        child: TextFormField(
          controller: controller,
          autofocus: true,
          textAlign: TextAlign.center,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(labelText: l10n.purchaseQuantityLabel),
          validator: (value) {
            final parsed = double.tryParse(value?.trim() ?? '');
            if (parsed == null) return l10n.invalidNumberError;
            if (parsed < 0) return l10n.negativeNumberError;
            return null;
          },
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            if (formKey.currentState?.validate() ?? false) {
              Navigator.pop(context, true);
            }
          },
          child: Text(l10n.save),
        ),
      ],
    ),
  );

  if (confirmed == true) {
    final parsed = double.parse(controller.text.trim());
    await ref
        .read(shoppingListRepositoryProvider)
        .setPurchaseQuantity(entry.id, parsed);
  }
  controller.dispose();
}

class _ShoppingListTile extends ConsumerWidget {
  const _ShoppingListTile({required this.entry});

  final ShoppingListEntry entry;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final item = entry.item;
    final swatchColor = parseHexColor(item.color?.hexCode);
    final imageFile = item.imagePath == null
        ? null
        : resolveItemImageFile(item.imagePath!);
    final hasImage = imageFile != null && imageFile.existsSync();

    final subtitleParts = [
      item.inventoryType.name,
      item.category.name,
      if (item.subCategory != null) item.subCategory!.name,
      if (item.color != null) item.color!.name,
    ];

    return Slidable(
      key: ValueKey(entry.id),
      endActionPane: ActionPane(
        motion: const DrawerMotion(),
        extentRatio: 0.25,
        children: [
          SlidableAction(
            onPressed: (_) =>
                ref.read(shoppingListRepositoryProvider).removeEntry(entry.id),
            backgroundColor: Colors.red,
            foregroundColor: Colors.white,
            icon: Icons.remove_shopping_cart,
            label: l10n.removeFromShoppingListLabel,
          ),
        ],
      ),
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
        subtitle: Text(
          subtitleParts.join(' / '),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
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
                  .read(shoppingListRepositoryProvider)
                  .setPurchaseQuantity(entry.id, entry.purchaseQuantity - 1),
            ),
            InkWell(
              onTap: () => _editPurchaseQuantity(context, ref, entry),
              child: SizedBox(
                width: 40,
                child: Text(
                  '${entry.purchaseQuantity} ${item.unit.name}',
                  textAlign: TextAlign.center,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              iconSize: 20,
              visualDensity: VisualDensity.compact,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(minWidth: 32, minHeight: 32),
              onPressed: () => ref
                  .read(shoppingListRepositoryProvider)
                  .setPurchaseQuantity(entry.id, entry.purchaseQuantity + 1),
            ),
            SizedBox(
              width: 32,
              height: 32,
              child: entry.purchaseQuantity > 0
                  ? IconButton(
                      icon: const Icon(Icons.shopping_cart_checkout),
                      tooltip: l10n.purchaseTooltip,
                      iconSize: 20,
                      visualDensity: VisualDensity.compact,
                      padding: EdgeInsets.zero,
                      constraints: const BoxConstraints(
                        minWidth: 32,
                        minHeight: 32,
                      ),
                      onPressed: () => ref
                          .read(shoppingListRepositoryProvider)
                          .purchaseEntry(
                            entry.id,
                            reason: l10n.shoppingListPurchaseReason,
                          ),
                    )
                  : null,
            ),
          ],
        ),
      ),
    );
  }
}
