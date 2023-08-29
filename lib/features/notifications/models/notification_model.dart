import 'package:poster_stock/features/home/models/user_model.dart';

class NotificationModel {
  final String id;
  final String image;
  final String profileImage;
  final String deepLink;
  final String info;
  final String time;

  NotificationModel({
    required this.id,
    required this.image,
    required this.profileImage,
    required this.info,
    required this.time,
    required this.deepLink,
  });

  factory NotificationModel.fromJson(Map<String, Object?> json) {
    return NotificationModel(
      id: json.toString(),
      info: json['text'] as String,
      image: json['entity_image'] as String,
      profileImage: json['profile_image'] as String,
      deepLink: convertDeepLink(json['deep_link'] as String),
      time: json['created_at'] == null
          ? ''
          : _getTimeString(
        DateTime.fromMillisecondsSinceEpoch(
            (json['sent_at'] as int) * 1000),
      ),
    );
  }

  static String convertDeepLink(String value) {
    var splittedUrl = value.split('/') ?? [];
    String initLink = '';
    bool hasHttp = splittedUrl[0].startsWith('http');
    splittedUrl.removeAt(0);
    if (hasHttp) {
      splittedUrl.removeAt(0);
      splittedUrl.removeAt(0);
    }
    initLink = '/';
    for (var i = 0; i < splittedUrl.length; i++) {
      initLink = '${initLink!}${splittedUrl[i]}/';
    }
    return initLink;
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
}
