import 'package:poster_stock/features/home/models/user_model.dart';

abstract class PostBaseModel {
  final String? type;
  final int id;
  final String name;
  final UserModel author;
  final int? creationTime;
  final String? description;
  final int likes;
  final int comments;
  final bool liked;

  PostBaseModel({
    required this.type,
    required this.id,
    required this.name,
    required this.author,
    required this.creationTime,
    required this.description,
    required this.likes,
    required this.comments,
    required this.liked,
  });

  get time => creationTime == null
      ? ''
      : _getTimeString(
          DateTime.fromMillisecondsSinceEpoch(creationTime! * 1000),
        );

  get timeDate => creationTime == null
      ? DateTime.now()
      : DateTime.fromMillisecondsSinceEpoch(creationTime! * 1000);

  PostBaseModel copyWith({
    int? id,
    String? name,
    UserModel? author,
    int? creationTime,
    String? description,
    int? likes,
    int? comments,
    bool? liked,
  });

  static String _getTimeString(DateTime date) {
    DateTime now = DateTime.now();
    Duration diff = now.difference(date).abs();
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
}
