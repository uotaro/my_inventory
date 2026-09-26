import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_inventory/l10n/app_localizations.dart';

import '../../data/repositories/category_repository_impl.dart';
import '../../data/repositories/color_option_repository_impl.dart';
import '../../data/repositories/inventory_type_repository_impl.dart';
import '../../data/repositories/sub_category_repository_impl.dart';
import '../../data/repositories/unit_repository_impl.dart';
import '../../domain/entities/category.dart';
import '../../domain/entities/inventory_type.dart';
import '../../domain/entities/sub_category.dart';
import '../../domain/exceptions/master_data_in_use_exception.dart';
import '../providers/master_data_providers.dart';
import '../widgets/add_master_data_dialogs.dart';
import '../widgets/color_group_label.dart';
import '../widgets/color_hex.dart';
import '../widgets/reorder_helper.dart';

/// 種別・カテゴリー・サブカテゴリー・色・単位の一覧表示、追加・編集・削除を行う画面。
/// カテゴリーは種別に、サブカテゴリーはカテゴリーに従属するため、追加は
/// それぞれ親データの見出し横の「＋」から行う（このタブにはFABを出さない）。
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
    _tabController = TabController(length: 5, vsync: this)
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
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(kTextTabBarHeight),
          child: ColoredBox(
            color: Theme.of(context).scaffoldBackgroundColor,
            child: TabBar(
              controller: _tabController,
              labelColor: Theme.of(context).colorScheme.primary,
              unselectedLabelColor:
                  Theme.of(context).colorScheme.onSurfaceVariant,
              indicatorColor: Theme.of(context).colorScheme.primary,
              tabs: [
                Tab(text: l10n.typesTab),
                Tab(text: l10n.categoriesTab),
                Tab(text: l10n.subCategoriesTab),
                Tab(text: l10n.colorsTab),
                Tab(text: l10n.unitsTab),
              ],
            ),
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          _InventoryTypeTab(),
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
          onPressed: () => showAddInventoryTypeDialog(context, ref),
          child: const Icon(Icons.add),
        );
      case 3:
        return FloatingActionButton(
          onPressed: () => showAddColorOptionDialog(context, ref),
          child: const Icon(Icons.add),
        );
      case 4:
        return FloatingActionButton(
          onPressed: () => showAddUnitDialog(context, ref),
          child: const Icon(Icons.add),
        );
      default:
        // カテゴリータブ（index: 1）・サブカテゴリータブ（index: 2）は
        // 親データごとの「＋」から追加するためFABなし
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
  final String message;
  if (error is MasterDataInUseException) {
    message = l10n.inUseCannotDelete(error.name, error.itemCount);
  } else if (error is TypeInUseByCategoriesException) {
    message = l10n.typeInUseCannotDelete(error.name, error.categoryCount);
  } else if (error is CategoryInUseBySubCategoriesException) {
    message = l10n.categoryInUseBySubCategoriesCannotDelete(
      error.name,
      error.subCategoryCount,
    );
  } else if (error is LastInventoryTypeException) {
    message = l10n.lastInventoryTypeCannotDelete;
  } else {
    message = l10n.deleteFailedWithMessage(error.toString());
  }
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

class _InventoryTypeTab extends ConsumerWidget {
  const _InventoryTypeTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final inventoryTypesAsync = ref.watch(inventoryTypeListProvider);

    return inventoryTypesAsync.when(
      data: (inventoryTypes) => inventoryTypes.isEmpty
          ? Center(child: Text(l10n.noTypesRegistered))
          : ReorderableListView.builder(
              itemCount: inventoryTypes.length,
              // ignore: deprecated_member_use
              onReorder: (oldIndex, newIndex) => handleReorder(
                items: inventoryTypes,
                oldIndex: oldIndex,
                newIndex: newIndex,
                sortOrderOf: (t) => t.sortOrder,
                persist: (t, sortOrder) => ref
                    .read(inventoryTypeRepositoryProvider)
                    .updateInventoryType(t.copyWith(sortOrder: sortOrder)),
              ),
              itemBuilder: (context, index) {
                final inventoryType = inventoryTypes[index];
                return Column(
                  key: ValueKey(inventoryType.id),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(inventoryType.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => showEditInventoryTypeDialog(
                              context,
                              ref,
                              inventoryType,
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete_outline),
                            onPressed: () => _handleDelete(
                              context: context,
                              confirmMessage: l10n.confirmDeleteNamedMessage(
                                inventoryType.name,
                              ),
                              onDelete: () => ref
                                  .read(inventoryTypeRepositoryProvider)
                                  .deleteInventoryType(inventoryType.id),
                            ),
                          ),
                        ],
                      ),
                    ),
                    if (index != inventoryTypes.length - 1)
                      const Divider(height: 1),
                  ],
                );
              },
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text(l10n.errorWithMessage(error.toString()))),
    );
  }
}

class _CategoryTab extends ConsumerWidget {
  const _CategoryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final inventoryTypesAsync = ref.watch(inventoryTypeListProvider);
    final categoriesAsync = ref.watch(
      categoryListProvider(inventoryTypeId: null),
    );

    if (inventoryTypesAsync.isLoading || categoriesAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (inventoryTypesAsync.hasError) {
      return Center(
        child: Text(l10n.errorWithMessage(inventoryTypesAsync.error.toString())),
      );
    }
    if (categoriesAsync.hasError) {
      return Center(
        child: Text(l10n.errorWithMessage(categoriesAsync.error.toString())),
      );
    }

    final inventoryTypes = inventoryTypesAsync.value ?? [];
    final categories = categoriesAsync.value ?? [];

    if (inventoryTypes.isEmpty) {
      return Center(child: Text(l10n.noTypesRegistered));
    }

    return ListView(
      children: inventoryTypes
          .expand((t) => _buildSection(context, ref, l10n, t, categories))
          .toList(),
    );
  }

  List<Widget> _buildSection(
    BuildContext context,
    WidgetRef ref,
    L10n l10n,
    InventoryType inventoryType,
    List<Category> allCategories,
  ) {
    final categories = allCategories
        .where((c) => c.inventoryTypeId == inventoryType.id)
        .toList();

    return [
      Padding(
        padding: const EdgeInsets.fromLTRB(16, 12, 8, 4),
        child: Row(
          children: [
            Expanded(
              child: Text(
                inventoryType.name,
                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle_outline),
              tooltip: l10n.addCategoryToType(inventoryType.name),
              onPressed: () => showAddCategoryDialog(
                context,
                ref,
                inventoryTypeId: inventoryType.id,
                inventoryTypeName: inventoryType.name,
              ),
            ),
          ],
        ),
      ),
      if (categories.isEmpty)
        Padding(
          padding: const EdgeInsets.only(left: 32, right: 16, top: 4, bottom: 4),
          child: Text(
            l10n.noCategoriesInType,
            style: const TextStyle(color: Colors.grey),
          ),
        )
      else
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollController: ScrollController(),
          itemCount: categories.length,
          // ignore: deprecated_member_use
          onReorder: (oldIndex, newIndex) => handleReorder(
            items: categories,
            oldIndex: oldIndex,
            newIndex: newIndex,
            sortOrderOf: (c) => c.sortOrder,
            persist: (c, sortOrder) => ref
                .read(categoryRepositoryProvider)
                .updateCategory(c.copyWith(sortOrder: sortOrder)),
          ),
          itemBuilder: (context, index) {
            final category = categories[index];
            return ListTile(
              key: ValueKey(category.id),
              contentPadding: const EdgeInsets.only(left: 32, right: 16),
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
      const Divider(height: 1),
    ];
  }
}

class _SubCategoryTab extends ConsumerWidget {
  const _SubCategoryTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = L10n.of(context);
    final inventoryTypesAsync = ref.watch(inventoryTypeListProvider);
    final categoriesAsync = ref.watch(
      categoryListProvider(inventoryTypeId: null),
    );
    final subCategoriesAsync = ref.watch(
      subCategoryListProvider(categoryId: null),
    );

    if (inventoryTypesAsync.isLoading ||
        categoriesAsync.isLoading ||
        subCategoriesAsync.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (inventoryTypesAsync.hasError) {
      return Center(
        child: Text(
          l10n.errorWithMessage(inventoryTypesAsync.error.toString()),
        ),
      );
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

    final inventoryTypes = inventoryTypesAsync.value ?? [];
    final categories = categoriesAsync.value ?? [];
    final subCategories = subCategoriesAsync.value ?? [];

    if (categories.isEmpty) {
      return Center(child: Text(l10n.noCategoriesRegistered));
    }

    // 大分類のソート順 → その大分類内の中分類ソート順、の順にセクションを並べる。
    return ListView(
      children: inventoryTypes
          .expand(
            (inventoryType) => categories
                .where((c) => c.inventoryTypeId == inventoryType.id)
                .expand(
                  (category) => _buildSection(
                    context,
                    ref,
                    l10n,
                    inventoryType,
                    category,
                    subCategories,
                  ),
                ),
          )
          .toList(),
    );
  }

  List<Widget> _buildSection(
    BuildContext context,
    WidgetRef ref,
    L10n l10n,
    InventoryType inventoryType,
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
                '${inventoryType.name} - ${category.name}',
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
          padding: const EdgeInsets.only(left: 32, right: 16, top: 4, bottom: 4),
          child: Text(
            l10n.noSubCategories,
            style: const TextStyle(color: Colors.grey),
          ),
        )
      else
        ReorderableListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          scrollController: ScrollController(),
          itemCount: subCategories.length,
          // ignore: deprecated_member_use
          onReorder: (oldIndex, newIndex) => handleReorder(
            items: subCategories,
            oldIndex: oldIndex,
            newIndex: newIndex,
            sortOrderOf: (s) => s.sortOrder,
            persist: (s, sortOrder) => ref
                .read(subCategoryRepositoryProvider)
                .updateSubCategory(s.copyWith(sortOrder: sortOrder)),
          ),
          itemBuilder: (context, index) {
            final subCategory = subCategories[index];
            return ListTile(
              key: ValueKey(subCategory.id),
              contentPadding: const EdgeInsets.only(left: 32, right: 16),
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
            );
          },
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
          : ReorderableListView.builder(
              itemCount: colorOptions.length,
              // ignore: deprecated_member_use
              onReorder: (oldIndex, newIndex) => handleReorder(
                items: colorOptions,
                oldIndex: oldIndex,
                newIndex: newIndex,
                sortOrderOf: (c) => c.sortOrder,
                persist: (c, sortOrder) => ref
                    .read(colorOptionRepositoryProvider)
                    .updateColorOption(c.copyWith(sortOrder: sortOrder)),
              ),
              itemBuilder: (context, index) {
                final colorOption = colorOptions[index];
                final swatchColor = parseHexColor(colorOption.hexCode);
                return Column(
                  key: ValueKey(colorOption.id),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      leading: CircleAvatar(
                        backgroundColor: swatchColor ?? Colors.grey.shade300,
                      ),
                      title: Text(colorOption.name),
                      subtitle: Text(
                        groupLabelById[colorOption.colorGroupId] ?? '',
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () => showEditColorOptionDialog(
                              context,
                              ref,
                              colorOption,
                            ),
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
                    ),
                    if (index != colorOptions.length - 1)
                      const Divider(height: 1),
                  ],
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
          : ReorderableListView.builder(
              itemCount: units.length,
              // ignore: deprecated_member_use
              onReorder: (oldIndex, newIndex) => handleReorder(
                items: units,
                oldIndex: oldIndex,
                newIndex: newIndex,
                sortOrderOf: (u) => u.sortOrder,
                persist: (u, sortOrder) => ref
                    .read(unitRepositoryProvider)
                    .updateUnit(u.copyWith(sortOrder: sortOrder)),
              ),
              itemBuilder: (context, index) {
                final unit = units[index];
                return Column(
                  key: ValueKey(unit.id),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ListTile(
                      title: Text(unit.name),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit_outlined),
                            onPressed: () =>
                                showEditUnitDialog(context, ref, unit),
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
                    ),
                    if (index != units.length - 1) const Divider(height: 1),
                  ],
                );
              },
            ),
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (error, stack) =>
          Center(child: Text(l10n.errorWithMessage(error.toString()))),
    );
  }
}
