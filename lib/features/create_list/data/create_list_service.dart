import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:image/image.dart';
import 'package:supertokens_flutter/dio.dart';
import 'package:supertokens_flutter/supertokens.dart';

class CreateListService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.posterstock.com/',
      connectTimeout: 10000,
      receiveTimeout: 10000,
    ),
  );

  String? token;

  CreateListService() {
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

  String? searchValue;
  String? cursor;

  Future<bool?> createList({
    required String title,
    required String description,
    required List<int> posters,
    Uint8List? image,
    bool? generated = false,
    int? id,
    String? imagePath,
  }) async {
    bool created = false;
    int? thisId = id;
    Response response;
    try {
      response = await _dio.post(
        (id == null) ? 'api/lists' : 'api/lists/$id',
        data: jsonEncode({
          'description': description,
          'posters': posters,
          'title': title,
        }),
      );
      if (id == null) {
        thisId = response.data['id'];
      }
      created = true;
      Image? img;
      if (imagePath != null && imagePath.contains('http')) {
        return null;
      }
      if (imagePath == null) {
        img = decodeImage(image!);
      } else {
        img = decodeImage(File(imagePath).readAsBytesSync());
      }
      Image? im = copyCrop(img!,
          x: 0,
          y: (img.height - ((img.width ~/ 195) * 120)) ~/ 2,
          width: img.width,
          height: (img.width ~/ 195) * 120);
      im = copyResize(im, width: 540);
      var pnImage = encodePng(im);
      FormData formData = FormData.fromMap({
        "image": MultipartFile.fromBytes(pnImage,
            filename:
                generated == true ? 'generated${pnImage.hashCode}' : null),
      });

      await _dio.post(
        'api/lists/$thisId/image',
        options: Options(
          headers: {'content-type': 'multipart/form-data'},
        ),
        data: formData,
      );
    } on DioError catch (e) {
      RequestOptions req = e.requestOptions;
      Logger.e(
          'Ошибка при создании списка $e \n${req.data} \n${e.error}  \n${req.uri}');
      if (!created) {
        return false;
      }
    }
    return null;
  }

  Future<(List<dynamic>?, bool)> searchPosts(String value, int userId) async {
    if (searchValue != value) {
      searchValue = value;
      cursor = null;
    }
    try {
      final response = await _dio.get('api/posters/search/', queryParameters: {
        'query': searchValue,
        'cursor': cursor,
        'user_id': userId,
      });
      cursor = response.data['next_cursor'];
      return (
        response.data['posters'] as List<dynamic>? ?? [],
        !response.data['has_more']
      );
    } on DioError catch (e) {
      Logger.e('Ошибка при поиске постеров $e');
      return ([], false);
    }
  }
}
