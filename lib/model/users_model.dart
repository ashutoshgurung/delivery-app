class UserModel {
  final String uid;
  final String name;
  final String email;
  final String imageUrl;

  const UserModel({
    required this.uid,
    required this.name,
    required this.email,
    this.imageUrl = "",
  });

  factory UserModel.fromMap(String uid, Map<String, dynamic> map) {
    return UserModel(
      uid: uid,
      name: map['name'] ?? "",
      email: map['email'] ?? "",
      imageUrl: map['imageUrl'] ?? "",
    );
  }

  Map<String, dynamic> toMap() => {
        'name': name,
        'email': email,
        'imageUrl': imageUrl,
      };

  UserModel copyWith({
    String? name,
    String? email,
    String? imageUrl,
  }) {
    return UserModel(
      uid: uid,
      name: name ?? this.name,
      email: email ?? this.email,
      imageUrl: imageUrl ?? this.imageUrl,
    );
  }
}