import 'package:poster_stock/features/notifications/data/notifications_service.dart';
import 'package:poster_stock/features/notifications/models/notification_model.dart';
import 'package:poster_stock/features/notifications/repositories/i_notifications_repository.dart';

import '../data/i_notifications_service.dart';

class NotificationsRepository implements INotificationsRepository {
  final INotificationsService service = NotificationsService();

  @override
  Future<List<NotificationModel>> getNotifications({
    bool getNewPosts = false,
  }) async {
    List<dynamic>? unParsedData = (await service.getNotifications(
        getNewPosts: getNewPosts))['notifications'];
    return unParsedData?.map((e) => NotificationModel.fromJson(e)).toList() ??
        [];
  }
}
