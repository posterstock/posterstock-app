import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:poster_stock/features/home/data/i_home_page_api.dart';
import 'package:supertokens_flutter/dio.dart';
import 'package:supertokens_flutter/supertokens.dart';

class HomePageApi implements IHomePageApi {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.posterstock.co/',
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
    print(122324);
    print(getNewPosts);
    if (loadedAll && !getNewPosts) return null;
    try {
      print(token);
      final response = await _dio.get('api/feed/',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          queryParameters: {
            'cursor': getNewPosts ? null : postsCursor,
          });
      print(2123213);
      if (!getNewPosts && !(response.data['has_more'] as bool)) {
        loadedAll = true;
      } else if (!getNewPosts) {
        loadedAll = false;
      }
      if (!getNewPosts) postsCursor = response.data['next_cursor'] as String?;
      print(response.data['entries'].forEach(
          (value) => value.forEach((key, value) => print('$key:$value'))));
      print(response.data['entries']
          .forEach((el) => print('SS${el['is_suggested']}')));
      return (response.data as Map<String, dynamic>?, loadedAll);
    } on DioError catch (e) {
      print(122314);
      print(e.response);
      print(e.response?.headers);
      rethrow;
    }
  }

  @override
  Future<void> setLike(int id, bool like) async {
    try {
      if (like) {
        var response = await _dio.post(
          'api/posters/$id/like/',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );
        print(response);
      } else {
        var response = await _dio.post(
          'api/posters/$id/unlike/',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );
        print(response);
      }
    } on DioError catch (e) {
      print(e.response);
      rethrow;
    }
  }

  @override
  Future<void> setLikeList(int id, bool like) async {
    try {
      if (like) {
        var response = await _dio.post(
          'api/lists/$id/like/',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );
        print(response);
      } else {
        var response = await _dio.post(
          'api/lists/$id/unlike/',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
        );
        print(response);
      }
    } on DioError catch (e) {
      print(e.response);
      rethrow;
    }
  }
}
