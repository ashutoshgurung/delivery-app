import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class AdminUsersScreen extends StatelessWidget {
  const AdminUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Users',
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance
            .collection('users')
            .orderBy('createdAt', descending: true)
            .snapshots(),
        builder: (context, snapshot) {
          // Loading
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          // Error
          if (snapshot.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Text(
                  'Error loading users:\n${snapshot.error}',
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final users = snapshot.data?.docs ?? [];

          // Empty
          if (users.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.people_outline,
                    size: 80,
                    color: Colors.grey,
                  ),
                  SizedBox(height: 16),
                  Text(
                    'No users found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: users.length,
            itemBuilder: (context, index) {
              final doc = users[index];
              final data = doc.data() as Map<String, dynamic>;

              final name = data['name'] ?? 'Unknown User';
              final email = data['email'] ?? 'No email';
              final role = data['role'] ?? 'customer';
              final imageUrl = data['imageUrl'] ?? '';

              return _UserCard(
                uid: doc.id,
                name: name.toString(),
                email: email.toString(),
                role: role.toString(),
                imageUrl: imageUrl.toString(),
              );
            },
          );
        },
      ),
    );
  }
}

// ================================================================
// USER CARD
// ================================================================

class _UserCard extends StatelessWidget {
  final String uid;
  final String name;
  final String email;
  final String role;
  final String imageUrl;

  const _UserCard({
    required this.uid,
    required this.name,
    required this.email,
    required this.role,
    required this.imageUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isAdmin = role == 'admin';

    return Card(
      margin: const EdgeInsets.only(bottom: 14),
      elevation: 3,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            // ======================================================
            // PROFILE IMAGE
            // ======================================================

            CircleAvatar(
              radius: 28,
              backgroundColor:
                  isAdmin ? Colors.orange.shade100 : Colors.blue.shade100,
              backgroundImage: imageUrl.isNotEmpty
                  ? NetworkImage(imageUrl)
                  : null,
              child: imageUrl.isEmpty
                  ? Icon(
                      isAdmin ? Icons.admin_panel_settings : Icons.person,
                      color: isAdmin ? Colors.orange : Colors.blue,
                      size: 30,
                    )
                  : null,
            ),

            const SizedBox(width: 14),

            // ======================================================
            // USER INFORMATION
            // ======================================================

            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 4),

                  Text(
                    email,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),

                  const SizedBox(height: 7),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 9,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: isAdmin
                          ? Colors.orange.withOpacity(0.1)
                          : Colors.blue.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      role.toUpperCase(),
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: isAdmin
                            ? Colors.orange.shade800
                            : Colors.blue.shade800,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // ======================================================
            // DELETE BUTTON
            // ======================================================

            IconButton(
              tooltip: 'Delete user',
              icon: const Icon(
                Icons.delete_outline,
                color: Colors.red,
              ),
              onPressed: () {
                _showDeleteDialog(
                  context,
                  uid,
                  name,
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

// ================================================================
// DELETE USER
// ================================================================

Future<void> _showDeleteDialog(
  BuildContext context,
  String uid,
  String name,
) async {
  final confirm = await showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: const Text('Delete User'),
        content: Text(
          'Are you sure you want to delete "$name"?\n\n'
          'This will remove the user document from Firestore.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false);
            },
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context, true);
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
        .collection('users')
        .doc(uid)
        .delete();

    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('User deleted successfully'),
          backgroundColor: Colors.green,
        ),
      );
    }
  } catch (e) {
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to delete user: $e'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }
}