import 'package:dio/dio.dart';
import 'package:flutter_easylogger/flutter_logger.dart';
import 'package:poster_stock/common/data/dio_keeper.dart';

class ProfileService {
  final Dio _dio = DioKeeper.getDio();

  String? bookmarksCursor;
  String? postsCursor;
  int? id;

  Future<(List<Map<String, dynamic>>?, bool)> getUserPosts(int? id,
      {bool restart = false}) async {
    if (id != this.id) postsCursor = null;
    if (restart) postsCursor = null;
    this.id = id;
    final response = await _dio.get('api/posters/users/$id',
        options: Options(headers: {}),
        queryParameters: {
          'cursor': postsCursor,
        });
    final List<Map<String, dynamic>> result = [];
    postsCursor = response.data['next_cursor'];
    for (var a in response.data['posters'] ?? []) {
      result.add(a);
    }
    return (result, !response.data['has_more']);
  }

  Future<List<Map<String, dynamic>>?> getUserLists(int? id) async {
    try {
      final response = await _dio.get(
        'api/lists/users/$id/',
        options: Options(headers: {}),
      );
      final List<Map<String, dynamic>> result = [];
      for (var a in response.data) {
        result.add(a);
      }
      return result;
    } on DioError catch (e) {
      Logger.e('Ошибка при получении списков $e');
    }
    return null;
  }

  Future<(List<dynamic>?, bool)> getMyBookmarks({bool restart = false}) async {
    if (restart) {
      bookmarksCursor = null;
    }
    final response = await _dio.get('api/bookmarks/my', queryParameters: {
      'cursor': bookmarksCursor,
    });
    bookmarksCursor = response.data['next_cursor'];
    return (
      response.data['entries'] as List<dynamic>?,
      !response.data['has_more']
    );
  }

  Future<Map<String, dynamic>> getProfileInfoByName(String name) async {
    try {
      final response = await _dio.get('/api/users/u/$name');

      return response.data;
    } on DioError catch (e) {
      Logger.e('Ошибка при получении пользователя по имени $e');
      Logger.e(e.response?.headers);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getProfileInfo(dynamic id) async {
    try {
      if (id == null) {
        try {
          final response = await _dio.get('api/profiles/');
          return response.data;
        } on DioError catch (e) {
          Logger.e('Ошибка при получении профиля $e');
        } catch (e) {
          rethrow;
        }
        return {};
      }
      Response response;
      if (id is String) {
        response = await _dio.get(
          'api/users/u/$id/',
          options: Options(headers: {}),
        );
      } else {
        response = await _dio.get(
          'api/users/$id/',
          options: Options(headers: {}),
        );
      }
      return response.data;
    } on DioError catch (e) {
      Logger.e('Ошибка при получении пользователя $e');
      Logger.e(e.response?.headers);
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getMyProfile() async {
    try {
      final response = await _dio.get('api/profiles/');
      return response.data;
    } on DioError catch (e) {
      Logger.e('Ошибка при получении пользователя $e');
      Logger.e(e.response?.headers);
      rethrow;
    } catch (e) {
      Logger.e('Ошибка при получении пользователя $e');
      rethrow;
    }
  }

  Future<bool?> getBlocked(int id) async {
    try {
      final response = await _dio.get(
        '/api/users/$id/blocked',
      );
      return response.data as bool;
    } on DioError catch (e) {
      Logger.e('Ошибка при получении блокировки $e');
    } catch (e) {
      Logger.e('Ошибка при получении блокировки $e');
      rethrow;
    }
    return null;
  }

  Future<void> follow(int? id, bool follow) async {
    try {
      if (follow) {
        try {
          final response = await _dio.post(
            '/api/users/$id/follow',
          );

          return response.data;
        } on DioError catch (e) {
          Logger.e('Ошибка при подписке $e');
        } catch (e) {
          rethrow;
        }
      }
      final response = await _dio.post(
        '/api/users/$id/unfollow',
      );
      return response.data;
    } on DioError catch (e) {
      Logger.e('Ошибка при отписке $e');
      rethrow;
    }
  }

  Future<Map<String, dynamic>> getProfileLists(String token, int id) {
    throw UnimplementedError();
  }

  Future<Map<String, dynamic>> getProfilePosts(String token, int id) {
    throw UnimplementedError();
  }
}
