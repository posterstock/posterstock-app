import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:image/image.dart';
import 'package:supertokens_flutter/dio.dart';
import 'package:supertokens_flutter/supertokens.dart';

class CreateListService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.posterstock.co/',
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

  Future<bool?> createList({
    required String title,
    required String description,
    required List<int> posters,
    Uint8List? image,
  }) async {
    bool created = false;
    try {
      var response = await _dio.post(
        'api/lists/',
        data: jsonEncode({
          'description' : description,
          'posters' : posters,
          'title' : title,
        }),
      );
      created = true;
      if (image != null) {
        Image? img = decodeImage(image);
        Image? im = copyCrop(img!, x: 0, y: ((img?.height ?? 0) - (((img?.width ?? 0) ~/ 195) * 120)) ~/ 2, width: img?.width ?? 0, height: ((img?.width ?? 0) ~/ 195) * 120);

        var pnImage = encodePng(im);
        FormData formData = FormData.fromMap({
          "image":
           MultipartFile.fromBytes(pnImage),
        });
        print(base64Encode(image));
        var response1 = await _dio.post(
          'api/lists/${response.data['id']}/image/',
          options: Options(
            headers: {'content-type': 'multipart/form-data'},
          ),
          data: formData,
        );
        print(response1);
      }
      print(response);
    } on DioError catch (e) {
      if (!created) {
        return false;
      }
      print(e.response);
      print(e.message);
      print(e.response?.headers);
    }
  }
}
