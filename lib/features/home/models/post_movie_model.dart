import 'package:poster_stock/features/home/models/comment_model.dart';
import 'package:poster_stock/features/home/models/post_base_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';

class PostMovieModel extends PostBaseModel {
  final int year;
  final String imagePath;

  PostMovieModel({
    required this.year,
    required this.imagePath,
    required String name,
    required UserModel author,
    required String time,
    List<UserModel> likes = const [],
    List<CommentModel> comments = const [],
    String? description,
  }) : super(
          name: name,
          author: author,
          time: time,
          likes: likes,
          comments: comments,
          description: description,
        );

  factory PostMovieModel.fromJson(Map<String, Object?> json) {
    return PostMovieModel(
      year: json['year'] as int,
      imagePath: json['poster'] as String,
      name: json['name'] as String,
      author: UserModel.fromJson(json['user'] as Map<String, Object?>),
      time: json['time'] as String,
      likes: (json['likes'] as List<Map<String, Object?>>?)
              ?.map<UserModel>((e) => UserModel.fromJson(e))
              .toList() ??
          [],
      comments: (json['comments'] as List<Map<String, Object?>>?)
          ?.map<CommentModel>((e) => CommentModel.fromJson(e))
          .toList() ?? [],
      description: json['description'] as String,
    );
  }
}
