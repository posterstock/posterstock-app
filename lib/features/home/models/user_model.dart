class UserModel {
  final int id;
  final String name;
  final String username;
  final String? imagePath;
  final bool followed;
  final String? description;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    this.imagePath,
    this.followed = false,
    this.description,
  });

  factory UserModel.fromJson(Map<String, Object?> json) {
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      imagePath: json['avatar'] as String?,
      followed: (json['followed'] as bool?) ?? false,
      description: json['description'] as String?,
    );
  }

  @override
  String toString() {
    return '$name $username $followed';
  }
}
