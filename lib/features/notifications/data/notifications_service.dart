import 'package:dio/dio.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:poster_stock/features/notifications/data/i_notifications_service.dart';
import 'package:supertokens_flutter/dio.dart';
import 'package:supertokens_flutter/supertokens.dart';

class NotificationsService implements INotificationsService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.posterstock.com/',
      connectTimeout: 10000,
      receiveTimeout: 10000,
    ),
  );

  String? token;
  String? cursor;
  bool loadedAll = false;

  NotificationsService() {
    _dio.interceptors.add(SuperTokensInterceptorWrapper(client: _dio));
    _dio.interceptors.add(
      QueuedInterceptorsWrapper(
        onRequest: (options, handler) async {
          if (await SuperTokens.doesSessionExist()) {
            token = await SuperTokens.getAccessToken();
          } else {
            bool refreshed = await SuperTokens.attemptRefreshingSession();
            if (refreshed) {
              token = await SuperTokens.getAccessToken();
            }
          }
          options.headers['Authorization'] = 'Bearer $token';
          handler.next(options);
        },
      ),
    );
  }

  @override
  Future<Map<String, dynamic>> getNotifications({
    bool getNewPosts = false,
  }) async {
    try {
      final response = await _dio.get(
        'api/notifications',
        queryParameters: {
          if (cursor != null && !getNewPosts) 'cursor': cursor,
        },
      );
      if (response.data['hasMore'] == false) loadedAll = true;
      if (!getNewPosts) cursor = response.data['next_cursor'];
      return response.data;
    } on DioError catch (e) {
      Logger.e('Ошибка при получении уведомлений $e');
      Logger.e(e.message);

      rethrow;
    }
  }
}
