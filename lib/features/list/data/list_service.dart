import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:poster_stock/common/data/dio_keeper.dart';

class ListService {
  final Dio _dio = DioKeeper.getDio();

  Future<Map<String, dynamic>> postComment(int id, String text) async {
    try {
      final response = await _dio.post('api/lists/$id/comment/',
          options: Options(
            contentType: 'application/json',
            headers: {
              'accept': 'application/json',
              'Content-Type': 'application/json'
            },
          ),
          data: jsonEncode({'text': text}));
      return response.data;
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<void> deleteComment(int postId, int id) async {
    try {
      await _dio.delete(
        'api/lists/$postId/comments/$id',
        options: Options(
          contentType: 'application/json',
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json'
          },
        ),
      );
    } on DioError catch (e) {
      print(e.response?.headers);
      rethrow;
    }
  }

  Future<List> getComments(int id) async {
    try {
      final response = await _dio.get(
        'api/lists/$id/comments',
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
        'api/lists/$id/',
        options: Options(
          contentType: 'application/json',
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json'
          },
        ),
      );
      (response.data as Map<String, dynamic>).forEach(
        (key, value) {
          print('$key : $value');
        },
      );
      return response.data;
    } on DioError catch (e) {
      rethrow;
    }
  }

  Future<Map<String, dynamic>> deleteList(int id) async {
    try {
      final response = await _dio.delete(
        'api/lists/$id/',
        options: Options(
          contentType: 'application/json',
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json'
          },
        ),
      );
      print('$id ${response.data}');
      return response.data;
    } on DioError catch (e) {
      print(18);
      print(e.response);
      rethrow;
    }
  }
}
