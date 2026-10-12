import 'package:flutter/material.dart';
import 'package:food_ordering_app/model/category_model.dart';
<<<<<<< HEAD
import 'package:food_ordering_app/viewmodel/admin_view_model.dart';
import 'package:provider/provider.dart';

class AdminCategoryScreen extends StatefulWidget {
  const AdminCategoryScreen({super.key});

  @override
  State<AdminCategoryScreen> createState() => _AdminCategoryScreenState();
}

class _AdminCategoryScreenState extends State<AdminCategoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminViewModel>().fetchCategories();
    });
  }

  void _openForm({CategoryModel? existing}) {
    final nameCtrl = TextEditingController(text: existing?.name ?? '');
    final imageCtrl = TextEditingController(text: existing?.image ?? '');
    final formKey = GlobalKey<FormState>();

    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text(existing == null ? 'Add Category' : 'Edit Category'),
        content: Form(
          key: formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Name'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: imageCtrl,
                decoration: const InputDecoration(labelText: 'Image URL'),
                validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Required' : null,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFCC0000),
            ),
            onPressed: () async {
              if (!formKey.currentState!.validate()) return;
              final vm = context.read<AdminViewModel>();
              final category = CategoryModel(
                id: existing?.id ?? '',
                name: nameCtrl.text.trim(),
                image: imageCtrl.text.trim(),
              );
              final success = existing == null
                  ? await vm.addCategory(category)
                  : await vm.updateCategory(category);
              if (success && context.mounted) Navigator.pop(context);
            },
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Future<void> _confirmDelete(CategoryModel category) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        title: const Text('Delete category'),
        content: Text('Delete "${category.name}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Delete', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
    if (confirmed == true && mounted) {
      await context.read<AdminViewModel>().deleteCategory(category.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdminViewModel>();

    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),
      appBar: AppBar(
        backgroundColor: const Color(0xFFCC0000),
        foregroundColor: Colors.white,
        title: Center(
          child: const Text(
            'Manage Categories',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: const Color(0xFFCC0000),
        onPressed: () => _openForm(),
        child: const Icon(Icons.add, color: Colors.white),
      ),
      body: vm.isLoadingCategories
          ? const Center(child: CircularProgressIndicator())
          : vm.categories.isEmpty
          ? const Center(child: Text('No categories yet. Tap + to add one.'))
          : RefreshIndicator(
              onRefresh: vm.fetchCategories,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: vm.categories.length,
                itemBuilder: (context, index) {
                  final category = vm.categories[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: Image.network(
                            category.image,
                            width: 48,
                            height: 48,
                            fit: BoxFit.cover,
                            errorBuilder: (_, __, ___) => Container(
                              width: 48,
                              height: 48,
                              color: const Color(0xFFFFEEEE),
                              child: const Icon(
                                Icons.category,
                                color: Color(0xFFCC0000),
                              ),
                            ),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Text(
                            category.name,
                            style: const TextStyle(fontWeight: FontWeight.w700),
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.edit_outlined, size: 20),
                          onPressed: () => _openForm(existing: category),
                        ),
                        IconButton(
                          icon: const Icon(
                            Icons.delete_outline,
                            size: 20,
                            color: Colors.red,
                          ),
                          onPressed: () => _confirmDelete(category),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
=======
import 'package:food_ordering_app/viewmodel/admin_category_view_model.dart';
import 'package:provider/provider.dart';

class AdminCategoriesScreen extends StatelessWidget {
  const AdminCategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => AdminCategoryViewModel(),
      child: const _AdminCategoriesBody(),
    );
  }
}

class _AdminCategoriesBody extends StatelessWidget {
  const _AdminCategoriesBody();

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<AdminCategoryViewModel>();

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Categories',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),

      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.orange,
        foregroundColor: Colors.white,
        onPressed: () {
          _showCategoryDialog(
            context,
            vm,
          );
        },
        child: const Icon(Icons.add),
      ),

      body: _buildBody(
        context,
        vm,
      ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    AdminCategoryViewModel vm,
  ) {
    if (vm.isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (vm.errorMessage != null &&
        vm.categories.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Text(
            vm.errorMessage!,
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (vm.categories.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.category_outlined,
              size: 80,
              color: Colors.grey,
            ),
            SizedBox(height: 16),
            Text(
              'No categories yet',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 8),
            Text(
              'Tap + to add your first category',
              style: TextStyle(
                color: Colors.grey,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: () async {
        vm.listenToCategories();
      },
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vm.categories.length,
        itemBuilder: (context, index) {
          final category = vm.categories[index];

          return _CategoryCard(
            category: category,
            onEdit: () {
              _showCategoryDialog(
                context,
                vm,
                category: category,
              );
            },
            onDelete: () {
              _deleteCategory(
                context,
                vm,
                category,
              );
            },
          );
        },
      ),
    );
  }

  // ============================================================
  // ADD / EDIT DIALOG
  // ============================================================

  void _showCategoryDialog(
    BuildContext context,
    AdminCategoryViewModel vm, {
    CategoryModel? category,
  }) {
    final nameController = TextEditingController(
      text: category?.name ?? '',
    );

    final imageController = TextEditingController(
      text: category?.imageUrl ?? '',
    );

    final isEditing = category != null;

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: Text(
            isEditing
                ? 'Edit Category'
                : 'Add Category',
          ),

          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Category Name',
                    hintText: 'e.g. Pizza',
                    border: OutlineInputBorder(),
                  ),
                ),

                const SizedBox(height: 16),

                TextField(
                  controller: imageController,
                  decoration: const InputDecoration(
                    labelText: 'Image URL',
                    hintText: 'https://...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ],
            ),
          ),

          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('Cancel'),
            ),

            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.orange,
                foregroundColor: Colors.white,
              ),
              onPressed: vm.isSaving
                  ? null
                  : () async {
                      final name =
                          nameController.text.trim();

                      final imageUrl =
                          imageController.text.trim();

                      if (name.isEmpty) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Category name is required',
                            ),
                          ),
                        );
                        return;
                      }

                      bool success;

                      if (isEditing) {
                        success =
                            await vm.updateCategory(
                          id: category.id,
                          name: name,
                          imageUrl: imageUrl,
                        );
                      } else {
                        success =
                            await vm.addCategory(
                          name: name,
                          imageUrl: imageUrl,
                        );
                      }

                      if (!context.mounted) return;

                      if (success) {
                        Navigator.pop(dialogContext);

                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(
                              isEditing
                                  ? 'Category updated'
                                  : 'Category added',
                            ),
                            backgroundColor:
                                Colors.green,
                          ),
                        );
                      } else {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(
                              vm.errorMessage ??
                                  'Something went wrong',
                            ),
                            backgroundColor:
                                Colors.red,
                          ),
                        );
                      }
                    },
              child: Text(
                isEditing
                    ? 'Update'
                    : 'Add',
              ),
            ),
          ],
        );
      },
    );
  }

  // ============================================================
  // DELETE CONFIRMATION
  // ============================================================

  void _deleteCategory(
    BuildContext context,
    AdminCategoryViewModel vm,
    CategoryModel category,
  ) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text(
            'Delete Category',
          ),
          content: Text(
            'Are you sure you want to delete "${category.name}"?',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  false,
                );
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
                foregroundColor: Colors.white,
              ),
              onPressed: () {
                Navigator.pop(
                  dialogContext,
                  true,
                );
              },
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );

    if (confirm != true) return;

    final success =
        await vm.deleteCategory(category.id);

    if (!context.mounted) return;

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          success
              ? 'Category deleted'
              : 'Failed to delete category',
        ),
        backgroundColor:
            success ? Colors.green : Colors.red,
      ),
    );
  }
}

// ================================================================
// CATEGORY CARD
// ================================================================

class _CategoryCard extends StatelessWidget {
  final CategoryModel category;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  const _CategoryCard({
    required this.category,
    required this.onEdit,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            // IMAGE
            Container(
              height: 65,
              width: 65,
              decoration: BoxDecoration(
                color: Colors.orange.shade50,
                borderRadius:
                    BorderRadius.circular(12),
              ),
              child: category.imageUrl.isEmpty
                  ? const Icon(
                      Icons.category,
                      color: Colors.orange,
                      size: 32,
                    )
                  : ClipRRect(
                      borderRadius:
                          BorderRadius.circular(12),
                      child: Image.network(
                        category.imageUrl,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stack) {
                          return const Icon(
                            Icons.category,
                            color: Colors.orange,
                            size: 32,
                          );
                        },
                      ),
                    ),
            ),

            const SizedBox(width: 14),

            // NAME
            Expanded(
              child: Text(
                category.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),

            // EDIT
            IconButton(
              onPressed: onEdit,
              icon: const Icon(
                Icons.edit_outlined,
              ),
              color: Colors.orange,
            ),

            // DELETE
            IconButton(
              onPressed: onDelete,
              icon: const Icon(
                Icons.delete_outline,
              ),
              color: Colors.red,
            ),
          ],
        ),
      ),
>>>>>>> origin/main
    );
  }
}