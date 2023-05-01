class UserDetailsModel {
  final String username;
  final String name;
  final String? description;
  final String? imagePath;
  final int following;
  final int followers;
  final int posters;
  final int lists;
  final bool followed;
  final bool mySelf;

  UserDetailsModel({
    required this.username,
    required this.name,
    required this.following,
    required this.followers,
    required this.posters,
    required this.lists,
    required this.followed,
    required this.mySelf,
    this.description,
    this.imagePath,
  });

  factory UserDetailsModel.fromJson(Map<String, Object?> json) {
    return UserDetailsModel(
      name: json['name'] as String,
      username: json['username'] as String,
      imagePath: json['avatar'] as String?,
      followed: (json['followed'] as bool?) ?? false,
      description: json['description'] as String?,
      following: json['following'] as int,
      followers: json['followers'] as int,
      posters: json['posters'] as int,
      lists: json['lists'] as int,
      mySelf: true,
    );
  }
}
