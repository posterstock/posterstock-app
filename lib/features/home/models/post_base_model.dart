import 'package:poster_stock/features/home/models/user_model.dart';

abstract class PostBaseModel {
  final String type;
  final int id;
  final String name;
  final UserModel author;
  final String time;
  final DateTime timeDate;
  final String? description;
  final int likes;
  final int comments;
  final bool liked;

  PostBaseModel({
    required this.type,
    required this.id,
    required this.name,
    required this.author,
    required this.time,
    required this.timeDate,
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
