import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:poster_stock/common/data/dio_keeper.dart';
import 'package:poster_stock/features/list/view/list_page.dart';

class ListService {
  final Dio _dio = DioKeeper.getDio();

  Future<Map<String, dynamic>> postComment(int id, String text) async {
    try {
      final response = await _dio.post('api/lists/$id/comment',
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
        'api/lists/$id/comments/private',
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

  Future<Map<String, dynamic>> getSpecialList(int userId, ListType type) async {
    final String endpoint;
    switch (type) {
      case ListType.favorited:
        endpoint = 'api/users/$userId/lists/favourites';
        break;
      case ListType.recomends:
        endpoint = 'api/users/$userId/lists/recommends';
        break;
    }
    final response = await _dio.get(
      endpoint,
      options: Options(
        contentType: 'application/json',
        headers: {
          'accept': 'application/json',
          'Content-Type': 'application/json'
        },
      ),
    );
    return response.data;
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

  Future<void> deleteList(int id) async {
    try {
      final response = await _dio.delete(
        'api/lists/$id',
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

  Future<void> changeDefaultLang(String lang) async {
    try {
      final response = await _dio.post('api/lists/default',
          options: Options(
            contentType: 'application/json',
            headers: {
              'accept': 'application/json',
              'Content-Type': 'application/json'
            },
          ),
          queryParameters: {'lang': lang});
      print('$lang ${response.data}');
      return response.data;
    } on DioError catch (e) {
      print(e.response);
      rethrow;
    }
  }
}
