import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:my_inventory/l10n/app_localizations.dart';

import '../providers/item_filter_controller.dart';
import 'favorite_stars.dart';

Future<void> showFavoriteFilterDialog(BuildContext context) {
  return showDialog<void>(
    context: context,
    builder: (context) => const _FavoriteFilterDialog(),
  );
}

class _FavoriteFilterDialog extends ConsumerStatefulWidget {
  const _FavoriteFilterDialog();

  @override
  ConsumerState<_FavoriteFilterDialog> createState() =>
      _FavoriteFilterDialogState();
}

class _FavoriteFilterDialogState extends ConsumerState<_FavoriteFilterDialog> {
  // 0は「未指定」を表す。
  late int _min;
  late int _max;

  @override
  void initState() {
    super.initState();
    final filter = ref.read(itemFilterControllerProvider);
    _min = filter.favoriteMin ?? 0;
    _max = filter.favoriteMax ?? 0;
  }

  void _setMin(int value) {
    setState(() {
      _min = value;
      if (_max != 0 && _min > _max) _max = _min;
    });
  }

  void _setMax(int value) {
    setState(() {
      _max = value;
      if (_min != 0 && _max < _min) _min = _max;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);

    return AlertDialog(
      title: Text(l10n.favoriteFilterDialogTitle),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(l10n.favoriteMinLabel),
          FavoriteStarsInput(rating: _min, onChanged: _setMin),
          const SizedBox(height: 16),
          Text(l10n.favoriteMaxLabel),
          FavoriteStarsInput(rating: _max, onChanged: _setMax),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () {
            ref
                .read(itemFilterControllerProvider.notifier)
                .setFavoriteRange(null, null);
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
            ref
                .read(itemFilterControllerProvider.notifier)
                .setFavoriteRange(_min == 0 ? null : _min, _max == 0 ? null : _max);
            Navigator.pop(context);
          },
          child: Text(l10n.ok),
        ),
      ],
    );
  }
}
