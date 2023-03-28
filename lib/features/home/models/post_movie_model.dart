import 'package:poster_stock/features/home/models/user_model.dart';

class PostMovieModel {
  final String name;
  final int year;
  final UserModel author;
  final String imagePath;
  final String time;
  final List<UserModel> likes;
  final List<UserModel> comments;
  final String? description;

  PostMovieModel({
    required this.name,
    required this.year,
    required this.imagePath,
    required this.author,
    required this.time,
    this.likes = const [],
    this.comments = const [],
    this.description,
  });
}
