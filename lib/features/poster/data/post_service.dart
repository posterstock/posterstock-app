import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:poster_stock/common/data/dio_keeper.dart';
import 'package:poster_stock/features/home/models/multiple_post_model.dart';
import 'package:http/http.dart' as http;

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

      return response.data;
    } on DioError catch (e) {
      Logger.e('Ошибка при отправке комментария $e');
      Logger.e(e.response?.headers);
      rethrow;
    }
  }

  Future<void> deleteComment(int postId, int id) async {
    try {
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
      Logger.e('Ошибка при удалении комментария $e');
      Logger.e(e.response?.headers);
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
      return response.data;
    } on DioError catch (e) {
      Logger.e('Ошибка при отправке комментария $e');
      Logger.e(e.response?.headers);
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
      return response.data['has_in_collection'];
    } on DioError catch (e) {
      Logger.e('Ошибка при проверке коллекции $e');
      Logger.e(e.response?.headers);
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

      return response.data;
    } on DioError catch (e) {
      Logger.e('Ошибка при получении комментариев $e');
      Logger.e(e.response?.headers);
      rethrow;
    }
  }

  Future<void> setBookmarked(int id, bool bookmarked) async {
    try {
      // final token = await SuperTokens.getAccessToken();
      final path = bookmarked
          ? '/api/posters/$id/bookmark'
          : '/api/posters/$id/unbookmark';
      await _dio.post(
        path,
        options: Options(
          contentType: 'application/json',
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json'
          },
        ),
      );
      if (bookmarked) {
        await _dio.post(
          '/api/posters/$id/bookmark',
          options: Options(
            contentType: 'application/json',
            headers: {
              'accept': 'application/json',
              'Content-Type': 'application/json'
            },
          ),
        );
      } else {
        await _dio.post(
          '/api/posters/$id/unbookmark',
          options: Options(
            contentType: 'application/json',
            headers: {
              'accept': 'application/json',
              'Content-Type': 'application/json'
            },
          ),
        );
      }
    } on DioError catch (e) {
      Logger.e('Ошибка при отправке комментария $e');
      Logger.e(e.response?.headers);
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
      Logger.i('getPost $response');
      return response.data;
    } on DioError catch (e) {
      Logger.e('Ошибка при получении постера $e');
      Logger.e(e.response?.headers);

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
      return response.data;
    } on DioError catch (e) {
      Logger.e('Ошибка при удалении постера $e');
      Logger.e(e.response?.headers);
      rethrow;
    }
  }

  Future<void> addPosterToList(MultiplePostModel listId, int postId) async {
    try {
      var idPosters = listId.posters.map((e) => e.id).toList()..add(postId);
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
      return response.data;
    } on DioError catch (e) {
      Logger.e('Ошибка при добавлении постера в список $e');
      Logger.e(e.response?.headers);
      rethrow;
    }
  }

  Future nftSell(String id) async {
    Logger.i('id >>>>>>>>> $id');
    try {
      final response = await _dio.post(
        'api/posters/onchain/sell',
        options: Options(
          contentType: 'application/json',
          headers: {
            'accept': 'application/json',
            'Content-Type': 'application/json'
          },
        ),
        data: jsonEncode({
          'tx_id': id,
          'lang': 'en-US',
        }),
      );
      Logger.i('nftSell ${response.data}');
    } on DioError catch (e) {
      Logger.e('Ошибка при отправке транзакции для нфт $e');
      Logger.e(
          'Тело ответа: ${e.response?.data}'); // Добавляем логирование тела ответа
      Logger.e('Статус ответа: ${e.response?.statusCode}');
      Logger.e(e.response?.headers);
      rethrow;
    }
  }

  /// получение nft по адресу
  Future<List<Map<String, dynamic>>> getNFT(String address) async {
    try {
      // Формирование URL для запроса
      final url = Uri.parse(
          'https://testnet.tonapi.io/v2/nfts/collections/$address/items');
      // Отправка HTTP GET запроса
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['nft_items'] != null) {
          return List<Map<String, dynamic>>.from(data['nft_items']);
        }
      } else {
        throw Exception(
            'Failed to load address information: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching address information: $e');
      return [];
    }
    return [];
  }
}
