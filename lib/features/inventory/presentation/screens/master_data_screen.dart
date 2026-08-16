import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_inventory/l10n/app_localizations.dart';

import '../../data/repositories/category_repository_impl.dart';
import '../../data/repositories/color_option_repository_impl.dart';
import '../../data/repositories/sub_category_repository_impl.dart';
import '../../data/repositories/unit_repository_impl.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/sub_category.dart';
import '../../domain/exceptions/master_data_in_use_exception.dart';
import '../providers/master_data_providers.dart';
import '../widgets/add_master_data_dialogs.dart';
import '../widgets/color_group_label.dart';
import '../widgets/color_hex.dart';

/// カテゴリー・サブカテゴリー・色・単位の一覧表示、追加・編集・削除を行う画面。
/// サブカテゴリーはカテゴリーに従属するため、追加は各カテゴリーの見出し横の
/// 「＋」から行う（このタブにはFABを出さない）。
class MasterDataScreen extends ConsumerStatefulWidget {
  const MasterDataScreen({super.key});

  @override
  ConsumerState<MasterDataScreen> createState() => _MasterDataScreenState();
}

class _MasterDataScreenState extends ConsumerState<MasterDataScreen>
    with SingleTickerProviderStateMixin {
  late final TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this)
      ..addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = L10n.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.masterDataTitle),
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: l10n.categoriesTab),
            Tab(text: l10n.subCategoriesTab),
            Tab(text: l10n.colorsTab),
            Tab(text: l10n.unitsTab),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _CategoryTab(),
          _SubCategoryTab(),
          _ColorOptionTab(),
          _UnitTab(),
        ],
      ),
      floatingActionButton: _buildFab(),
    );
  }

  Widget? _buildFab() {
    switch (_tabController.index) {
      case 0:
        return FloatingActionButton(
          onPressed: () => showAddCategoryDialog(context, ref),
          child: const Icon(Icons.add),
        );
      case 2:
        return FloatingActionButton(
          onPressed: () => showAddColorOptionDialog(context, ref),
          child: const Icon(Icons.add),
        );
      case 3:
        return FloatingActionButton(
          onPressed: () => showAddUnitDialog(context, ref),
          child: const Icon(Icons.add),
        );
      default:
        // サブカテゴリータブ（index: 1）はカテゴリーごとの「＋」から追加するためFABなし
        return null;
    }
  }
}

Future<bool> _confirmDelete({
  required BuildContext context,
  required String message,
}) async {
  final l10n = L10n.of(context);
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (context) => AlertDialog(
      title: Text(l10n.confirmDeleteTitle),
      content: Text(message),
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
  return confirmed ?? false;
}

Future<void> _showDeleteErrorDialog(BuildContext context, Object error) async {
  final l10n = L10n.of(context);
  final message = error is MasterDataInUseException
      ? l10n.inUseCannotDelete(error.name, error.itemCount)
      : l10n.deleteFailedWithMessage(error.toString());
  await showDialog<void>(
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

Future<void> _handleDelete({
  required BuildContext context,
  required String confirmMessage,
  required Future<void> Function() onDelete,
}) async {
  final confirmed = await _confirmDelete(context: context, message: confirmMessage);
  if (!confirmed || !context.mounted) return;

  try {
    await onDelete();
  } catch (e) {
    if (context.mounted) await _showDeleteErrorDialog(context, e);
  }
}

class _CategoryTab extends ConsumerWidget {
  const _CategoryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final categoriesAsync = ref.watch(categoryListProvider);

    return categoriesAsync.when(
      data: (categories) => categories.isEmpty
          ? Center(child: Text(l10n.noCategoriesRegistered))
          : ListView.separated(
              itemCount: categories.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final category = categories[index];
                return ListTile(
                  title: Text(category.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () =>
                            showEditCategoryDialog(context, ref, category),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _handleDelete(
                          context: context,
                          confirmMessage: l10n.confirmDeleteNamedMessage(
                            category.name,
                          ),
                          onDelete: () => ref
                              .read(categoryRepositoryProvider)
                              .deleteCategory(category.id),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text(l10n.errorWithMessage(error.toString()))),
    );
  }
}

class _SubCategoryTab extends ConsumerWidget {
  const _SubCategoryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final categoriesAsync = ref.watch(categoryListProvider);
    final subCategoriesAsync = ref.watch(
      subCategoryListProvider(categoryId: null),
    );

    if (categoriesAsync.isLoading || subCategoriesAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (categoriesAsync.hasError) {
      return Center(
        child: Text(l10n.errorWithMessage(categoriesAsync.error.toString())),
      );
    }
    if (subCategoriesAsync.hasError) {
      return Center(
        child: Text(
          l10n.errorWithMessage(subCategoriesAsync.error.toString()),
        ),
      );
    }

    final categories = categoriesAsync.value ?? [];
    final subCategories = subCategoriesAsync.value ?? [];

    if (categories.isEmpty) {
      return Center(child: Text(l10n.noCategoriesRegistered));
    }

    return ListView(
      children: categories
          .expand((c) => _buildSection(context, ref, l10n, c, subCategories))
          .toList(),
    );
  }

  List<Widget> _buildSection(
    BuildContext context,
    WidgetRef ref,
    L10n l10n,
    Category category,
    List<SubCategory> allSubCategories,
  ) {
    final subCategories = allSubCategories
        .where((s) => s.categoryId == category.id)
        .toList();

    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                category.name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              tooltip: l10n.addSubCategoryToCategory(category.name),
              onPressed: () => showAddSubCategoryDialog(
                context,
                ref,
                categoryId: category.id,
                categoryName: category.name,
              ),
            ),
          ],
        ),
      ),
      if (subCategories.isEmpty)
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          child: Text(
            l10n.noSubCategories,
            style: const TextStyle(color: Colors.grey),
          ),
        )
      else
        ...subCategories.map(
          (subCategory) => ListTile(
            title: Text(subCategory.name),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () => showEditSubCategoryDialog(
                    context,
                    ref,
                    subCategory,
                    categoryName: category.name,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  onPressed: () => _handleDelete(
                    context: context,
                    confirmMessage: l10n.confirmDeleteSubCategoryMessage(
                      subCategory.name,
                    ),
                    onDelete: () => ref
                        .read(subCategoryRepositoryProvider)
                        .deleteSubCategory(subCategory.id),
                  ),
                ),
              ],
            ),
          ),
        ),
      const Divider(height: 1),
    ];
  }
}

class _ColorOptionTab extends ConsumerWidget {
  const _ColorOptionTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final colorOptionsAsync = ref.watch(colorOptionListProvider);
    final colorGroups = ref.watch(colorGroupListProvider).value ?? [];
    final groupLabelById = {
      for (final g in colorGroups) g.id: colorGroupLabel(context, g.name),
    };

    return colorOptionsAsync.when(
      data: (colorOptions) => colorOptions.isEmpty
          ? Center(child: Text(l10n.noColorsRegistered))
          : ListView.separated(
              itemCount: colorOptions.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final colorOption = colorOptions[index];
                final swatchColor = parseHexColor(colorOption.hexCode);
                return ListTile(
                  leading: CircleAvatar(
                    backgroundColor: swatchColor ?? Colors.grey.shade300,
                  ),
                  title: Text(colorOption.name),
                  subtitle: Text(groupLabelById[colorOption.colorGroupId] ?? ''),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () =>
                            showEditColorOptionDialog(context, ref, colorOption),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _handleDelete(
                          context: context,
                          confirmMessage: l10n.confirmDeleteColorMessage(
                            colorOption.name,
                          ),
                          onDelete: () => ref
                              .read(colorOptionRepositoryProvider)
                              .deleteColorOption(colorOption.id),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text(l10n.errorWithMessage(error.toString()))),
    );
  }
}

class _UnitTab extends ConsumerWidget {
  const _UnitTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final unitsAsync = ref.watch(unitListProvider);

    return unitsAsync.when(
      data: (units) => units.isEmpty
          ? Center(child: Text(l10n.noUnitsRegistered))
          : ListView.separated(
              itemCount: units.length,
              separatorBuilder: (_, _) => const Divider(height: 1),
              itemBuilder: (context, index) {
                final unit = units[index];
                return ListTile(
                  title: Text(unit.name),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        onPressed: () => showEditUnitDialog(context, ref, unit),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () => _handleDelete(
                          context: context,
                          confirmMessage: l10n.confirmDeleteNamedMessage(
                            unit.name,
                          ),
                          onDelete: () => ref
                              .read(unitRepositoryProvider)
                              .deleteUnit(unit.id),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text(l10n.errorWithMessage(error.toString()))),
    );
  }
}
