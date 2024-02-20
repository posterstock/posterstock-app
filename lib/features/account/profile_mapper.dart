import 'dart:ui';

import 'package:poster_stock/features/profile/models/user_details_model.dart';

class ProfileMapper {
  static UserDetailsModel fromJson(Map<String, Object?> json) {
    const List<Color> avatar = [
      Color(0xfff09a90),
      Color(0xfff3d376),
      Color(0xff92bdf4),
    ];
    return UserDetailsModel(
      id: json['id'] as int,
      name: json['name'] as String,
      username: json['username'] as String,
      imagePath: (json['image'] as String?) ==
              "https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp"
          ? null
          : json['image'] as String?,
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
}
