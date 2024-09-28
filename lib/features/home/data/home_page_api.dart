import 'package:dio/dio.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:poster_stock/features/home/data/i_home_page_api.dart';
import 'package:supertokens_flutter/dio.dart';
import 'package:supertokens_flutter/supertokens.dart';

class HomePageApi implements IHomePageApi {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.posterstock.com/',
      connectTimeout: 10000,
      receiveTimeout: 10000,
    ),
  );

  String? postsCursor;
  String? token;
  bool loadedAll = false;

  HomePageApi() {
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
  Future<(Map<String, dynamic>?, bool)?> getPosts(
      {bool getNewPosts = false}) async {
    if (loadedAll && !getNewPosts) return null;
    try {
      final response = await _dio.get('api/feed/',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          queryParameters: {
            'cursor': getNewPosts ? null : postsCursor,
          });
      Logger.i('getPosts  ${response.data}');
      if (!getNewPosts && !(response.data['has_more'] as bool)) {
        loadedAll = true;
      } else if (!getNewPosts) {
        loadedAll = false;
      }
      if (!getNewPosts) postsCursor = response.data['next_cursor'] as String?;
      return (response.data as Map<String, dynamic>?, loadedAll);
    } on DioError catch (e) {
      Logger.e('Ошибка при получении постов $e');
      rethrow;
    }
  }

  @override
  Future<void> setLike(int id, bool like) async {
    try {
      if (like) {
        await _dio.post(
          'api/posters/$id/like',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );
      } else {
        await _dio.post(
          'api/posters/$id/unlike',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );
      }
    } on DioError catch (e) {
      Logger.e('Ошибка при постановке лайка $e');
      rethrow;
    }
  }

  @override
  Future<void> setLikeList(int id, bool like) async {
    try {
      if (like) {
        await _dio.post(
          'api/lists/$id/like',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );
      } else {
        await _dio.post(
          'api/lists/$id/unlike',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );
      }
    } on DioError catch (e) {
      Logger.e('Ошибка при постановке лайка $e');
      rethrow;
    }
  }
}
