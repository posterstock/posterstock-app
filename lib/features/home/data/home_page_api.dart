import 'dart:convert';
import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:logger/logger.dart';
import 'package:poster_stock/features/home/data/i_home_page_api.dart';
import 'package:supertokens_flutter/dio.dart';

class HomePageApi implements IHomePageApi {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://posterstock.co/',
      connectTimeout: 10000,
      receiveTimeout: 10000,
    ),
  );

  String? postsCursor;
  bool loadedAll = false;

  HomePageApi() {
    _dio.interceptors.add(SuperTokensInterceptorWrapper(client: _dio));
  }

  @override
  Future<(Map<String, dynamic>?, bool)?> getPosts(String token,
      {bool getNewPosts = false}) async {
    if (loadedAll && !getNewPosts) return null;
    try {
      final response = await _dio.get('api/feed',
          options: Options(headers: {'Authorization': 'Bearer $token'}),
          queryParameters: {
            'cursor': getNewPosts ? null : postsCursor,
          });
      if (!getNewPosts && (response.data['has_more'] as bool)) {
        loadedAll = true;
      } else if (!getNewPosts) {
        loadedAll = false;
      }
      if (!getNewPosts) postsCursor = response.data['next_cursor'] as String?;
      print(response);
      return (response.data as Map<String, dynamic>?, loadedAll);
    } on DioError catch (e) {
      print(e.response);
      rethrow;
    }
  }

  @override
  Future<void> setLike(String token, int id, bool like) async {
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
}
