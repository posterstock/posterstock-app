import 'package:poster_stock/features/home/models/user_model.dart';

class MultiplePostModel {
  final String name;
  final UserModel author;
  final List<String> imagePath;
  final String time;
  final int likes;
  final int comments;
  final String? description;

  MultiplePostModel({
    required this.name,
    required this.imagePath,
    required this.author,
    required this.time,
    this.likes = 0,
    this.comments = 0,
    this.description,
  });
}