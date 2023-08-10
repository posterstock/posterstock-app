import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:supertokens_flutter/dio.dart';
import 'package:supertokens_flutter/supertokens.dart';

class PostService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.posterstock.co/',
      connectTimeout: 10000,
      receiveTimeout: 10000,
    ),
  );

  CommentsService() {
    _dio.interceptors.add(SuperTokensInterceptorWrapper(client: _dio));
  }

  Future<Map<String, dynamic>> postComment(String token, int id, String text) async {
    try {
      final response = await _dio.post(
        'api/posters/$id/comment/',
        options: Options(
          contentType: 'application/json',
          headers: {
            'Authorization': 'Bearer $token',
            'accept': 'application/json',
            'Content-Type': 'application/json'
          },
        ),
        data: jsonEncode({'text' : text})
      );
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      print(e.response?.headers);
      rethrow;
    }
  }

  Future<List> getComments(String token, int id) async {
    try {
      final response = await _dio.get(
        'api/posters/$id/comments',
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
      return response.data;
    } on DioError catch (e) {
      print(e.response);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getPost(String token, int id) async {
    try {
      final response = await _dio.get(
        'api/posters/$id/',
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
      return response.data;
    } on DioError catch (e) {
      print(18);
      print(e.response);
      rethrow;
    }
  }
}