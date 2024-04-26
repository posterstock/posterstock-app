import 'package:flutter/material.dart';
import 'package:poster_stock/features/home/models/post_base_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';

class MultiplePostSingleModel {
  final int id;
  final int startYear;
  final int? endYear;
  final String image;
  final String title;
  final String? description;

  MultiplePostSingleModel({
    required this.id,
    required this.startYear,
    this.endYear,
    required this.image,
    required this.title,
    this.description,
  });

  factory MultiplePostSingleModel.fromJson(Map<String, dynamic> json) {
    return MultiplePostSingleModel(
      id: json['id'] as int,
      startYear: json['start_year'],
      endYear: json['end_year'],
      image: json['preview_image'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'start_year': startYear,
        'end_year': endYear,
        'description': description,
        'preview_image': image,
        'title': title,
      };
}

class MultiplePostModel extends PostBaseModel {
  final List<MultiplePostSingleModel> posters;
  final String? image;

  MultiplePostModel({
    required this.posters,
    this.image,
    required String name,
    required UserModel author,
    required String time,
    required int id,
    required bool liked,
    required DateTime timeDate,
    required String type,
    int likes = 0,
    int comments = 0,
    String? description,
  }) : super(
          type: type,
          id: id,
          name: name,
          author: author,
          time: time,
          timeDate: timeDate,
          likes: likes,
          liked: liked,
          comments: comments,
          description: description,
        );

  factory MultiplePostModel.fromJson(Map<String, Object?> json,
      {bool previewPrimary = false}) {
    const List<Color> avatar = [
      Color(0xfff09a90),
      Color(0xfff3d376),
      Color(0xff92bdf4),
    ];
    final img = (previewPrimary
            ? (json['preview_image'] as String? ?? json['image'] as String?)
            : (json['image'] as String? ?? json['preview_image'] as String?)) ??
        '';
    final image = img == 'https://api.posterstock.com/images/'
        ? 'https://api.posterstock.com/images/default_list_cover.png'
        : img;
    print("GGGG");
    print(json['title'] as String?);
    print((json['title'] as String?)?.replaceAll('\n', "F"));
    print(json['description'] as String?);
    print((json['description'] as String?)?.replaceAll('\n', "F"));
    return MultiplePostModel(
      type: json['type'] as String,
      id: json['id'] as int,
      name: json['title'] as String,
      liked: json['has_liked'] as bool,
      author: json['user'] == null
          ? UserModel(
              id: json['user_id'] as int? ?? 0,
              name: json['name'] as String? ?? '',
              username: json['username'] as String? ?? '',
              imagePath: (json['profile_image'] as String?) ==
                      "https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp"
                  ? null
                  : json['profile_image'] as String?,
              followed: !(json['is_suggested'] as bool? ?? true),
              color: avatar[(json['user_id'] as int? ?? 0) % 3],
            )
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      time: _getTimeString(DateTime.fromMillisecondsSinceEpoch(
          (json['created_at'] as int? ??
                  DateTime.now().millisecondsSinceEpoch) *
              1000)),
      timeDate: DateTime.fromMillisecondsSinceEpoch(
          (json['created_at'] as int? ??
                  DateTime.now().millisecondsSinceEpoch) *
              1000),
      likes: json['likes_count'] as int,
      comments: json['comments_count'] as int,
      description: json['description'] as String?,
      posters: (json['posters'] as List<dynamic>?)
              ?.map(
                (e) => MultiplePostSingleModel.fromJson(e),
              )
              .toList() ??
          [],
      image: image,
    );
  }

  Map<String, dynamic> toJson() => {
        'type': type,
        'id': id,
        'has_liked': liked,
        'title': name,
        'description': description,
        'likes_count': likes,
        'comments_count': comments,
        'user': author.toJson(),
        'image': image,
        // 'posters': posters.map((i) => i.toJson()),
      };

  static String _getTimeString(DateTime date) {
    DateTime now = DateTime.now();
    Duration diff = now.difference(date);
    if (diff.inDays > 30) {
      return "${diff.inDays ~/ 30} month${diff.inDays ~/ 30 > 1 ? "s" : ''} ago";
    } else if (diff.inDays > 0) {
      return "${diff.inDays} day${diff.inDays > 1 ? "s" : ''} ago";
    } else if (diff.inHours > 0) {
      return "${diff.inHours} hour${diff.inHours > 1 ? "s" : ''} ago";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes} minute${diff.inMinutes > 1 ? "s" : ''} ago";
    }
    return "Less than a minute ago";
  }

  @override
  MultiplePostModel copyWith({
    int? id,
    String? type,
    String? name,
    UserModel? author,
    String? time,
    DateTime? timeDate,
    String? description,
    int? likes,
    int? comments,
    bool? liked,
    String? image,
  }) {
    return MultiplePostModel(
      posters: posters,
      id: id ?? this.id,
      type: type ?? this.type,
      name: name ?? this.name,
      author: author ?? this.author,
      time: time ?? this.time,
      timeDate: timeDate ?? this.timeDate,
      description: description ?? this.description,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      liked: liked ?? this.liked,
      image: image ?? this.image,
    );
  }
}
