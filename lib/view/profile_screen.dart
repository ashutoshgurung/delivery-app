import 'dart:io';
import 'package:flutter/material.dart';
import 'package:food_ordering_app/view/sign_in.dart';
import 'package:food_ordering_app/viewmodel/profile_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  static const Color red = Color(0xFFE53935);
  static const Color bg = Color(0xFFF8F8F8);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<ProfileViewModel>().loadUser();
    });
  }

  Future<void> pickImage(ProfileViewModel vm) async {
    final picker = ImagePicker();

    final picked = await picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 75,
      maxWidth: 512,
    );

    if (picked == null) return;

    await vm.updateProfileImage(File(picked.path));
  }

  Future<void> logout(ProfileViewModel vm) async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (_) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
        title: Text(
          "Logout",
          style: GoogleFonts.poppins(fontWeight: FontWeight.bold),
        ),
        content: Text(
          "Are you sure you want to logout?",
          style: GoogleFonts.poppins(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: Text(
              "Cancel",
              style: GoogleFonts.poppins(color: Colors.grey),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: red,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              "Logout",
              style: GoogleFonts.poppins(color: Colors.white),
            ),
          ),
        ],
      ),
    );

    if (confirm != true) return;

    final success = await vm.logout();

    if (!mounted) return;

    if (success) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const SignInScreen()),
        (route) => false,
      );
    }
  }

  Widget buildAvatar(ProfileViewModel vm) {
    return Stack(
      children: [
        Container(
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.18),
                blurRadius: 20,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: CircleAvatar(
            radius: 58,
            backgroundColor: Colors.white,
            backgroundImage: vm.user?.imageUrl.isNotEmpty == true
                ? NetworkImage(vm.user!.imageUrl)
                : null,
            child: vm.user?.imageUrl.isEmpty != false
                ? Icon(Icons.person, size: 55, color: Colors.grey.shade400)
                : null,
          ),
        ),

        Positioned(
          bottom: 0,
          right: 0,
          child: GestureDetector(
            onTap: () => pickImage(vm),
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: red,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
              ),
              child: const Icon(
                Icons.camera_alt,
                size: 16,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget buildStatsRow(ProfileViewModel vm) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 18),
      padding: const EdgeInsets.symmetric(vertical: 18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 18,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          buildStat("${vm.orderCount}", "Orders"),
          divider(),
          buildStat("${vm.favouriteCount}", "Favorites"),
          divider(),
          buildStat("${vm.addressCount}", "Address"),
        ],
      ),
    );
  }

  Widget divider() {
    return Container(height: 35, width: 1, color: Colors.grey.shade300);
  }

  Widget buildStat(String value, String label) {
    return Column(
      children: [
        Text(
          value,
          style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey.shade600),
        ),
      ],
    );
  }

  Widget buildTile({
    required IconData icon,
    required String title,
    VoidCallback? onTap,
    bool logout = false,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 6),
      child: Container(
        decoration: BoxDecoration(
          
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.04),
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Material(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          clipBehavior: Clip.antiAlias,
          child: ListTile(
            onTap: onTap,
            leading: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: logout ? Colors.red.shade50 : Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: logout ? Colors.red : red),
            ),
            title: Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w500,
                color: logout ? Colors.red : Colors.black87,
              ),
            ),
            trailing: logout
                ? null
                : const Icon(Icons.arrow_forward_ios, size: 16),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<ProfileViewModel>(
      builder: (context, vm, _) {
        return Scaffold(
          backgroundColor: bg,
          appBar: AppBar(
            automaticallyImplyLeading: false,
            elevation: 0,
            backgroundColor: red,
            centerTitle: true,
            title: Text(
              "Profile",
              style: GoogleFonts.poppins(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          body: vm.isLoading
              ? const Center(child: CircularProgressIndicator(color: red))
              : vm.state == ProfileState.error
              ? Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.error_outline, color: red, size: 48),
                        const SizedBox(height: 12),
                        Text(
                          vm.errorMessage ?? 'Unable to load your profile.',
                          textAlign: TextAlign.center,
                          style: GoogleFonts.poppins(),
                        ),
                        const SizedBox(height: 16),
                        ElevatedButton(
                          onPressed: vm.loadUser,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: red,
                            foregroundColor: Colors.white,
                          ),
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  ),
                )
              : SingleChildScrollView(
                  child: Column(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: const BoxDecoration(
                          color: red,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(28),
                            bottomRight: Radius.circular(28),
                          ),
                        ),
                        child: Column(
                          children: [
                            const SizedBox(height: 20),
                            buildAvatar(vm),
                            const SizedBox(height: 14),
                            Text(
                              vm.user?.name ?? "User",
                              style: GoogleFonts.poppins(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              vm.user?.email ?? "",
                              style: GoogleFonts.poppins(color: Colors.white70),
                            ),
                            const SizedBox(height: 35),
                          ],
                        ),
                      ),

                      Transform.translate(
                        offset: const Offset(0, -25),
                        child: buildStatsRow(vm),
                      ),

                      buildTile(
                        icon: Icons.location_on_outlined,
                        title: "Delivery Address",
                      ),
                      buildTile(
                        icon: Icons.settings_outlined,
                        title: "Settings",
                      ),
                      buildTile(
                        icon: Icons.logout,
                        title: "Logout",
                        logout: true,
                        onTap: () => logout(vm),
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
        );
      },
    );
  }
}
