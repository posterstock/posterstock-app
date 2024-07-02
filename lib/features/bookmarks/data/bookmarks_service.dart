import 'package:dio/dio.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:supertokens_flutter/dio.dart';
import 'package:supertokens_flutter/supertokens.dart';

class BookmarksService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.posterstock.com/',
      connectTimeout: 10000,
      receiveTimeout: 10000,
    ),
  );

  String? token;
  String? cursor;

  BookmarksService() {
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

  Future<(List<dynamic>, bool)> getBookmarks(int id,
      {bool restart = false}) async {
    if (restart) cursor = null;
    try {
      var response = await _dio.get(
        'api/bookmarks/$id',
        queryParameters: {
          'cursor': cursor,
        },
      );
      cursor = response.data['next_cursor'];
      return (
        response.data['entries'] as List<dynamic>? ?? [],
        !response.data['has_more'],
      );
    } catch (e) {
      Logger.e('Ошибка при получении закладок $e');
    }
    return ([], false);
  }
}
