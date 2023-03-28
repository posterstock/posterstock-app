import 'package:poster_stock/features/home/models/user_model.dart';

class MultiplePostModel {
  final String name;
  final UserModel author;
  final List<String> posters;
  final String time;
  final List<UserModel> likes;
  final List<UserModel> comments;
  final String? description;

  MultiplePostModel({
    required this.name,
    required this.posters,
    required this.author,
    required this.time,
    this.likes = const [],
    this.comments = const [],
    this.description,
  });
}