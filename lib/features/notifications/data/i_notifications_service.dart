abstract class INotificationsService {
  Future<Map<String, dynamic>> getNotifications({
    bool getNewPosts = false,
  });
}
