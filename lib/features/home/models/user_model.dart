class UserModel {
  final String name;
  final String username;
  final String? imagePath;
  final bool? followed;
  final String? description;

  UserModel({
    required this.name,
    required this.username,
    this.imagePath,
    this.followed,
    this.description
  });
}
