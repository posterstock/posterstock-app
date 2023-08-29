import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:image/image.dart';
import 'package:supertokens_flutter/dio.dart';
import 'package:supertokens_flutter/supertokens.dart';

class EditProfileApi {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.posterstock.co/',
      connectTimeout: 10000,
      receiveTimeout: 10000,
    ),
  );
  String? token;

  EditProfileApi() {
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

  Future<void> save({
    required String name,
    required String username,
    String? description,
    Uint8List? avatar,
  }) async {
    print("$name $username $description");
    try {
      var response = await _dio.post(
        'api/profiles/',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: jsonEncode({
          if (description != null)
          "description": description,
          "name": name,
          "username": username,
        }),
      );
      if (avatar == null) return;
      Image? img = decodeImage(avatar);

      var pnImage = encodePng(img!);
      FormData formData = FormData.fromMap({
        "image":
        MultipartFile.fromBytes(pnImage),
      });
      var responseImage = await _dio.post(
        'api/profiles/image/',
        options: Options(
          headers: {'content-type': 'multipart/form-data'},
        ),
        data: formData,
      );
      print(response);
      print(responseImage);
    } on DioError catch (e) {
      print(e.response);
      rethrow;
    }
  }
}
