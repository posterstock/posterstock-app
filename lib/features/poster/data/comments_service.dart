import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:poster_stock/common/data/dio_keeper.dart';
import 'package:poster_stock/features/home/models/list_base_model.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:poster_stock/features/home/models/post_movie_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supertokens_flutter/supertokens.dart';

class PostService {
  final Dio _dio = DioKeeper.getDio();

  Future<Map<String, dynamic>> postComment(int id, String text) async {
    try {
      final response = await _dio.post('api/posters/$id/comment',
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

  Future<void> deleteComment(int postId, int id) async {
    try {
      print('/api/posters/$postId/comments/$id');
      await _dio.delete(
        '/api/posters/$postId/comments/$id',
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

  Future<Map<String, dynamic>> postCommentList(int id, String text) async {
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
      print(response.data);
      return response.data;
    } on DioError catch (e) {
      print(e.response?.headers);
      rethrow;
    }
  }

  Future<bool> getInCollection(int id) async {
    try {
      final response = await _dio.get(
        'api/posters/collection/$id/',
        options: Options(
          contentType: 'application/json',
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json'
          },
        ),
      );
      print(response.data);
      return response.data['has_in_collection'];
    } on DioError catch (e) {
      print(e.response?.headers);
      rethrow;
    }
  }

  Future<List> getComments(int id) async {
    try {
      final response = await _dio.get(
        'api/posters/$id/comments/private/',
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

  Future<void> setBookmarked(int id, bool bookmarked) async {
    try {
      // final token = await SuperTokens.getAccessToken();
      // print('token: $token');
      // print('setBookmarked: $id $bookmarked');
      final path = bookmarked
          ? '/api/posters/$id/bookmark'
          : '/api/posters/$id/unbookmark';
      Response response = await _dio.post(
        path,
        options: Options(
          contentType: 'application/json',
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json'
          },
        ),
      );
      // if (bookmarked) {
      //   response = await _dio.post(
      //     '/api/posters/$id/bookmark',
      //     options: Options(
      //       contentType: 'application/json',
      //       headers: {
      //         'accept': 'application/json',
      //         'Content-Type': 'application/json'
      //       },
      //     ),
      //   );
      // } else {
      //   response = await _dio.post(
      //     '/api/posters/$id/unbookmark',
      //     options: Options(
      //       contentType: 'application/json',
      //       headers: {
      //         'accept': 'application/json',
      //         'Content-Type': 'application/json'
      //       },
      //     ),
      //   );
      // }
      print('request success');
    } on DioError catch (e) {
      print(e);
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
      print('$id ${response.data}');
      return response.data;
    } on DioError catch (e) {
      print(18);
      print(e.response);
      rethrow;
    }
  }

  Future<void> deletePost(int id) async {
    try {
      final response = await _dio.delete(
        'api/posters/$id',
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
      print(e.response?.data);
      print(e.response?.headers);
      rethrow;
    }
  }

  Future<void> addPosterToList(MultiplePostModel listId, int postId) async {
    try {
      var idPosters = listId.posters.map((e) => e.id).toList()..add(postId);
      print(idPosters);
      final response = await _dio.post(
        'api/lists/${listId.id}',
        options: Options(
          contentType: 'application/json',
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json'
          },
        ),
        data: jsonEncode({
          'title': listId.name,
          'posters': idPosters,
          'description': listId.description,
        }),
      );
      print(response.data);
      return response.data;
    } on DioError catch (_) {
      print(_.response?.headers);
      print(_.response?.data);
      rethrow;
    }
  }
}
