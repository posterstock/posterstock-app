import 'package:poster_stock/features/home/models/comment_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';

abstract class PostBaseModel {
  final int id;
  final String name;
  final UserModel author;
  final String time;
  final String? description;
  final int likes;
  final int comments;
  final bool liked;

  PostBaseModel({
    required this.id,
    required this.name,
    required this.author,
    required this.time,
    required this.description,
    required this.likes,
    required this.comments,
    required this.liked,
  });

  PostBaseModel copyWith({
    int? id,
    String? name,
    UserModel? author,
    String? time,
    String? description,
    int? likes,
    int? comments,
    bool? liked,
  });
}
