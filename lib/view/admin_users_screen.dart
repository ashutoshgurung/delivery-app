import 'package:flutter/material.dart';
import 'package:food_ordering_app/viewmodel/admin_view_model.dart';
import 'package:provider/provider.dart';

class AdminUserScreen extends StatefulWidget {
  const AdminUserScreen({super.key});

  @override
  State<AdminUserScreen> createState() => _AdminUserScreenState();
}

class _AdminUserScreenState extends State<AdminUserScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<AdminViewModel>().fetchUsers();
    });
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
            'Manage Users',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ),
      body: vm.isLoadingUsers
          ? const Center(child: CircularProgressIndicator())
          : vm.users.isEmpty
          ? const Center(child: Text('No users yet.'))
          : RefreshIndicator(
              onRefresh: vm.fetchUsers,
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: vm.users.length,
                itemBuilder: (context, index) {
                  final user = vm.users[index];
                  return Container(
                    margin: const EdgeInsets.only(bottom: 12),
                    padding: const EdgeInsets.all(14),
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
                        CircleAvatar(
                          backgroundColor: const Color(0xFFFFEEEE),
                          child: Text(
                            user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                            style: const TextStyle(color: Color(0xFFCC0000)),
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                user.name,
                                style: const TextStyle(fontWeight: FontWeight.w800),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                user.email,
                                style: const TextStyle(color: Colors.grey, fontSize: 12),
                              ),
                            ],
                          ),
                        ),
                        Row(
                          children: [
                            Text(
                              'Admin',
                              style: TextStyle(
                                fontSize: 11,
                                color: user.isAdmin
                                    ? const Color(0xFFCC0000)
                                    : Colors.grey,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            Switch(
                              value: user.isAdmin,
                              activeColor: const Color(0xFFCC0000),
                              onChanged: (value) => context
                                  .read<AdminViewModel>()
                                  .setUserAdmin(user.id, value),
                            ),
                          ],
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
    );
  }
}