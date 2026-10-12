class AppUserModel {
  final String id;
  final String name;
  final String email;
  final String phone;
  final bool isAdmin;

  const AppUserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.isAdmin = false,
  });

  factory AppUserModel.fromMap(String id, Map<String, dynamic> map) {
    return AppUserModel(
      id: id,
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      phone: map['phone'] ?? '',
      // FIX: 'role' is the single source of truth (matches AuthServices.getUserRole
      // and AdminViewModel.setUserAdmin), not a separate 'isAdmin' field.
      isAdmin: (map['role'] ?? 'user') == 'admin',
    );
  }
}