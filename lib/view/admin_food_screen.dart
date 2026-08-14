import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminFoodScreen extends StatelessWidget {
  const AdminFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Food Management',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () => _showFoodDialog(context),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('foods')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                'Error loading foods\n${snapshot.error}',
                textAlign: TextAlign.center,
              ),
            );
          }

          final docs = snapshot.data?.docs ?? [];

          if (docs.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.restaurant_menu,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No food items yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap + to add your first food',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: docs.length,
            itemBuilder: (context, index) {
              final doc = docs[index];

              final data = doc.data() as Map<String, dynamic>;

              return _FoodCard(
                id: doc.id,
                data: data,
              );
            },
          );
        },
      ),
    );
  }

  static Future<void> _showFoodDialog(
    BuildContext context, {
    String? foodId,
    Map<String, dynamic>? existingData,
  }) async {
    final nameController = TextEditingController(
      text: existingData?['name'] ?? '',
    );

    final priceController = TextEditingController(
      text: existingData?['price']?.toString() ?? '',
    );

    final descriptionController = TextEditingController(
      text: existingData?['description'] ?? '',
    );

    final imageUrlController = TextEditingController(
      text: existingData?['imageUrl'] ?? '',
    );

    String? selectedCategory =
        existingData?['category'];

    await showDialog(
      context: context,
      builder: (dialogContext) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: Text(
                foodId == null
                    ? 'Add Food'
                    : 'Edit Food',
              ),
              content: SizedBox(
                width: 500,
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextField(
                        controller: nameController,
                        textCapitalization:
                            TextCapitalization.words,
                        decoration: const InputDecoration(
                          labelText: 'Food Name',
                          hintText: 'e.g. Chicken Burger',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller: priceController,
                        keyboardType:
                            TextInputType.number,
                        decoration: const InputDecoration(
                          labelText: 'Price',
                          hintText: 'e.g. 350',
                          prefixText: 'Rs. ',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      // CATEGORY
                      StreamBuilder<QuerySnapshot>(
                        stream: FirebaseFirestore.instance
                            .collection('categories')
                            .orderBy('name')
                            .snapshots(),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: Padding(
                                padding: EdgeInsets.all(12),
                                child:
                                    CircularProgressIndicator(),
                              ),
                            );
                          }

                          final categories =
                              snapshot.data?.docs ?? [];

                          if (categories.isEmpty) {
                            return const Align(
                              alignment: Alignment.centerLeft,
                              child: Text(
                                'Please create a category first.',
                                style: TextStyle(
                                  color: Colors.red,
                                ),
                              ),
                            );
                          }

                          final validValue =
                              categories.any(
                            (doc) =>
                                doc['name'] ==
                                selectedCategory,
                          );

                          if (!validValue) {
                            selectedCategory =
                                categories.first['name'];
                          }

                          return DropdownButtonFormField<String>(
                            value: selectedCategory,
                            decoration:
                                const InputDecoration(
                              labelText: 'Category',
                              border:
                                  OutlineInputBorder(),
                            ),
                            items: categories.map((doc) {
                              final category =
                                  doc['name'] as String;

                              return DropdownMenuItem<String>(
                                value: category,
                                child: Text(category),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                selectedCategory =
                                    value;
                              });
                            },
                          );
                        },
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller:
                            descriptionController,
                        maxLines: 3,
                        decoration: const InputDecoration(
                          labelText: 'Description',
                          hintText:
                              'Enter food description',
                          border: OutlineInputBorder(),
                        ),
                      ),

                      const SizedBox(height: 12),

                      TextField(
                        controller:
                            imageUrlController,
                        decoration: const InputDecoration(
                          labelText: 'Image URL',
                          hintText:
                              'https://example.com/image.jpg',
                          border: OutlineInputBorder(),
                        ),
                      ),
                    ],
                  ),
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
                    backgroundColor: Colors.red,
                    foregroundColor: Colors.white,
                  ),
                  onPressed: () async {
                    final name =
                        nameController.text.trim();

                    final priceText =
                        priceController.text.trim();

                    final description =
                        descriptionController.text
                            .trim();

                    final imageUrl =
                        imageUrlController.text.trim();

                    if (name.isEmpty ||
                        priceText.isEmpty ||
                        selectedCategory == null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter food name, price and category',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    final price =
                        double.tryParse(priceText);

                    if (price == null) {
                      ScaffoldMessenger.of(context)
                          .showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Please enter a valid price',
                          ),
                          backgroundColor: Colors.red,
                        ),
                      );
                      return;
                    }

                    try {
                      if (foodId == null) {
                        await FirebaseFirestore.instance
                            .collection('foods')
                            .add({
                          'name': name,
                          'price': price,
                          'category':
                              selectedCategory,
                          'description':
                              description,
                          'imageUrl': imageUrl,
                          'createdAt':
                              Timestamp.now(),
                        });
                      } else {
                        await FirebaseFirestore.instance
                            .collection('foods')
                            .doc(foodId)
                            .update({
                          'name': name,
                          'price': price,
                          'category':
                              selectedCategory,
                          'description':
                              description,
                          'imageUrl': imageUrl,
                          'updatedAt':
                              Timestamp.now(),
                        });
                      }

                      if (dialogContext.mounted) {
                        Navigator.pop(dialogContext);
                      }

                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(
                              foodId == null
                                  ? 'Food added successfully'
                                  : 'Food updated successfully',
                            ),
                            backgroundColor:
                                Colors.green,
                          ),
                        );
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context)
                            .showSnackBar(
                          SnackBar(
                            content: Text(
                              'Error: $e',
                            ),
                            backgroundColor:
                                Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  child: Text(
                    foodId == null ? 'Add Food' : 'Update',
                  ),
                ),
              ],
            );
          },
        );
      },
    );

    nameController.dispose();
    priceController.dispose();
    descriptionController.dispose();
    imageUrlController.dispose();
  }
}

// ================================================================
// FOOD CARD
// ================================================================

class _FoodCard extends StatelessWidget {
  final String id;
  final Map<String, dynamic> data;

  const _FoodCard({
    required this.id,
    required this.data,
  });

  @override
  Widget build(BuildContext context) {
    final name = data['name'] ?? 'Food';
    final category = data['category'] ?? 'Unknown';
    final description = data['description'] ?? '';
    final imageUrl = data['imageUrl'] ?? '';

    final price =
        data['price'] is num
            ? (data['price'] as num).toDouble()
            : double.tryParse(
                  data['price']?.toString() ?? '',
                ) ??
                0;

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            // IMAGE
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: imageUrl.toString().isNotEmpty
                  ? Image.network(
                      imageUrl,
                      width: 90,
                      height: 90,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (context, error, stackTrace) {
                        return _imagePlaceholder();
                      },
                    )
                  : _imagePlaceholder(),
            ),

            const SizedBox(width: 14),

            // DETAILS
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    name.toString(),
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    category.toString(),
                    style: const TextStyle(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  const SizedBox(height: 6),

                  if (description
                      .toString()
                      .isNotEmpty)
                    Text(
                      description.toString(),
                      maxLines: 2,
                      overflow:
                          TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.grey,
                        fontSize: 12,
                      ),
                    ),

                  const SizedBox(height: 6),

                  Text(
                    'Rs. ${price.toStringAsFixed(0)}',
                    style: const TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                ],
              ),
            ),

            // ACTIONS
            Column(
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    color: Colors.orange,
                  ),
                  onPressed: () {
                    AdminFoodScreen._showFoodDialog(
                      context,
                      foodId: id,
                      existingData: data,
                    );
                  },
                ),
                IconButton(
                  icon: const Icon(
                    Icons.delete,
                    color: Colors.red,
                  ),
                  onPressed: () {
                    _deleteFood(
                      context,
                      id,
                      name.toString(),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePlaceholder() {
    return Container(
      width: 90,
      height: 90,
      color: Colors.grey.shade200,
      child: const Icon(
        Icons.restaurant,
        size: 35,
        color: Colors.grey,
      ),
    );
  }
}

// ================================================================
// DELETE FOOD
// ================================================================

Future<void> _deleteFood(
  BuildContext context,
  String id,
  String name,
) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (dialogContext) {
      return AlertDialog(
        title: const Text('Delete Food'),
        content: Text(
          'Are you sure you want to delete "$name"?',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(dialogContext, false);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(dialogContext, true);
            },
            child: const Text('Delete'),
          ),
        ],
      );
    },
  );

  if (confirm != true) return;

  try {
    await FirebaseFirestore.instance
        .collection('foods')
        .doc(id)
        .delete();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            'Food deleted successfully',
          ),
          backgroundColor: Colors.red,
        ),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}