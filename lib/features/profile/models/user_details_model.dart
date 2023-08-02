class UserDetailsModel {
  final int id;
  final String username;
  final String name;
  final String? description;
  final String? imagePath;
  final int following;
  final int followers;
  final bool followed;
  final bool mySelf;

  UserDetailsModel({
    required this.id,
    required this.username,
    required this.name,
    required this.following,
    required this.followers,
    required this.followed,
    required this.mySelf,
    this.description,
    this.imagePath,
  });

  factory UserDetailsModel.fromJson(Map<String, Object?> json) {
    return UserDetailsModel(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      imagePath: json['image'] as String?,
      followed: (json['followed'] as bool?) ?? true,
      description: json['description'] as String?,
      following: json['following'] as int,
      followers: json['followers'] as int,
      mySelf: json['myself'] as bool? ?? false,
    );
  }
}
