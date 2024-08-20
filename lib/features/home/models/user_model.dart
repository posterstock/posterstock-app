import 'package:flutter/material.dart';

class UserModel {
  final int id;
  final String name;
  final String username;
  final String? imagePath;
  final bool followed;
  final String? description;
  final Color? color;

  UserModel({
    required this.id,
    required this.name,
    required this.username,
    this.imagePath,
    this.followed = false,
    this.description,
    this.color,
  });

  factory UserModel.fromJson(Map<String, Object?> json) {
    const List<Color> avatar = [
      Color(0xfff09a90),
      Color(0xfff3d376),
      Color(0xff92bdf4),
    ];
    return UserModel(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      imagePath: (json['image'] as String?) ==
              "https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp"
          ? null
          : json['image'] as String?,
      followed: (json['followed'] as bool?) ??
          (json['is_following'] as bool?) ??
          false,
      description: json['description'] as String?,
      color: avatar[(json['id'] as int) % 3],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'username': username,
        'image': imagePath,
        'followed': followed,
        'description': description,
      };

  @override
  String toString() {
    return '$name $username $followed';
  }

  UserModel copyWith({
    int? id,
    String? name,
    String? username,
    String? imagePath,
    bool? followed,
    String? description,
    Color? color,
  }) {
    return UserModel(
      id: id ?? this.id,
      name: name ?? this.name,
      username: username ?? this.username,
      imagePath: imagePath ?? this.imagePath,
      followed: followed ?? this.followed,
      description: description ?? this.description,
      color: color ?? this.color,
    );
  }

  factory UserModel.init() {
    return UserModel(
      id: 0,
      name: '',
      username: '',
      imagePath: '',
      followed: false,
      description: '',
      color: Colors.white,
    );
  }
}
