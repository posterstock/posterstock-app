import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:poster_stock/common/data/exceptions.dart';
import 'package:poster_stock/common/widgets/app_snack_bar.dart';
import 'package:poster_stock/features/auth/data/handlers/auth_handler.dart';
import 'package:poster_stock/main.dart';
import 'package:supertokens_flutter/dio.dart';
import 'package:supertokens_flutter/supertokens.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.posterstock.co/',
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
      print("SUCCESS");
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      print(e.response?.data);
      print(e.response?.headers);
    }
  }

  Future<void> removeFCMToken(String token, String userToken) async {
    print(token);
    print(userToken);
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
      print("HHEHEHEHEHHEHE");
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      print(e.response?.headers);
      print(e.response?.data);
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
          "clientType": Platform.isIOS ? "ios" : "android",
          "code": code ?? '',
          "state": state ?? '',
          "redirectURI": "https://api.posterstock.co/auth/callback/apple",
          "callback_apple_body": {
            "code": code ?? '',
            "state": state ?? '',
          },
        }),
      );
      return response.data;
    } on DioError catch (e) {
      print(e.response?.headers);
      rethrow;
    }
  }

  Future<void> authGoogle({
    String? accessToken,
    String? idToken,
    String? code,
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
          "redirectURI": "https://api.posterstock.co/auth/callback/google",
          "clientId":
              '405674784124-v0infd39p5s4skn9s89cg57a6i00ferr.apps.googleusercontent.com',
          'code': code,
          "authCodeResponse": {
            "access_token": accessToken,
            "id_token": idToken,
          },
        }),
      );
      return response.data;
    } on DioError catch (e) {
      print(e);
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
      print(response.data);
      return response.data['exists'];
    } on DioError catch (e) {
      print(e.response);
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
      print(response.data);
      if (AuthHandler.handleResponse(response.data)) {
        return await SuperTokens.getAccessToken();
      }
      throw AuthException();
    } on DioError catch (e) {
      print(e);
      rethrow;
    }
  }
}
