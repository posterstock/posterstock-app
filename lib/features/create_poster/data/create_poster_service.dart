import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
import 'package:poster_stock/common/constants/languages.dart';
import 'package:supertokens_flutter/dio.dart';
import 'package:supertokens_flutter/supertokens.dart';

class CreatePosterService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.posterstock.com/',
      connectTimeout: 10000,
      receiveTimeout: 10000,
    ),
  )..interceptors.add(PrettyDioLogger(
      requestBody: true,
      responseBody: true,
      compact: true,
    ));
  String? token;

  CreatePosterService() {
    _dio.interceptors.add(SuperTokensInterceptorWrapper(client: _dio));
  }

  Future<void> createBookmark(
      int mediaId, String mediaType, String image, Languages lang) async {
    token = await SuperTokens.getAccessToken();
    try {
      var response = await _dio.post(
        '/api/bookmarks',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: jsonEncode(
          {
            "media_id": mediaId,
            "media_type": mediaType,
            "poster_image": '/${image.split('/').last}',
            "lang": lang.locale.toLanguageTag(),
          },
        ),
      );
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      print(e.response?.headers);
      rethrow;
    }
  }

  Future<void> createPoster(int mediaId, String mediaType, String image,
      String description, Languages lang) async {
    token = await SuperTokens.getAccessToken();
    try {
      var response = await _dio.post(
        '/api/posters',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: jsonEncode(
          {
            "description": description,
            "media_id": mediaId,
            "media_type": mediaType,
            "poster_image": '/${image.split('/').last}',
            "lang": lang.locale.toLanguageTag(),
          },
        ),
      );
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      print(e.response?.headers);
      rethrow;
    }
  }

  Future<List<dynamic>> getSearchMedia(
      String searchValue, Languages language) async {
    if (searchValue.isEmpty) return [];
    token = await SuperTokens.getAccessToken();
    try {
      var response = await _dio.get('api/media/search',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
          queryParameters: {
            'query': searchValue,
            'lang': language.locale.toLanguageTag(),
          });
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      print(e.response);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMediaPosters(
      String mediaType, int mediaId) async {
    print(mediaType);
    print(mediaId);
    token = await SuperTokens.getAccessToken();
    try {
      var response = await _dio.get(
        'api/media/$mediaType/$mediaId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      print(e.response);
      rethrow;
    }
  }
}
