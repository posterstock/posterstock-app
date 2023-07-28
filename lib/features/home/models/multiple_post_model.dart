import 'package:poster_stock/features/home/models/comment_model.dart';
import 'package:poster_stock/features/home/models/post_base_model.dart';
import 'package:poster_stock/features/home/models/user_model.dart';

class MultiplePostSingleModel {
  final int id;
  final String years;
  final String image;
  final String title;

  MultiplePostSingleModel({
    required this.id,
    required this.years,
    required this.image,
    required this.title,
  });

  factory MultiplePostSingleModel.fromJson(Map<String, dynamic> json) {
    return MultiplePostSingleModel(
      id: json['id'],
      years: json['end_year'] == null
          ? json['start_year']
          : '${json['start_year']} - ${json['end_year']}',
      image: json['preview_image'],
      title: json['title'],
    );
  }
}

class MultiplePostModel extends PostBaseModel {
  final List<MultiplePostSingleModel> posters;

  MultiplePostModel({
    required this.posters,
    required String name,
    required UserModel author,
    required String time,
    required int id,
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
          liked: liked,
          comments: comments,
          description: description,
        );

  factory MultiplePostModel.fromJson(Map<String, Object?> json) {
    return MultiplePostModel(
      id: json['id'] as int,
      name: json['title'] as String,
      liked: json['has_liked'] as bool,
      author: UserModel.fromJson(json['user'] as Map<String, Object?>),
      time: json['time'] as String,
      likes: json['likes_count'] as int,
      comments: json['comments_count'] as int,
      description: json['description'] as String,
      posters: (json['posters'] as List<Map<String, dynamic>>)
          .map(
            (e) => MultiplePostSingleModel.fromJson(e),
          )
          .toList(),
    );
  }

  @override
  MultiplePostModel copyWith(
      {int? id,
      String? name,
      UserModel? author,
      String? time,
      String? description,
      int? likes,
      int? comments,
      bool? liked}) {
    return MultiplePostModel(
      posters: posters,
      id: id ?? this.id,
      name: name ?? this.name,
      author: author ?? this.author,
      time: time ?? this.time,
      description: description ?? this.description,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      liked: liked ?? this.liked,
    );
  }
}
