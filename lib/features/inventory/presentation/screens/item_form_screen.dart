import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:my_inventory/l10n/app_localizations.dart';

import '../../data/local/item_image_storage.dart';
import '../../data/repositories/item_repository_impl.dart';
import '../../data/repositories/product_lookup_repository_impl.dart';
import '../../domain/entities/color_option.dart';
import '../../domain/entities/item.dart';
import '../../domain/entities/sub_category.dart';
import '../providers/master_data_providers.dart';
import '../widgets/add_master_data_dialogs.dart';
import '../widgets/color_hex.dart';
import '../widgets/favorite_stars.dart';
import 'barcode_scanner_screen.dart';

class ItemFormScreen extends ConsumerStatefulWidget {
  const ItemFormScreen({
    super.key,
    this.initialItem,
    this.initialBarcode,
    this.initialName,
  });

  /// null なら新規登録、値があれば編集。
  final Item? initialItem;

  /// 一覧画面でのバーコードスキャンにヒットしなかった場合、
  /// 新規登録フォームにスキャン済みのバーコードを引き継ぐために使う。
  final String? initialBarcode;

  /// バーコードから商品名検索（ローカルキャッシュ/外部API）で見つかった場合の
  /// 品名の初期値。新規登録フォームにのみ引き継ぐ。
  final String? initialName;

  @override
  ConsumerState<ItemFormScreen> createState() => _ItemFormScreenState();
}

class _ItemFormScreenState extends ConsumerState<ItemFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController _nameController;
  late final TextEditingController _barcodeController;
  late final TextEditingController _memoController;
  late final TextEditingController _quantityController;
  late final TextEditingController _lowStockThresholdController;

  int? _categoryId;
  int? _subCategoryId;
  int? _colorId;
  int? _unitId;
  String? _imagePath;
  int _favoriteRating = 0;

  bool get _isEditing => widget.initialItem != null;

  @override
  void initState() {
    super.initState();
    final item = widget.initialItem;
    _nameController = TextEditingController(
      text: item?.name ?? widget.initialName ?? '',
    );
    _barcodeController = TextEditingController(
      text: item?.barcode ?? widget.initialBarcode ?? '',
    );
    _memoController = TextEditingController(text: item?.memo ?? '');
    _quantityController = TextEditingController(
      text: item == null ? '1' : item.quantity.toString(),
    );
    _lowStockThresholdController = TextEditingController(
      text: item != null ? (item.lowStockThreshold?.toString() ?? '') : '0',
    );
    _categoryId = item?.category.id;
    _subCategoryId = item?.subCategory?.id;
    _colorId = item?.color?.id;
    _unitId = item?.unit.id;
    _imagePath = item?.imagePath;
    _favoriteRating = item?.favoriteRating ?? 0;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _barcodeController.dispose();
    _memoController.dispose();
    _quantityController.dispose();
    _lowStockThresholdController.dispose();
    super.dispose();
  }

  String? _emptyToNull(String value) {
    final trimmed = value.trim();
    return trimmed.isEmpty ? null : trimmed;
  }

  /// 現在選択中の色に登録されているカラーコード（無ければnull）。
  String? _selectedColorHexCode(List<ColorOption> colorOptions) {
    for (final option in colorOptions) {
      if (option.id == _colorId) return option.hexCode;
    }
    return null;
  }

  Future<void> _pickImage(ImageSource source) async {
    final picked = await ImagePicker().pickImage(source: source, maxWidth: 1600);
    if (picked == null) return;

    final savedPath = await saveItemImage(picked.path);
    if (mounted) setState(() => _imagePath = savedPath);
  }

  /// 小数点以下が不要な値は整数表記に丸めて表示する。
  String _formatStepValue(double value) {
    return value == value.roundToDouble()
        ? value.toInt().toString()
        : value.toString();
  }

  void _stepQuantity(double delta) {
    final current = double.tryParse(_quantityController.text.trim()) ?? 0;
    final next = (current + delta).clamp(0.0, double.infinity);
    setState(() => _quantityController.text = _formatStepValue(next));
  }

  void _stepLowStockThreshold(double delta) {
    final current =
        double.tryParse(_lowStockThresholdController.text.trim()) ?? 0;
    final next = (current + delta).clamp(0.0, double.infinity);
    setState(
      () => _lowStockThresholdController.text = _formatStepValue(next),
    );
  }

  Future<void> _scanBarcodeIntoField() async {
    final code = await scanBarcode(context);
    if (code == null || !mounted) return;
    setState(() => _barcodeController.text = code);

    // 新規登録で品名が未入力の場合のみ、バーコードから商品名を自動補完する。
    if (!_isEditing && _nameController.text.trim().isEmpty) {
      final name = await ref.read(productLookupRepositoryProvider).lookupName(code);
      if (name != null && mounted && _nameController.text.trim().isEmpty) {
        setState(() => _nameController.text = name);
      }
    }
  }

  Future<void> _submit() async {
    final l10n = L10n.of(context);
    if (!_formKey.currentState!.validate()) return;
    if (_categoryId == null || _unitId == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(l10n.selectCategoryAndUnit)));
      return;
    }

    final quantity = double.tryParse(_quantityController.text.trim()) ?? 0;
    final lowStockThresholdText = _lowStockThresholdController.text.trim();
    final lowStockThreshold = lowStockThresholdText.isEmpty
        ? null
        : double.tryParse(lowStockThresholdText);

    final repository = ref.read(itemRepositoryProvider);

    try {
      if (!_isEditing) {
        await repository.addItem(
          categoryId: _categoryId!,
          subCategoryId: _subCategoryId,
          colorId: _colorId,
          unitId: _unitId!,
          barcode: _emptyToNull(_barcodeController.text),
          name: _nameController.text.trim(),
          favoriteRating: _favoriteRating,
          quantity: quantity,
          lowStockThreshold: lowStockThreshold,
          imagePath: _imagePath,
          memo: _emptyToNull(_memoController.text),
        );
      } else {
        final categories = ref.read(categoryListProvider).value ?? [];
        final subCategories = _categoryId == null
            ? <SubCategory>[]
            : ref.read(subCategoryListProvider(categoryId: _categoryId)).value ??
                [];
        final colorOptions = ref.read(colorOptionListProvider).value ?? [];
        final units = ref.read(unitListProvider).value ?? [];

        final category = categories.firstWhere((c) => c.id == _categoryId);
        final subCategory = _subCategoryId == null
            ? null
            : subCategories.firstWhere((s) => s.id == _subCategoryId);
        final color = _colorId == null
            ? null
            : colorOptions.firstWhere((c) => c.id == _colorId);
        final unit = units.firstWhere((u) => u.id == _unitId);

        await repository.updateItem(
          widget.initialItem!.copyWith(
            category: category,
            subCategory: subCategory,
            color: color,
            unit: unit,
            barcode: _emptyToNull(_barcodeController.text),
            name: _nameController.text.trim(),
            favoriteRating: _favoriteRating,
            quantity: quantity,
            lowStockThreshold: lowStockThreshold,
            imagePath: _imagePath,
            memo: _emptyToNull(_memoController.text),
          ),
        );
      }
    } catch (e) {
      if (!mounted) return;
      final message = e.toString().contains('UNIQUE constraint')
          ? l10n.barcodeAlreadyRegistered
          : l10n.saveFailedWithMessage(e.toString());
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(message)));
      return;
    }

    // 確定した商品名をバーコードと紐づけて保存し、次回以降は外部APIを使わず解決できるようにする。
    final savedBarcode = _emptyToNull(_barcodeController.text);
    final savedName = _nameController.text.trim();
    if (savedBarcode != null && savedName.isNotEmpty) {
      await ref
          .read(productLookupRepositoryProvider)
          .saveName(savedBarcode, savedName);
    }

    if (mounted) Navigator.pop(context);
  }

  Future<void> _delete() async {
    final l10n = L10n.of(context);
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.confirmDeleteTitle),
        content: Text(l10n.confirmDeleteItemMessage(widget.initialItem!.name)),
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
      await ref.read(itemRepositoryProvider).deleteItem(widget.initialItem!.id);
      if (mounted) Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final categories = ref.watch(categoryListProvider).value ?? [];
    final subCategories = _categoryId == null
        ? <SubCategory>[]
        : ref.watch(subCategoryListProvider(categoryId: _categoryId)).value ??
            [];
    final colorOptions = ref.watch(colorOptionListProvider).value ?? [];
    final units = ref.watch(unitListProvider).value ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? l10n.editItemTitle : l10n.addItemTitle),
        actions: [
          if (_isEditing)
            IconButton(
              icon: const Icon(Icons.delete_outline),
              onPressed: _delete,
            ),
          IconButton(icon: const Icon(Icons.check), onPressed: _submit),
        ],
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _ImagePickerSection(
              imagePath: _imagePath,
              onPickCamera: () => _pickImage(ImageSource.camera),
              onPickGallery: () => _pickImage(ImageSource.gallery),
              onRemove: () => setState(() => _imagePath = null),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _barcodeController,
              decoration: InputDecoration(
                labelText: l10n.barcodeLabel,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.camera_alt_outlined),
                  onPressed: _scanBarcodeIntoField,
                ),
              ),
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.nameLabel,
                suffixIcon: IconButton(
                  icon: const Icon(Icons.clear),
                  tooltip: l10n.clearInputTooltip,
                  onPressed: () => setState(_nameController.clear),
                ),
              ),
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? l10n.nameRequiredError
                  : null,
            ),
            const SizedBox(height: 16),
            _DropdownWithAddButton(
              label: l10n.categoryLabelRequired,
              value: _categoryId,
              items: categories
                  .map((c) => DropdownMenuItem(value: c.id, child: Text(c.name)))
                  .toList(),
              onChanged: (value) => setState(() {
                _categoryId = value;
                _subCategoryId = null;
              }),
              onAdd: () => showAddCategoryDialog(context, ref),
            ),
            const SizedBox(height: 16),
            _DropdownWithAddButton(
              label: l10n.subCategoryLabel,
              value: _subCategoryId,
              items: <DropdownMenuItem<int>>[
                DropdownMenuItem(value: null, child: Text(l10n.unset)),
                ...subCategories.map(
                  (s) => DropdownMenuItem(value: s.id, child: Text(s.name)),
                ),
              ],
              onChanged: _categoryId == null
                  ? null
                  : (value) => setState(() => _subCategoryId = value),
              onAdd: () {
                if (_categoryId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.selectCategoryFirst)),
                  );
                  return;
                }
                final category = categories.firstWhere(
                  (c) => c.id == _categoryId,
                );
                showAddSubCategoryDialog(
                  context,
                  ref,
                  categoryId: category.id,
                  categoryName: category.name,
                );
              },
            ),
            const SizedBox(height: 16),
            _DropdownWithAddButton(
              label: l10n.colorLabel,
              value: _colorId,
              items: <DropdownMenuItem<int>>[
                DropdownMenuItem(value: null, child: Text(l10n.unset)),
                ...colorOptions.map(
                  (c) => DropdownMenuItem(value: c.id, child: Text(c.name)),
                ),
              ],
              onChanged: (value) => setState(() => _colorId = value),
              onAdd: () => showAddColorOptionDialog(context, ref),
              swatchColor: parseHexColor(_selectedColorHexCode(colorOptions)),
            ),
            const SizedBox(height: 16),
            _DropdownWithAddButton(
              label: l10n.unitLabelRequired,
              value: _unitId,
              items: units
                  .map((u) => DropdownMenuItem(value: u.id, child: Text(u.name)))
                  .toList(),
              onChanged: (value) => setState(() => _unitId = value),
              onAdd: () => showAddUnitDialog(context, ref),
            ),
            const SizedBox(height: 16),
            InputDecorator(
              decoration: InputDecoration(labelText: l10n.favoriteRatingLabel),
              child: FavoriteStarsInput(
                rating: _favoriteRating,
                onChanged: (value) => setState(() => _favoriteRating = value),
              ),
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => _stepQuantity(-1),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _quantityController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(labelText: l10n.quantityLabel),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      final parsed = double.tryParse(value?.trim() ?? '');
                      if (parsed == null) return l10n.invalidNumberError;
                      if (parsed < 0) return l10n.negativeNumberError;
                      return null;
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => _stepQuantity(1),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.remove_circle_outline),
                  onPressed: () => _stepLowStockThreshold(-1),
                ),
                Expanded(
                  child: TextFormField(
                    controller: _lowStockThresholdController,
                    textAlign: TextAlign.center,
                    decoration: InputDecoration(
                      labelText: l10n.lowStockThresholdLabel,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    validator: (value) {
                      final trimmed = value?.trim() ?? '';
                      if (trimmed.isEmpty) return null;
                      final parsed = double.tryParse(trimmed);
                      if (parsed == null) return l10n.invalidNumberError;
                      if (parsed < 0) return l10n.negativeNumberError;
                      return null;
                    },
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.add_circle_outline),
                  onPressed: () => _stepLowStockThreshold(1),
                ),
              ],
            ),
            const SizedBox(height: 16),
            TextFormField(
              controller: _memoController,
              decoration: InputDecoration(labelText: l10n.memoLabel),
              maxLines: 3,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: _submit,
              icon: const Icon(Icons.check),
              label: Text(l10n.registerButtonLabel),
            ),
            if (_isEditing) ...[
              const SizedBox(height: 12),
              OutlinedButton.icon(
                onPressed: _delete,
                icon: const Icon(Icons.delete_outline),
                label: Text(l10n.delete),
                style: OutlinedButton.styleFrom(foregroundColor: Colors.red),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _ImagePickerSection extends StatelessWidget {
  const _ImagePickerSection({
    required this.imagePath,
    required this.onPickCamera,
    required this.onPickGallery,
    required this.onRemove,
  });

  final String? imagePath;
  final VoidCallback onPickCamera;
  final VoidCallback onPickGallery;
  final VoidCallback onRemove;

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    final imageFile = imagePath == null
        ? null
        : resolveItemImageFile(imagePath!);
    final hasImage = imageFile != null && imageFile.existsSync();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: !hasImage
              ? Container(
                  height: 160,
                  width: double.infinity,
                  color: Colors.grey.shade200,
                  child: const Icon(
                    Icons.image_outlined,
                    size: 48,
                    color: Colors.grey,
                  ),
                )
              : Image.file(
                  imageFile,
                  height: 160,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
        ),
        const SizedBox(height: 8),
        Wrap(
          spacing: 4,
          runSpacing: 4,
          children: [
            TextButton.icon(
              onPressed: onPickCamera,
              icon: const Icon(Icons.camera_alt_outlined),
              label: Text(l10n.takePhoto),
            ),
            TextButton.icon(
              onPressed: onPickGallery,
              icon: const Icon(Icons.photo_library_outlined),
              label: Text(l10n.chooseFromGallery),
            ),
            if (imagePath != null)
              TextButton.icon(
                onPressed: onRemove,
                icon: const Icon(Icons.delete_outline),
                label: Text(l10n.deleteImageLabel),
              ),
          ],
        ),
      ],
    );
  }
}

class _DropdownWithAddButton extends StatelessWidget {
  const _DropdownWithAddButton({
    required this.label,
    required this.value,
    required this.items,
    required this.onChanged,
    required this.onAdd,
    this.swatchColor,
  });

  final String label;
  final int? value;
  final List<DropdownMenuItem<int>> items;
  final ValueChanged<int?>? onChanged;
  final VoidCallback onAdd;

  /// 選択中の項目にカラーコードが登録されている場合のサムネイル表示用の色。
  final Color? swatchColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        if (swatchColor != null) ...[
          CircleAvatar(radius: 12, backgroundColor: swatchColor),
          const SizedBox(width: 8),
        ],
        Expanded(
          child: DropdownButtonFormField<int>(
            initialValue: value,
            decoration: InputDecoration(labelText: label),
            items: items,
            onChanged: onChanged,
          ),
        ),
        IconButton(icon: const Icon(Icons.add_circle_outline), onPressed: onAdd),
      ],
    );
  }
}
