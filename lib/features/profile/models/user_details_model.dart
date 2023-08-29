import 'dart:math';

import 'package:flutter/material.dart';

class UserDetailsModel {
  final int id;
  final String username;
  final String name;
  final String? description;
  final String? imagePath;
  final Color? color;
  final int following;
  final int followers;
  final bool followed;
  final bool mySelf;
  final int posters;
  final int lists;

  UserDetailsModel({
    required this.id,
    required this.username,
    required this.name,
    required this.following,
    required this.followers,
    required this.followed,
    required this.mySelf,
    this.color,
    this.posters = 0,
    this.lists = 0,
    this.description,
    this.imagePath,
  });

  factory UserDetailsModel.fromJson(Map<String, Object?> json) {
    const List<Color> avatar = [
      Color(0xfff09a90),
      Color(0xfff3d376),
      Color(0xff92bdf4),
    ];
    return UserDetailsModel(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      imagePath: (json['image'] as String?) == "https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp" ? null : json['image'] as String?,
      followed: (json['is_following'] as bool?) ?? false,
      description: json['description'] as String?,
      following: json['following'] as int? ?? 0,
      followers: json['followers'] as int? ?? 0,
      mySelf: json['myself'] as bool? ?? false,
      posters: json['posters'] as int? ?? 0,
      lists: json['lists'] as int? ?? 0,
      color: avatar[(json['id'] as int) % 3],
    );
  }

  UserDetailsModel copyWith({
    int? id,
    String? username,
    String? name,
    String? description,
    String? imagePath,
    int? following,
    int? followers,
    bool? followed,
    bool? mySelf,
    int? posters,
    int? lists,
  }) {
    return UserDetailsModel(
      id: id ?? this.id,
      username: username ?? this.username,
      name: name ?? this.name,
      description: description ?? this.description,
      imagePath: imagePath ?? this.imagePath,
      following: following ?? this.following,
      followers: followers ?? this.followers,
      followed: followed ?? this.followed,
      mySelf: mySelf ?? this.mySelf,
      posters: posters ?? this.posters,
      lists: lists ?? this.lists,
      color: color,
    );
  }
}
