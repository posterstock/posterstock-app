import 'package:poster_stock/features/home/models/user_model.dart';

class CommentModel {
  final String comment;
  final UserModel user;
  final String time;

  CommentModel({
    required this.comment,
    required this.user,
    required this.time,
});

  factory CommentModel.fromJson(Map<String, Object?> json) {
    return CommentModel(
      comment: json['comment'] as String,
      user: UserModel.fromJson(json['user'] as Map<String, Object?>),
      time: json['time'] as String,
    );
  }
}