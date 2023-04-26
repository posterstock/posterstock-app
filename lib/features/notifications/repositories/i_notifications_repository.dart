import 'package:poster_stock/features/notifications/models/notification_model.dart';

abstract class INotificationsRepository {
  Future<List<NotificationModel>> getNotifications();
}