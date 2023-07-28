import 'package:poster_stock/features/home/models/comment_model.dart';
import 'package:poster_stock/features/home/models/post_base_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';

class PostMovieModel extends PostBaseModel {
  final String year;
  final String imagePath;

  PostMovieModel({
    required this.year,
    required this.imagePath,
    required int id,
    required String name,
    required UserModel author,
    required String time,
    required bool liked,
    int likes = 0,
    int comments = 0,
    String? description,
  }) : super(
          id: id,
          name: name,
          author: author,
          time: time,
          likes: likes,
          comments: comments,
          description: description,
          liked: liked,
        );

  factory PostMovieModel.fromJson(Map<String, Object?> json) {
    return PostMovieModel(
      id: json['id'] as int,
      liked: json['has_liked'] as bool,
      year: json['end_year'] == null
          ? (json['start_year'] as int).toString()
          : '${(json['start_year'] as int).toString()} - ${(json['end_year'] as int).toString()}',
      imagePath: json['image'] as String,
      name: json['title'] as String,
      author: UserModel(
        id: 1,
        name: json['name'] as String,
        username: json['username'] as String,
        imagePath: json['profile_image'] as String,
        followed: true,
      ),
      time: _getTimeString(DateTime.fromMillisecondsSinceEpoch(
          (json['created_at'] as int) * 1000)),
      likes: json['likes_count'] as int,
      comments: json['comments_count'] as int,
      description: json['description'] as String,
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
    bool? liked,
    int? likes,
    int? comments,
    String? description,
  }) {
    return PostMovieModel(
      year: year ?? this.year,
      imagePath: imagePath ?? this.imagePath,
      id: id ?? this.id,
      name: name ?? this.name,
      author: author ?? this.author,
      time: time ?? this.time,
      liked: liked ?? this.liked,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      description: description ?? this.description,
    );
  }

  static String _getTimeString(DateTime date) {
    DateTime now = DateTime.now();
    Duration diff = now.difference(date);
    if (diff.inDays > 30) {
      return "${diff.inDays / ~30} month${diff.inDays / ~30 > 1 ? "s" : ''} ago";
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
