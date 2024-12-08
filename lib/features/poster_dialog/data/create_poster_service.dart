import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:poster_stock/common/constants/languages.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';
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
      return response.data;
    } on DioError catch (e) {
      Logger.e('Ошибка при создании закладки $e');
      Logger.e(e.response?.headers);
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

      return response.data;
    } on DioError catch (e) {
      Logger.e('Ошибка при создании постера $e');
      Logger.e(e.response?.headers);
      rethrow;
    }
  }

  Future<void> editPoster(int id, String image, String description) async {
    token = await SuperTokens.getAccessToken();
    try {
      var response = await _dio.post(
        '/api/posters/$id',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: jsonEncode(
          {
            "description": description,
            "poster_image": '/${image.split('/').last}',
          },
        ),
      );

      return response.data;
    } on DioError catch (e) {
      Logger.e('Ошибка при редактировании постера $e');
      Logger.e(e.response?.headers);
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
      return response.data;
    } on DioError catch (e) {
      Logger.e('Ошибка при поиске медиа $e');
      Logger.e(e.response);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMediaPosters(
      String mediaType, int mediaId) async {
    token = await SuperTokens.getAccessToken();
    try {
      var response = await _dio.get(
        'api/media/$mediaType/$mediaId',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
      response.data.forEach((key, value) {
        print('Ключ first: $key, =====  $value');
      });
      List<dynamic> postersList = response.data['posters'];
      postersList.forEach((value) {
        print('Постер: $value');
      });
      Logger.i('getMediaPosters >>> $postersList');
      return {'posters': postersList};
    } on DioError catch (e) {
      Logger.e('Ошибка при получении постеров $e');
      Logger.e(e.response);
      rethrow;
    }
  }
}
