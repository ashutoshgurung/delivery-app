import 'package:flutter/material.dart';
import 'package:food_ordering_app/view/admin_categories_screen.dart';
import 'package:food_ordering_app/view/admin_food_screen.dart';
import 'package:food_ordering_app/view/admin_order_screen.dart';
import 'package:food_ordering_app/view/admin_profile_screen.dart';
import 'package:food_ordering_app/view/admin_store_setting_screen.dart';
import 'package:food_ordering_app/view/admin_users_screen.dart';
import 'package:food_ordering_app/viewmodel/auth_view_model.dart';
import 'package:provider/provider.dart';

class AdminDashboardScreen extends StatelessWidget {
  const AdminDashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F6F6),

      appBar: AppBar(
        backgroundColor: const Color(0xFFCC0000),
        foregroundColor: Colors.white,
        title: Center(
          child: const Text(
            'Admin Dashboard',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
        actions: [
          IconButton(
            onPressed: () async {
              await context.read<AuthViewModel>().logOut();

              if (!context.mounted) return;

              Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Welcome, Admin 👋',
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.w900,
                color: Color(0xFF111111),
              ),
            ),

            const SizedBox(height: 8),

            const Text(
              'Manage your food ordering application',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,

                children: [
                  // ORDERS
                  _AdminCard(
                    icon: Icons.receipt_long_outlined,
                    title: 'Orders',
                    subtitle: 'Manage customer orders',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminOrderScreen(),
                        ),
                      );
                    },
                  ),

                  // FOODS
                  _AdminCard(
                    icon: Icons.restaurant_menu_outlined,
                    title: 'Foods',
                    subtitle: 'Manage food items',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminFoodScreen(),
                        ),
                      );
                    },
                  ),

                  // CATEGORIES
                  _AdminCard(
                    icon: Icons.category_outlined,
                    title: 'Categories',
                    subtitle: 'Manage food categories',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminCategoryScreen(),
                        ),
                      );
                    },
                  ),

                  // USERS
                  _AdminCard(
                    icon: Icons.people_outline,
                    title: 'Users',
                    subtitle: 'Manage customers',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminUserScreen(),
                        ),
                      );
                    },
                  ),

                  // STORE SETTINGS
                  _AdminCard(
                    icon: Icons.storefront_outlined,
                    title: 'Store Settings',
                    subtitle: 'Delivery & availability',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminStoreSettingsScreen(),
                        ),
                      );
                    },
                  ),

                  // PROFILE
                  _AdminCard(
                    icon: Icons.admin_panel_settings_outlined,
                    title: 'My Profile',
                    subtitle: 'Manage your account',
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => const AdminProfileScreen(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _AdminCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  const _AdminCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        padding: const EdgeInsets.all(20),

        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 15,
              offset: const Offset(0, 5),
            ),
          ],
        ),

        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,

            children: [
              Container(
                width: 40,
                height: 40,

                decoration: BoxDecoration(
                  color: const Color(0xFFFFEEEE),
                  borderRadius: BorderRadius.circular(16),
                ),

                child: Icon(icon, color: const Color(0xFFCC0000), size: 30),
              ),

              const SizedBox(height: 14),

              Text(
                title,
                textAlign: TextAlign.center,

                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w800,
                ),
              ),

              const SizedBox(height: 5),

              Text(
                subtitle,
                textAlign: TextAlign.center,

                style: const TextStyle(fontSize: 8, color: Colors.grey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
