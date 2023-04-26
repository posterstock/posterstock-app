import 'package:poster_stock/features/notifications/data/i_notifications_service.dart';

class MockNotificationsService implements INotificationsService {
  @override
  Future<Map<String, dynamic>> getNotifications(
      String token, int offset) async {
    await Future.delayed(const Duration(seconds: 2), () {});
    return {
      'data': {
        'notifications': [
          {
            'user': {
              'name': 'Mikhail Kiva',
              'username': 'itsmishakiva',
              'followed': true
            },
            'info': 'commented your poster: «The Lord of the Rings»',
            'time': '8 min ago',
          },
          {
            'user': {
              'name': 'Ian Rakeda',
              'username': 'rakeda',
              'followed': true
            },
            'info': 'followed you',
            'time': '14 hours ago',
          },
        ],
      },
    };
  }
}
