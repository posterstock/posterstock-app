abstract class INotificationsService {
  Future<Map<String, dynamic>> getNotifications(String token, int offset);
}
