import 'package:poster_stock/features/home/models/comment_model.dart';
import 'package:poster_stock/features/home/models/post_base_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';

class MultiplePostModel extends PostBaseModel {
  final List<String> posters;

  MultiplePostModel({
    required this.posters,
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

  factory MultiplePostModel.fromJson(Map<String, Object?> json) {
    return MultiplePostModel(
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
      posters: json['posters'] as List<String>,
    );
  }
}
