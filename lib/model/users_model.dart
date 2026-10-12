class UserModel {
  final String uid;
  final String name;
  final String email;
  final String imageUrl;
  final String role;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.imageUrl = "",
    this.role = "user",
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      imageUrl: map['imageUrl'] ?? "",
      role: map['role'] ?? "user",
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      'imageUrl': imageUrl,
      'role': role,
    };
  }

  UserModel copyWith({
    String? name,
    String? email,
    String? imageUrl,
    String? role,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
      role: role ?? this.role,
    );
  }
}