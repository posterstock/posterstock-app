import 'dart:math';

import 'package:flutter/material.dart';
import 'package:poster_stock/features/home/models/comment_model.dart';
import 'package:poster_stock/features/home/models/post_base_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';

class PostMovieModel extends PostBaseModel {
  final String year;
  final String imagePath;
  final bool? hasBookmarked;
  final bool? hasInCollection;
  final String? tmdbLink;
  final String? mediaType;
  final int? mediaId;

  PostMovieModel({
    required this.year,
    required this.imagePath,
    this.hasBookmarked,
    this.hasInCollection,
    this.tmdbLink,
    this.mediaId,
    this.mediaType,
    required int id,
    required String name,
    required UserModel author,
    required String time,
    required bool liked,
    required DateTime timeDate,
    int likes = 0,
    int comments = 0,
    String? description,
  }) : super(
          id: id,
          name: name,
          author: author,
          time: time,
          timeDate: timeDate,
          likes: likes,
          comments: comments,
          description: description,
          liked: liked,
        );

  factory PostMovieModel.fromJson(Map<String, Object?> json, {bool previewPrimary = false}) {
    const List<Color> avatar = [
      Color(0xfff09a90),
      Color(0xfff3d376),
      Color(0xff92bdf4),
    ];
    return PostMovieModel(
      id: json['id'] as int? ?? -1,
      liked: json['has_liked'] as bool? ?? false,
      hasBookmarked: json['has_bookmarked'] as bool?,
      hasInCollection: false,
      year: (json['end_year'] as int?) == null
          ? (json['start_year'] as int).toString()
          : '${(json['start_year'] as int).toString()} - ${(json['end_year'] as int?).toString()}',
      imagePath: (previewPrimary ?
      (json['preview_image'] as String? ?? json['image'] as String?) : (json['image'] as String? ?? json['preview_image'] as String?)) ?? '',
      name: json['title'] as String,
      author: json['user'] == null
          ? UserModel(
              id: json['user_id'] as int? ?? 0,
              name: json['name'] as String? ?? '',
              username: json['username'] as String? ?? '',
              imagePath:(json['profile_image'] as String?) == "https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp" ? null : json['profile_image'] as String?,
              followed: !(json['is_suggested'] as bool? ?? !(json['is_following'] as bool? ?? false)),
              color: avatar[(json['user_id'] as int? ?? 0) % 3],
            )
          : UserModel.fromJson(json['user'] as Map<String, dynamic>),
      timeDate: json['created_at'] == null
          ? DateTime.now()
          : DateTime.fromMillisecondsSinceEpoch(
              (json['created_at'] as int) * 1000),
      time: json['created_at'] == null
          ? ''
          : _getTimeString(
              DateTime.fromMillisecondsSinceEpoch(
                  (json['created_at'] as int) * 1000),
            ),
      likes: json['likes_count'] as int? ?? 0,
      comments: json['comments_count'] as int? ?? 0,
      description: json['description'] as String?,
      tmdbLink: json['tmdb_link'] as String?,
      mediaId: json['media_id'] as int?,
      mediaType: json['media_type'] as String?,
    );
  }

  @override
  PostMovieModel copyWith({
    String? year,
    String? imagePath,
    int? id,
    String? name,
    UserModel? author,
    String? time,
    DateTime? timeDate,
    bool? liked,
    int? likes,
    int? comments,
    String? description,
    bool? hasBookmarked,
    bool? hasInCollection,
  }) {
    return PostMovieModel(
      year: year ?? this.year,
      hasBookmarked: hasBookmarked ?? this.hasBookmarked,
      hasInCollection: hasInCollection ?? this.hasInCollection,
      imagePath: imagePath ?? this.imagePath,
      id: id ?? this.id,
      name: name ?? this.name,
      author: author ?? this.author,
      time: time ?? this.time,
      timeDate: timeDate ?? this.timeDate,
      liked: liked ?? this.liked,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      description: description ?? this.description,
      mediaId: mediaId,
      mediaType: mediaType,
      tmdbLink: tmdbLink,
    );
  }

  static String _getTimeString(DateTime date) {
    DateTime now = DateTime.now();
    Duration diff = now.difference(date).abs();
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
}
