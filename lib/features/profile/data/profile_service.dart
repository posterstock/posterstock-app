import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:poster_stock/features/profile/data/i_profile_service.dart';
import 'package:supertokens_flutter/dio.dart';
import 'package:supertokens_flutter/supertokens.dart';

class ProfileService implements IProfileService {
  final Dio _dio = Dio(
    BaseOptions(
      baseUrl: 'https://api.posterstock.co/',
      connectTimeout: 10000,
      receiveTimeout: 10000,
      maxRedirects: 5,
    ),
  );

  ProfileService() {
    _dio.interceptors.add(SuperTokensInterceptorWrapper(client: _dio));
  }

  Future<List<Map<String, dynamic>>> getUserPosts(String token, int? id) async {
    final response = await _dio.get(
      'api/posters/users/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final List<Map<String, dynamic>> result = [];
    for (var a in response.data) {
      result.add(a);
    }
    return result;
  }

  Future<List<Map<String, dynamic>>> getUserLists(String token, int? id) async {
    final response = await _dio.get(
      'api/lists/users/$id',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final List<Map<String, dynamic>> result = [];
    for (var a in response.data) {
      result.add(a);
    }
    return result;
  }

  @override
  Future<Map<String, dynamic>> getProfileInfo(String token, int? id) async {
    try {
      if (id == null) {
        try {
          print(17);
          final response = await _dio.get(
            'api/profiles/',
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
              },
            ),
          );
          return response.data;
        } on DioError catch (e) {
          print(e.response);
        } catch (e) {
          rethrow;
        }
      }
      final response = await _dio.get(
        'api/users/$id',
        options: Options(headers: {'Authorization': 'Bearer $token'}),
      );
      print(response);
      return response.data;
    } on DioError catch (e) {
      print(e.response);
      rethrow;
    }
  }

  Future<void> follow(String token, int? id, bool follow) async {
    try {
      if (follow) {
        print(1);
        try {
          final response = await _dio.post(
            '/api/users/$id/follow/',
            options: Options(
              headers: {
                'Authorization': 'Bearer $token',
              },
            ),
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
        options: Options(
          headers: {
            'Authorization': 'Bearer $token',
          },
        ),
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
