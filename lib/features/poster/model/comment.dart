import 'package:poster_stock/features/home/models/user_model.dart';

class Comment {
  final int id;
  final String text;
  final String time;
  final UserModel model;

  Comment({
    required this.id,
    required this.text,
    required this.time,
    required this.model,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      text: json['text'],
      time: _getTimeString(DateTime.fromMillisecondsSinceEpoch(json['timestamp'] * 1000)),
      model: UserModel.fromJson(json['user']),
    );
  }

  static String _getTimeString(DateTime date) {
    DateTime now = DateTime.now();
    Duration diff = now.difference(date);
    if (diff.inDays > 30) {
      return "${diff.inDays / ~30} month${diff.inDays / ~30 > 1 ? "s" : ''} ago";
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
