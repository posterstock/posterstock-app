import 'package:dio/dio.dart';
import 'package:poster_stock/common/data/dio_keeper.dart';

class ProfileService {
  final Dio _dio = DioKeeper.getDio();

  Future<List<Map<String, dynamic>>> getUserPosts(int? id) async {
    final response = await _dio.get(
      'api/posters/users/$id',
      options: Options(headers: {}),
    );
    final List<Map<String, dynamic>> result = [];
    for (var a in response.data) {
      result.add(a);
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> getUserLists(int? id) async {
    final response = await _dio.get(
      'api/lists/users/$id',
      options: Options(headers: {}),
    );
    final List<Map<String, dynamic>> result = [];
    for (var a in response.data) {
      result.add(a);
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getProfileInfo(int? id) async {
    try {
      if (id == null) {
        try {
          print(17);
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
      final response = await _dio.get(
        'api/users/$id',
        options: Options(headers: {}),
      );
      print(response);
      return response.data;
    } on DioError catch (e) {
      print(e.response);
      rethrow;
    }
  }

  Future<void> follow(int? id, bool follow) async {
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
