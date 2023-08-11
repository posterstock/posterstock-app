import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:poster_stock/common/data/dio_keeper.dart';
class PostService {
  final Dio _dio = DioKeeper.getDio();

  Future<Map<String, dynamic>> postComment(int id, String text) async {
    try {
      final response = await _dio.post('api/posters/$id/comment/',
          options: Options(
            contentType: 'application/json',
            headers: {
              'accept': 'application/json',
              'Content-Type': 'application/json'
            },
          ),
          data: jsonEncode({'text': text}));
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      print(e.response?.headers);
      rethrow;
    }
  }

  Future<List> getComments(int id) async {
    try {
      final response = await _dio.get(
        'api/posters/$id/comments',
        options: Options(
          contentType: 'application/json',
          headers: {
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

  Future<Map<String, dynamic>> getPost(int id) async {
    try {
      final response = await _dio.get(
        'api/posters/$id/',
        options: Options(
          contentType: 'application/json',
          headers: {
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
