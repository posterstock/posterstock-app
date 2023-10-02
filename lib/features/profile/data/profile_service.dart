import 'package:dio/dio.dart';
import 'package:poster_stock/common/data/dio_keeper.dart';

class ProfileService {
  final Dio _dio = DioKeeper.getDio();

  String? bookmarksCursor;
  String? postsCursor;
  int? id;

  Future<(List<Map<String, dynamic>>?, bool)> getUserPosts(int? id, {bool restart = false}) async {
    print(id != this.id);
    if (id != this.id) postsCursor = null;
    if (restart) postsCursor = null;
    this.id = id;
    final response = await _dio.get(
      'api/posters/users/$id',
      options: Options(headers: {}),
        queryParameters: {
          'cursor' : postsCursor,
        }
    );
    final List<Map<String, dynamic>> result = [];
    print(response);
    postsCursor = response.data['next_cursor'];
    for (var a in response.data['posters'] ?? []) {
      result.add(a);
    }
    return (result, !response.data['has_more']);
  }

  Future<List<Map<String, dynamic>>> getUserLists(int? id) async {
    final response = await _dio.get(
      'api/lists/users/$id',
      options: Options(headers: {}),
    );
    print(response);
    final List<Map<String, dynamic>> result = [];
    for (var a in response.data) {
      result.add(a);
    }
    return result;
  }

  Future<(List<dynamic>?, bool)> getMyBookmarks({bool restart = false}) async {
    if (restart) {
      bookmarksCursor = null;
    }
    final response = await _dio.get(
      'api/bookmarks/my',
      queryParameters: {
        'cursor' : bookmarksCursor,
      }
    );
    bookmarksCursor = response.data['next_cursor'];
    return (response.data['entries'] as List<dynamic>?, !response.data['has_more']);
  }

  @override
  Future<Map<String, dynamic>> getProfileInfo(dynamic id) async {
    print(id);
    print('fewf');
    try {
      if (id == null) {
        print("NULL");
        try {
          final response = await _dio.get(
            'api/profiles/',
            options: Options(
            ),
          );
          return response.data;
        } on DioError catch (e) {
          print(e.response);
          print(e.response?.headers);
        } catch (e) {
          rethrow;
        }
      }
      Response response;
      if (id is String) {
        print("STRING");
        response = await _dio.get(
          'api/users/u/$id',
          options: Options(headers: {}),
        );
      } else {
        print("INT");
        response = await _dio.get(
          'api/users/$id',
          options: Options(headers: {}),
        );
      }
      print(response);
      return response.data;
    } on DioError catch (e) {
      print(e.response);
      rethrow;
    }
  }

  Future<void> follow(int? id, bool follow) async {
    print(12);
    print(follow);
    print(id);
    print(13);
    try {
      if (follow) {
        print(1);
        try {
          final response = await _dio.post(
            '/api/users/$id/follow/',
          );
          print(12);
          print(response.statusCode);
          return response.data;
        } on DioError catch (e) {
          print(e.response?.headers);
        } catch (e) {
          rethrow;
        }
      }
      print(2);
      final response = await _dio.post(
        '/api/users/$id/unfollow/',
      );
      print(11);
      print(response.statusCode);
      return response.data;
    } on DioError catch (e) {
      print(e.response?.headers);
      print(e.response);
      rethrow;
    }
  }

  @override
  Future<Map<String, dynamic>> getProfileLists(String token, int id) {
    // TODO: implement getProfileLists
    throw UnimplementedError();
  }

  @override
  Future<Map<String, dynamic>> getProfilePosts(String token, int id) {
    // TODO: implement getProfilePosts
    throw UnimplementedError();
  }
}
