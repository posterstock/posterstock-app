import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:poster_stock/common/data/exceptions.dart';
import 'package:poster_stock/features/auth/data/handlers/auth_handler.dart';
import 'package:supertokens_flutter/dio.dart';
import 'package:supertokens_flutter/supertokens.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.posterstock.com/',
      connectTimeout: 10000,
      receiveTimeout: 10000,
    ),
  );

  AuthService() {
    _dio.interceptors.add(SuperTokensInterceptorWrapper(client: _dio));
  }

  Future<void> registerNotification(String token, String userToken) async {
    try {
      final response = await _dio.post(
        'api/notifications/register/$token',
        options: Options(
          contentType: 'text/plain; charset=utf-8',
          headers: {
            'rid': 'thirdpartypasswordless',
            'Authorization': 'Bearer $userToken',
          },
        ),
      );
      return response.data;
    } on DioError catch (e) {
      Logger.e('Ошибка при регистрации FCM $e');
      Logger.e(e.response?.data);
    }
  }

  Future<void> removeFCMToken(String token, String userToken) async {
    try {
      final response = await _dio.delete(
        'api/notifications/drop/$token',
        options: Options(
          contentType: 'text/plain; charset=utf-8',
          headers: {
            'rid': 'thirdpartypasswordless',
            'Authorization': 'Bearer $userToken',
          },
        ),
      );

      return response.data;
    } on DioError catch (e) {
      Logger.e('Ошибка при удалении FCM $e');
      Logger.e(e.response?.headers);
      Logger.e(e.response?.data);
      rethrow;
    }
  }

  Future<void> authApple({
    String? name,
    String? surname,
    String? email,
    String? code,
    String? clientID,
    String? state,
  }) async {
    try {
      final response = await _dio.post(
        'auth/signinup',
        options: Options(
          contentType: 'text/plain; charset=utf-8',
          headers: {'rid': 'thirdpartypasswordless'},
        ),
        data: jsonEncode({
          "thirdPartyId": "apple",
          //"clientType": Platform.isIOS ? "IOS" : "android",
          "code": code ?? '',
          "state": state ?? '',
          //"redirectURI": "https://api.posterstock.com/auth/callback/apple",
          /*"oAuthTokens": {
            "access_token": code,
            "id_token": clientID,
          },*/
          "redirectURIInfo": {
            "redirectURIOnProviderDashboard":
                "https://api.posterstock.com/auth/callback/apple",
            "redirectURIQueryParams": {
              "code": code,
              "user": {
                "name": {"firstName": name, "lastName": surname},
                "email": email,
              }
            }
          }
        }),
      );
      return response.data;
    } on DioError catch (e) {
      Logger.e('Ошибка при регистрации Apple $e');
      Logger.e(e.response?.data);
      Logger.e(e.response?.headers);
      rethrow;
    }
  }

  Future<void> authGoogle({
    String? accessToken,
    String? idToken,
    String? code,
    String? clientId,
    String? name,
    String? surname,
    String? email,
  }) async {
    try {
      final response = await _dio.post(
        'auth/signinup',
        options: Options(
          contentType: 'text/plain; charset=utf-8',
          headers: {'rid': 'thirdpartypasswordless'},
        ),
        data: jsonEncode({
          "thirdPartyId": "google",
          "clientType": Platform.isIOS ? "ios" : "android",
          "redirectURI": "https://api.posterstock.com/auth/callback/google",
          "clientId": clientId,
          'code': code,
          "oAuthTokens": {
            "access_token": accessToken,
            "id_token": idToken,
          },
        }),
      );

      return response.data;
    } on DioError catch (e) {
      Logger.e('Ошибка при регистрации Google $e');
      Logger.e(e.response?.data);
      Logger.e(e.response?.headers);
      rethrow;
    }
  }

  Future<bool> getRegistered(String email) async {
    try {
      final response = await _dio.get('auth/signup/email/exists',
          options: Options(
            contentType: 'application/json',
            headers: {
              'accept': 'application/json',
              'Content-Type': 'application/json',
              'rid': 'thirdpartypasswordless'
            },
          ),
          queryParameters: {'email': email});
      return response.data['exists'];
    } on DioError catch (e) {
      Logger.e('Ошибка при получении регистрации $e');
      rethrow;
    }
  }

  Future<(String, String)> signUpSendEmail(String email) async {
    try {
      final response = await _dio.post(
        'auth/signinup/code',
        data: json.encode({"email": email}),
        options: Options(
          contentType: 'application/json',
          headers: {
            'accept': 'application/json',
            'rid': 'thirdpartypasswordless',
            'Content-Type': 'application/json'
          },
        ),
      );
      if (response.data['status'] == 'GENERAL_ERROR') {
        throw AlreadyHasAccountException(
          response.data['message'],
        );
      }
      return (
        response.data['deviceId'] as String? ?? '',
        response.data['preAuthSessionId'] as String? ?? '',
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> confirmCode({
    required String code,
    required String sessionId,
    required String deviceId,
    String? name,
    String? login,
    required String email,
  }) async {
    try {
      var response = await _dio.post(
        'auth/signinup/code/consume',
        data: json.encode({
          "preAuthSessionId": sessionId,
          "userInputCode": code,
          "deviceId": deviceId,
          "email": email,
          if (name != null) "name": name,
          if (login != null) "login": login,
        }),
        options: Options(
          contentType: 'application/json',
          headers: {
            'accept': 'application/json',
            'rid': 'thirdpartypasswordless',
            'Content-Type': 'application/json'
          },
        ),
      );
      if (AuthHandler.handleResponse(response.data)) {
        return await SuperTokens.getAccessToken();
      }
      throw AuthException();
    } on DioError catch (e) {
      Logger.e('Ошибка при подтверждении кода $e');
      rethrow;
    }
  }
}
