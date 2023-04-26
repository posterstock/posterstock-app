import 'package:poster_stock/features/notifications/data/mock_notifications_service.dart';
import 'package:poster_stock/features/notifications/models/notification_model.dart';
import 'package:poster_stock/features/notifications/repositories/i_notifications_repository.dart';

import '../data/i_notifications_service.dart';

class NotificationsRepository implements INotificationsRepository {
  final INotificationsService service = MockNotificationsService();

  @override
  Future<List<NotificationModel>> getNotifications() async {
    List<Map<String, Object?>> unParsedData =
        (await service.getNotifications('mock', 0))['data']['notifications'];
    return unParsedData.map((e) => NotificationModel.fromJson(e)).toList();
  }
}
