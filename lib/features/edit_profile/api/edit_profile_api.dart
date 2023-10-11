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
        'api/profiles',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
        data: jsonEncode({
          if (description != null) "description": description,
          "name": name,
        }),
      );
      try {
        var r1 = await _dio.post(
          'api/profiles/username',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
          data: jsonEncode({
            "username": username,
          }),
        );
        print(r1.data);
      } catch (e) {
        print(e);
      }
      if (avatar == null) return;
      Image? img = decodeImage(avatar);
      Image? im = copyCrop(
        img!,
        x: 0,
        y: ((img.height - img.width) ~/ 2 < 0
            ? 0
            : (img.height - img.width) ~/ 2),
        width: img.width,
        height: img.width,
      );
      im = copyResize(im, width: 300);
      print(im.width);

      var pnImage = encodePng(im);
      FormData formData = FormData.fromMap({
        "image": MultipartFile.fromBytes(pnImage),
      });
      var responseImage = await _dio.post(
        'api/profiles/image',
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
