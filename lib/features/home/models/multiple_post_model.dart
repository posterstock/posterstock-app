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
    required DateTime timeDate,
    int likes = 0,
    int comments = 0,
    String? description,
  }) : super(
          id: id,
          name: name,
          author: author,
          time: time,
          timeDate: timeDate,
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
      time: _getTimeString(
          DateTime.fromMillisecondsSinceEpoch((json['created_at'] as int) * 1000)),
      timeDate:
          DateTime.fromMillisecondsSinceEpoch((json['created_at'] as int) * 1000),
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

  static String _getTimeString(DateTime date) {
    DateTime now = DateTime.now();
    Duration diff = now.difference(date);
    if (diff.inDays > 30) {
      return "${diff.inDays ~/ 30} month${diff.inDays ~/ 30 > 1 ? "s" : ''} ago";
    } else if (diff.inDays > 0) {
      return "${diff.inDays} day${diff.inDays > 1 ? "s" : ''} ago";
    } else if (diff.inHours > 0) {
      return "${diff.inHours} hour${diff.inHours > 1 ? "s" : ''} ago";
    } else if (diff.inMinutes > 0) {
      return "${diff.inMinutes} minute${diff.inMinutes > 1 ? "s" : ''} ago";
    }
    return "Less than a minute ago";
  }

  @override
  MultiplePostModel copyWith(
      {int? id,
      String? name,
      UserModel? author,
      String? time,
      DateTime? timeDate,
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
      timeDate: timeDate ?? this.timeDate,
      description: description ?? this.description,
      likes: likes ?? this.likes,
      comments: comments ?? this.comments,
      liked: liked ?? this.liked,
    );
  }
}
