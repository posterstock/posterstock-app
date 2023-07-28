import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:poster_stock/features/auth/data/handlers/auth_handler.dart';
import 'package:supertokens_flutter/dio.dart';
import 'package:supertokens_flutter/supertokens.dart';

class AuthService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://posterstock.co/',
      connectTimeout: 10000,
      receiveTimeout: 10000,
    ),
  );

  AuthService() {
    _dio.interceptors.add(SuperTokensInterceptorWrapper(client: _dio));
  }

  Future<int> getId(String token) async {
    print(12);
    try {
      final response = await _dio.post(
        'api/profiles',
        data: json.encode({}),
        options: Options(
          contentType: 'application/json',
          headers: {
            'Authorization': 'Bearer $token',
            'accept': 'application/json',
            'Content-Type': 'application/json'
          },
        ),
      );
      print(response.data);
      return response.data['id'];
    } on DioError catch (e) {
      print(e.response);
      rethrow;
    }
  }

  Future<(String, String)> sendEmail(String email) async {
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
      return (
        response.data['deviceId'] as String,
        response.data['preAuthSessionId'] as String
      );
    } catch (e) {
      rethrow;
    }
  }

  Future<String?> confirmCode({
    required String code,
    required String sessionId,
    required String deviceId,
    required String name,
    required String login,
    required String email,
  }) async {
    try {
      var response = await _dio.post(
        'auth/signinup/code/consume',
        data: json.encode({
          "preAuthSessionId": sessionId,
          "userInputCode": code,
          "deviceId": deviceId,
          "name": name,
          "login": login,
          "email": email,
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
    } catch (e) {
      rethrow;
    }
  }
}
