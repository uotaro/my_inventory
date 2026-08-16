import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart' hide colorToHex;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_inventory/l10n/app_localizations.dart';

import '../../data/repositories/category_repository_impl.dart';
import '../../data/repositories/color_group_repository_impl.dart';
import '../../data/repositories/color_option_repository_impl.dart';
import '../../data/repositories/inventory_type_repository_impl.dart';
import '../../data/repositories/sub_category_repository_impl.dart';
import '../../data/repositories/unit_repository_impl.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/color_group.dart';
import '../../domain/entities/color_option.dart';
import '../../domain/entities/inventory_type.dart';
import '../../domain/entities/sub_category.dart';
import '../../domain/entities/unit.dart';
import '../../domain/exceptions/duplicate_name_exception.dart';
import '../../domain/repositories/color_option_repository.dart';
import 'color_group_label.dart';
import 'color_hex.dart';

/// カテゴリー未登録時など、選択肢が無い状態でも
/// 登録画面から離脱せずにその場でマスタを追加できるようにするダイアログ群。

Future<void> _showErrorDialog(BuildContext context, String message) {
  final l10n = L10n.of(context);
  return showDialog<void>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.errorTitle),
      content: Text(message),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(l10n.ok),
        ),
      ],
    ),
  );
}

String _errorMessageFor(L10n l10n, Object e, String duplicateMessage) {
  final isDuplicate =
      e is DuplicateNameException || e.toString().contains('UNIQUE constraint');
  return isDuplicate ? duplicateMessage : l10n.saveFailedWithMessage(e.toString());
}

/// 名前を1つだけ入力する単純な追加・編集ダイアログ（カテゴリー・単位で共用）。
/// ボタン押下時にその場でDBへ反映し、失敗したらダイアログを閉じずに
/// ボタン下へ赤字でエラーを表示する。[initialValue]を渡すと編集用（値が入った状態）になる。
Future<void> _showSimpleAddDialog({
  required BuildContext context,
  required String title,
  required String label,
  required String duplicateMessage,
  required Future<void> Function(String name) onSubmit,
  String initialValue = '',
  String? submitLabel,
}) async {
  final l10n = L10n.of(context);
  final controller = TextEditingController(text: initialValue);
  String? errorText;
  var isSubmitting = false;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setState) {
        Future<void> submit() async {
          final name = controller.text.trim();
          if (name.isEmpty) {
            setState(() => errorText = l10n.nameRequiredGeneric);
            return;
          }
          setState(() {
            isSubmitting = true;
            errorText = null;
          });
          try {
            await onSubmit(name);
            if (dialogContext.mounted) Navigator.pop(dialogContext);
          } catch (e) {
            setState(() {
              isSubmitting = false;
              errorText = _errorMessageFor(l10n, e, duplicateMessage);
            });
          }
        }

        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller,
                autofocus: true,
                enabled: !isSubmitting,
                decoration: InputDecoration(labelText: label),
              ),
              if (errorText != null) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    errorText!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: isSubmitting
                  ? null
                  : () => Navigator.pop(dialogContext),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: isSubmitting ? null : submit,
              child: isSubmitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(submitLabel ?? l10n.add),
            ),
          ],
        );
      },
    ),
  );
}

Future<void> showAddCategoryDialog(BuildContext context, WidgetRef ref) async {
  final l10n = L10n.of(context);
  List<InventoryType> inventoryTypes;
  try {
    inventoryTypes = await ref
        .read(inventoryTypeRepositoryProvider)
        .getInventoryTypes();
  } catch (e) {
    if (context.mounted) {
      await _showErrorDialog(context, l10n.fetchInventoryTypesFailed(e.toString()));
    }
    return;
  }
  if (!context.mounted) return;
  if (inventoryTypes.isEmpty) {
    await _showErrorDialog(context, l10n.noInventoryTypesFound);
    return;
  }

  await _showSimpleAddDialog(
    context: context,
    title: l10n.addCategoryTitle,
    label: l10n.categoryNameHint,
    duplicateMessage: l10n.duplicateCategoryName,
    onSubmit: (name) => ref
        .read(categoryRepositoryProvider)
        .addCategory(inventoryTypeId: inventoryTypes.first.id, name: name),
  );
}

Future<void> showEditCategoryDialog(
  BuildContext context,
  WidgetRef ref,
  Category category,
) async {
  final l10n = L10n.of(context);
  await _showSimpleAddDialog(
    context: context,
    title: l10n.editCategoryTitle,
    label: l10n.categoryNameLabel,
    duplicateMessage: l10n.duplicateCategoryName,
    initialValue: category.name,
    submitLabel: l10n.save,
    onSubmit: (name) => ref
        .read(categoryRepositoryProvider)
        .updateCategory(category.copyWith(name: name)),
  );
}

/// [categoryId] はフォームで既に選択済みのカテゴリーをそのまま使う
/// （カテゴリー未選択の状態ではこのダイアログを開けない呼び出し側の制御が前提）。
Future<void> showAddSubCategoryDialog(
  BuildContext context,
  WidgetRef ref, {
  required int categoryId,
  required String categoryName,
}) async {
  final l10n = L10n.of(context);
  await _showSimpleAddDialog(
    context: context,
    title: l10n.addSubCategoryToCategory(categoryName),
    label: l10n.subCategoryNameHint,
    duplicateMessage: l10n.duplicateSubCategoryName,
    onSubmit: (name) => ref
        .read(subCategoryRepositoryProvider)
        .addSubCategory(categoryId: categoryId, name: name),
  );
}

Future<void> showEditSubCategoryDialog(
  BuildContext context,
  WidgetRef ref,
  SubCategory subCategory, {
  required String categoryName,
}) async {
  final l10n = L10n.of(context);
  await _showSimpleAddDialog(
    context: context,
    title: l10n.editSubCategoryOfCategory(categoryName),
    label: l10n.subCategoryNameLabel,
    duplicateMessage: l10n.duplicateSubCategoryName,
    initialValue: subCategory.name,
    submitLabel: l10n.save,
    onSubmit: (name) => ref
        .read(subCategoryRepositoryProvider)
        .updateSubCategory(subCategory.copyWith(name: name)),
  );
}

Future<void> showAddColorOptionDialog(
  BuildContext context,
  WidgetRef ref,
) async {
  final l10n = L10n.of(context);
  List<ColorGroup> colorGroups;
  try {
    colorGroups = await ref.read(colorGroupRepositoryProvider).getColorGroups();
  } catch (e) {
    if (context.mounted) {
      await _showErrorDialog(context, l10n.fetchColorGroupsFailed(e.toString()));
    }
    return;
  }
  if (!context.mounted) return;
  if (colorGroups.isEmpty) {
    await _showErrorDialog(context, l10n.noColorGroupsFound);
    return;
  }

  if (!context.mounted) return;
  await _showColorOptionFormDialog(
    context: context,
    ref: ref,
    colorGroups: colorGroups,
    title: l10n.addColorOptionTitle,
    submitLabel: l10n.add,
    initialColorGroupId: colorGroups.first.id,
    onSubmit: (repository, {required colorGroupId, required name, hexCode}) =>
        repository.addColorOption(
          colorGroupId: colorGroupId,
          name: name,
          hexCode: hexCode,
        ),
  );
}

Future<void> showEditColorOptionDialog(
  BuildContext context,
  WidgetRef ref,
  ColorOption colorOption,
) async {
  final l10n = L10n.of(context);
  List<ColorGroup> colorGroups;
  try {
    colorGroups = await ref.read(colorGroupRepositoryProvider).getColorGroups();
  } catch (e) {
    if (context.mounted) {
      await _showErrorDialog(context, l10n.fetchColorGroupsFailed(e.toString()));
    }
    return;
  }
  if (!context.mounted) return;
  if (colorGroups.isEmpty) {
    await _showErrorDialog(context, l10n.noColorGroupsFound);
    return;
  }

  if (!context.mounted) return;
  await _showColorOptionFormDialog(
    context: context,
    ref: ref,
    colorGroups: colorGroups,
    title: l10n.editColorOptionTitle,
    submitLabel: l10n.save,
    initialName: colorOption.name,
    initialHexCode: colorOption.hexCode ?? '',
    initialColorGroupId: colorOption.colorGroupId,
    onSubmit: (repository, {required colorGroupId, required name, hexCode}) =>
        repository.updateColorOption(
          colorOption.copyWith(
            colorGroupId: colorGroupId,
            name: name,
            hexCode: hexCode,
          ),
        ),
  );
}

Future<void> _showColorOptionFormDialog({
  required BuildContext context,
  required WidgetRef ref,
  required List<ColorGroup> colorGroups,
  required String title,
  required String submitLabel,
  required int initialColorGroupId,
  required Future<void> Function(
    ColorOptionRepository repository, {
    required int colorGroupId,
    required String name,
    String? hexCode,
  })
  onSubmit,
  String initialName = '',
  String initialHexCode = '',
}) async {
  final l10n = L10n.of(context);
  final nameController = TextEditingController(text: initialName);
  final hexController = TextEditingController(text: initialHexCode);
  var selectedGroupId = initialColorGroupId;
  Color? pickedColor = parseHexColor(initialHexCode);
  String? errorText;
  var isSubmitting = false;

  await showDialog<void>(
    context: context,
    builder: (dialogContext) => StatefulBuilder(
      builder: (dialogContext, setState) {
        Future<void> pickColor() async {
          var tempColor = pickedColor ?? Colors.blue;
          final result = await showDialog<Color>(
            context: dialogContext,
            builder: (pickerContext) => AlertDialog(
              title: Text(l10n.selectColorTitle),
              content: SingleChildScrollView(
                child: ColorPicker(
                  pickerColor: tempColor,
                  onColorChanged: (c) => tempColor = c,
                  enableAlpha: false,
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(pickerContext),
                  child: Text(l10n.cancel),
                ),
                FilledButton(
                  onPressed: () => Navigator.pop(pickerContext, tempColor),
                  child: Text(l10n.decide),
                ),
              ],
            ),
          );
          if (result != null) {
            setState(() {
              pickedColor = result;
              hexController.text = colorToHex(result);
            });
          }
        }

        Future<void> submit() async {
          final name = nameController.text.trim();
          if (name.isEmpty) {
            setState(() => errorText = l10n.colorNameRequiredError);
            return;
          }
          final hexCode = hexController.text.trim();
          setState(() {
            isSubmitting = true;
            errorText = null;
          });
          try {
            await onSubmit(
              ref.read(colorOptionRepositoryProvider),
              colorGroupId: selectedGroupId,
              name: name,
              hexCode: hexCode.isEmpty ? null : hexCode,
            );
            if (dialogContext.mounted) Navigator.pop(dialogContext);
          } catch (e) {
            setState(() {
              isSubmitting = false;
              errorText = _errorMessageFor(l10n, e, l10n.duplicateColorName);
            });
          }
        }

        return AlertDialog(
          title: Text(title),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                autofocus: true,
                enabled: !isSubmitting,
                decoration: InputDecoration(labelText: l10n.colorNameHint),
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<int>(
                initialValue: selectedGroupId,
                decoration: InputDecoration(labelText: l10n.colorGroupLabel),
                items: colorGroups
                    .map(
                      (group) => DropdownMenuItem(
                        value: group.id,
                        child: Text(colorGroupLabel(dialogContext, group.name)),
                      ),
                    )
                    .toList(),
                onChanged: isSubmitting
                    ? null
                    : (value) {
                        if (value != null) {
                          setState(() => selectedGroupId = value);
                        }
                      },
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  GestureDetector(
                    onTap: isSubmitting ? null : pickColor,
                    child: CircleAvatar(
                      radius: 18,
                      backgroundColor:
                          pickedColor ?? parseHexColor(hexController.text) ?? Colors.grey.shade200,
                      child: (pickedColor ?? parseHexColor(hexController.text)) == null
                          ? const Icon(Icons.colorize, size: 18)
                          : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: TextField(
                      controller: hexController,
                      enabled: !isSubmitting,
                      decoration: InputDecoration(labelText: l10n.hexCodeHint),
                      onChanged: (value) => setState(() => pickedColor = null),
                    ),
                  ),
                ],
              ),
              if (errorText != null) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    errorText!,
                    style: const TextStyle(color: Colors.red, fontSize: 13),
                  ),
                ),
              ],
            ],
          ),
          actions: [
            TextButton(
              onPressed: isSubmitting
                  ? null
                  : () => Navigator.pop(dialogContext),
              child: Text(l10n.cancel),
            ),
            FilledButton(
              onPressed: isSubmitting ? null : submit,
              child: isSubmitting
                  ? const SizedBox(
                      width: 16,
                      height: 16,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Text(submitLabel),
            ),
          ],
        );
      },
    ),
  );
}

Future<void> showAddUnitDialog(BuildContext context, WidgetRef ref) async {
  final l10n = L10n.of(context);
  await _showSimpleAddDialog(
    context: context,
    title: l10n.addUnitTitle,
    label: l10n.unitNameHint,
    duplicateMessage: l10n.duplicateUnitName,
    onSubmit: (name) => ref.read(unitRepositoryProvider).addUnit(name: name),
  );
}

Future<void> showEditUnitDialog(
  BuildContext context,
  WidgetRef ref,
  Unit unit,
) async {
  final l10n = L10n.of(context);
  await _showSimpleAddDialog(
    context: context,
    title: l10n.editUnitTitle,
    label: l10n.unitNameLabel,
    duplicateMessage: l10n.duplicateUnitName,
    initialValue: unit.name,
    submitLabel: l10n.save,
    onSubmit: (name) =>
        ref.read(unitRepositoryProvider).updateUnit(unit.copyWith(name: name)),
  );
}
