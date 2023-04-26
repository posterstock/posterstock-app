import 'package:poster_stock/features/home/models/user_model.dart';

class NotificationModel {
  final UserModel user;
  final String info;
  final String time;

  NotificationModel({
    required this.user,
    required this.info,
    required this.time,
  });

  factory NotificationModel.fromJson(Map<String, Object?> json) {
    return NotificationModel(
      user: UserModel.fromJson(json['user'] as Map<String, Object?>),
      info: json['info'] as String,
      time: json['time'] as String,
    );
  }
}
