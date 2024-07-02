class NotificationModel {
  final String id;
  final String image;
  final String name;
  final String? profileImage;
  final String deepLink;
  final String info;
  final DateTime time;
  final String profileDeepLink;

  NotificationModel({
    required this.id,
    required this.image,
    required this.name,
    required this.profileImage,
    required this.info,
    required this.time,
    required this.deepLink,
    required this.profileDeepLink,
  });

  factory NotificationModel.fromJson(Map<String, Object?> json) {
    return NotificationModel(
      id: json.toString(),
      info: (json['text'] as String).replaceFirst(
          json['profile_name'] as String? ?? 'OLD NOTIFICATION', ''),
      name: json['profile_name'] as String? ?? 'OLD NOTIFICATION ',
      image: json['entity_image'] as String,
      profileImage: (json['profile_image'] as String?) ==
              "https://www.gravatar.com/avatar/00000000000000000000000000000000?d=mp"
          ? null
          : json['profile_image'] as String?,
      deepLink: convertDeepLink(json['deep_link'] as String),
      time: DateTime.fromMillisecondsSinceEpoch((json['sent_at'] as int) * 1000,
          isUtc: false),
      profileDeepLink: json['user_deep_link'] as String,
    );
  }

  static String convertDeepLink(String value) {
    var splittedUrl = value.split('/');
    String initLink = '';
    bool hasHttp = splittedUrl[0].startsWith('http');
    splittedUrl.removeAt(0);
    if (hasHttp) {
      splittedUrl.removeAt(0);
      splittedUrl.removeAt(0);
    }
    initLink = '/';
    for (var i = 0; i < splittedUrl.length; i++) {
      initLink = '$initLink${splittedUrl[i]}/';
    }
    return initLink;
  }

  static String getTimeString(DateTime date) {
    date = date;
    DateTime now = DateTime.now().toUtc().add(const Duration(hours: 3));
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
