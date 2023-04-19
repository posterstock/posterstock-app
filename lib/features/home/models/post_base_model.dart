import 'package:poster_stock/features/home/models/comment_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';

abstract class PostBaseModel {
  final String name;
  final UserModel author;
  final String time;
  final String? description;
  final List<UserModel> likes;
  final List<CommentModel> comments;

  PostBaseModel({
    required this.name,
    required this.author,
    required this.time,
    required this.description,
    required this.likes,
    required this.comments,
  });
}
