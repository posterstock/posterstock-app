import 'dart:math';

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
      imagePath: json['image'] as String?,
      followed: (json['followed'] as bool?) ?? false,
      description: json['description'] as String?,
      color: avatar[Random().nextInt(3)],
    );
  }

  @override
  String toString() {
    return '$name $username $followed';
  }
}
