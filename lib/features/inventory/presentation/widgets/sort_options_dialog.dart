import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_inventory/l10n/app_localizations.dart';

import '../providers/item_filter_controller.dart';

Future<void> showSortOptionsDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => const _SortOptionsDialog(),
  );
}

class _SortOptionsDialog extends ConsumerStatefulWidget {
  const _SortOptionsDialog();

  @override
  ConsumerState<_SortOptionsDialog> createState() => _SortOptionsDialogState();
}

class _SortOptionsDialogState extends ConsumerState<_SortOptionsDialog> {
  late ItemSortKey? _sortKey;
  late bool _sortAscending;

  @override
  void initState() {
    super.initState();
    final filter = ref.read(itemFilterControllerProvider);
    _sortKey = filter.sortKey;
    _sortAscending = filter.sortAscending;
  }

  String _labelFor(L10n l10n, ItemSortKey key) {
    switch (key) {
      case ItemSortKey.name:
        return l10n.sortByNameLabel;
      case ItemSortKey.quantity:
        return l10n.sortByQuantityLabel;
      case ItemSortKey.favorite:
        return l10n.sortByFavoriteLabel;
      case ItemSortKey.category:
        return l10n.categoryLabel;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return AlertDialog(
      title: Text(l10n.sortDialogTitle),
      content: RadioGroup<ItemSortKey>(
        groupValue: _sortKey,
        onChanged: (value) => setState(() => _sortKey = value),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ...ItemSortKey.values.map(
              (key) => RadioListTile<ItemSortKey>(
                value: key,
                title: Text(_labelFor(l10n, key)),
              ),
            ),
            const Divider(),
            SwitchListTile(
              title: Text(
                _sortAscending ? l10n.sortAscendingLabel : l10n.sortDescendingLabel,
              ),
              value: _sortAscending,
              onChanged: _sortKey == null
                  ? null
                  : (value) => setState(() => _sortAscending = value),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref.read(itemFilterControllerProvider.notifier).clearSort();
            Navigator.pop(context);
          },
          child: Text(l10n.sortResetLabel),
        ),
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.cancel),
        ),
        FilledButton(
          onPressed: () {
            final key = _sortKey;
            final notifier = ref.read(itemFilterControllerProvider.notifier);
            if (key == null) {
              notifier.clearSort();
            } else {
              notifier.setSort(key, ascending: _sortAscending);
            }
            Navigator.pop(context);
          },
          child: Text(l10n.ok),
        ),
      ],
    );
  }
}
