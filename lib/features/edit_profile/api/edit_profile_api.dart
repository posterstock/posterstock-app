import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter/services.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:image/image.dart';
import 'package:supertokens_flutter/dio.dart';
import 'package:supertokens_flutter/supertokens.dart';

class EditProfileApi {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.posterstock.com/',
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

  Future<void> deleteAccount() async {
    try {
      await _dio.delete(
        '/api/profiles/irreversible',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioError catch (e) {
      Logger.e('Ошибка при удалении аккаунта $e');
      Logger.e(e.message);
      rethrow;
    }
  }

  Future<void> blockAccount({required int id}) async {
    try {
      await _dio.post(
        '/api/users/$id/block',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioError catch (e) {
      Logger.e('Ошибка при блокировке аккаунта $e');
      Logger.e(e.message);
      rethrow;
    }
  }

  Future<void> unblockAccount({required int id}) async {
    try {
      await _dio.post(
        '/api/users/$id/unblock',
        options: Options(
          headers: {'Authorization': 'Bearer $token'},
        ),
      );
    } on DioError catch (e) {
      Logger.e('Ошибка при разблокировке аккаунта $e');
      Logger.e(e.message);
      rethrow;
    }
  }

  Future<void> save({
    required String name,
    required String username,
    String? description,
    Uint8List? avatar,
  }) async {
    try {
      try {
        // ignore: unused_local_variable
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
      } catch (e) {
        Logger.e('Ошибка при изменении профиля $e');
      }
      try {
        // ignore: unused_local_variable
        var r1 = await _dio.post(
          'api/profiles/username',
          options: Options(
            headers: {'Authorization': 'Bearer $token'},
          ),
          data: jsonEncode({
            "username": username,
          }),
        );
      } on DioError catch (e) {
        Logger.e('Ошибка при изменении профиля $e');
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

      var pnImage = encodePng(im);
      FormData formData = FormData.fromMap({
        "image": MultipartFile.fromBytes(pnImage),
      });
      await _dio.post(
        'api/profiles/image',
        options: Options(
          headers: {'content-type': 'multipart/form-data'},
        ),
        data: formData,
      );
    } on DioError catch (e) {
      Logger.e('Ошибка при изменении аватара $e');

      rethrow;
    }
  }
}
